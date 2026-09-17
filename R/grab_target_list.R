#' Grab a list of target objects given tag/object filters.
#'
#' @description Retrieves a list of object(s) given a tag or object filters. This
#'  function is run by \link[DARApipeline]{pipeline_run} internally to determine which target
#'  objects need to be created. It determines which other objects need to be generated in
#'  case of dependencies between objects and returns these even if they fall
#'  outside the tags/objects filter (because they are upstream of the pipeline).
#'  Use this function to figure out which objects \link[DARApipeline]{pipeline_run} will create
#'  without actually running \link[DARApipeline]{pipeline_run} yet.
#'
#'  Note that it only returns **objects** not other types of data_assets
#'  (data/other).
#'
#'
#' @param tags Character. Which tags should be in the list of targets? Defaults
#'  to all tags if objects = NULL.
#' @param objects Character. Which objects should be in the list of targets?
#'  Defaults to all objects if tags = NULL.
#' @param verbose Boolean. Show schedule message for an object or not?
#'  Defaults to FALSE.
#'
#' @returns A character of object names.
#'
#' @md
#' @family Grab functions
#' @export
#' @inheritParams grab_object_table
grab_target_list <- function(tags = NULL, objects = NULL, ..., verbose = FALSE,
                             p_e = pipeline_env, call = parent.frame()) {
  check_dots_empty()
  check_pipeline_init(p_e = p_e, call = call)

  object_table <- grab_object_table(p_e = p_e, call = call)
  all_tags <- object_table |>
    pull(.data$tag) |>
    unique()

  if (is.null(tags) && is.null(objects)) {
    # if no tags/objects filter given: NULL means all objects
    all_objects <- object_table |>
      filter(.data$type == "object") |>
      arrange(.data$hierarchy_level) |>
      pull(.data$data_asset_name)

    # Filter only scheduled objects
    filtered_objects <- filter_scheduled_objects(all_objects, p_e = p_e, call = call)

    # Objects that have been removed due to schedule
    objects_not_run <- setdiff(all_objects, filtered_objects)
    if (length(objects_not_run) > 0 && verbose) {
      log_info("The following objects do not have an active schedule and will not be run: {objects_not_run}")
    }

    return(filtered_objects)
  }

  # if any tags/objects filter given: NULL means no objects
  # targets by tags filter
  if (is.null(tags)) {
    targets_tags <- character()
  } else {
    check_tags(tags, p_e = p_e, call = call)
    targets_tags <- object_table |>
      filter(.data$tag %in% tags) |>
      pull(.data$data_asset_name)
  }

  # targets by objects filter
  if (is.null(objects)) {
    check_data_asset(objects, "object", p_e = p_e, call = call)
    targets_objects <- character()
  } else {
    targets_objects <- objects
  }

  targets <- union(targets_tags, targets_objects)

  # Filter only scheduled objects, before including target dependencies
  targets_filtered <- filter_scheduled_objects(targets, p_e = p_e, call = call)

  # target dependencies may include data/other
  targets_indirect <- neighborhood(p_e$object_dag, 2000, targets_filtered, "out", 1) |>
    unlist() |>
    names()

  # Objects that have been removed due to schedule and are also not dependencies
  targets_not_run <- setdiff(targets, c(targets_filtered, targets_indirect))
  if (length(targets_not_run) > 0 && verbose) {
    log_info("The following objects do not have an active schedule and will not be run: {targets_not_run}")
  }

  # keep only objects
  object_table |>
    filter(
      .data$data_asset_name %in% c(targets_filtered, targets_indirect),
      .data$type == "object"
    ) |>
    arrange(.data$hierarchy_level) |>
    pull(.data$data_asset_name)
}

### Helper functions -----------------------------------------------------------
#' @title Check tags
#' @description
#' Helper function used to check tags
#'
#'
#' @param tags List: list of tags to check
#' @param p_e Object: package_environment, internal - do not use
#' @param call Object: the parent environment from return_env, internal - do not use
#'
#' @returns None
#' @keywords internal
#'
check_tags <- function(tags, p_e, call = parent.frame()) {
  object_table <- grab_object_table(p_e = p_e, call = call)
  all_tags <- object_table |>
    pull(.data$tag) |>
    unique()

  tags_invalid <- setdiff(tags, all_tags)
  if (length(tags_invalid)) {
    cli_abort(
      c(
        "!" = "Can't find {.arg tags} = {.val {tags_invalid}} in the object_table.",
        "i1" = "Valid entries: {all_tags}",
        "i2" = "Run {.run DARApipeline::grab_object_table()} to see the object params register."
      ),
      call = call
    )
  }
}

#' @title Get effective schedule
#' @description
#' Helper function used to get schedule for an object
#'
#'
#' @param object_name Character: name of the object to get schedule from
#' @param p_e Object: package_environment, internal - do not use
#' @param call Object: the parent environment from return_env, internal - do not use
#'
#' @returns schedule of an object
#' @keywords internal
#'
get_effective_schedule <- function(object_name, p_e, call = parent.frame()) {
  check_string(object_name, call = call)

  object_params <- p_e$object_param_list[[object_name]]

  # Object schedule comes before tag schedule
  if (!is.null(object_params$schedule_object)) {
    return(object_params$schedule_object)
  }

  # If no object schedule is defined, look at the tag schedule
  if (!is.null(object_params$schedule_tag)) {
    return(object_params$schedule_tag)
  }

  # NULL if there is no schedule
  NULL
}

#' @title Is schedule active
#' @description
#' Helper function used to check whether a schedule is active
#'
#'
#' @param schedule Character: name of the object to get schedule from
#' @param run_timestamp Character: A string in the form YYYMMDD_HHMM of the current run timestamp
#' @param call Object: the parent environment from return_env, internal - do not use
#'
#' @returns boolean whether schedule is active or not
#' @keywords internal
#'
is_schedule_active <- function(schedule, run_timestamp, call = parent.frame()) {
  # If there is no schedule, object should be created
  if (is.null(schedule)) {
    return(TRUE)
  }

  # Get day and time of the run_timestamp
  run_date <- as.POSIXlt(run_timestamp, format = "%Y%m%d_%H%M")
  day_now <- c("sunday", "monday", "tuesday", "wednesday", "thursday",
               "friday", "saturday")[run_date$wday + 1]

  time_now <- format(run_date, "%H:%M")

  # Check if the current run_timestamp is within one of the defined windows of the schedule
  for (window in schedule) {
    if (tolower(window$day) == day_now &&
          time_now >= window$start &&
          time_now <= window$end) {
      return(TRUE)
    }
  }

  FALSE
}

#' @title Filter scheduled objects
#' @description
#' Helper function used to filter objects based on whether they have an active schedule
#'
#'
#' @param objects Character: name of the object to get schedule from
#' @param p_e Object: package_environment, internal - do not use
#' @param call Object: the parent environment from return_env, internal - do not use
#'
#' @returns Character with objects that have an active (or no) schedule
#' @keywords internal
#'
filter_scheduled_objects <- function(objects, p_e, call = parent.frame()) {
  # If no objects should be made, skip schedule filter
  if (length(objects) == 0) {
    return(objects)
  }

  # Create a boolean mask for objects to keep based on the schedule
  objects_to_keep <- vapply(
    objects,
    FUN.VALUE = logical(1),
    FUN = function(object_name) {
      # Get schedule for each object
      schedule <- get_effective_schedule(object_name, p_e = p_e, call = call)
      # Return whether the schedule is now active (1) or not (0)
      is_schedule_active(schedule = schedule, run_timestamp = p_e$run_timestamp, call = call)
    }
  )

  # Only keep objects with an active (or no) schedule
  objects[objects_to_keep]
}
