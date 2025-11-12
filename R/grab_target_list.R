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
#'
#' @returns A character of object names.
#'
#' @md
#' @export
#' @inheritParams grab_object_table
grab_target_list <- function(tags = NULL, objects = NULL, ..., p_e = pipeline_env, call = parent.frame()) {
  check_dots_empty()
  check_pipeline_init(p_e = p_e, call = call)

  object_table <- grab_object_table(p_e = p_e, call = call)
  all_tags <- object_table |>
    pull(tag) |>
    unique()

  if (is.null(tags) && is.null(objects)) {
    # if no tags/objects filter given: NULL means all objects
    all_objects <- object_table |>
      filter(type == "object") |>
      arrange(hierarchy_level) |>
      pull(data_asset_name)
    return(all_objects)
  }

  # if any tags/objects filter given: NULL means no objects
  # targets by tags filter
  if (is.null(tags)) {
    targets_tags <- character()
  } else {
    check_tags(tags, p_e = p_e, call = call)
    targets_tags <- object_table |>
      filter(tag %in% tags) |>
      pull(data_asset_name)
  }

  # targets by objects filter
  if (is.null(objects)) {
    check_data_asset(objects, "object", p_e = p_e, call = call)
    targets_objects <- character()
  } else {
    targets_objects <- objects
  }

  targets <- union(targets_tags, targets_objects)
  # target dependencies may include data/other
  targets_indirect <- neighborhood(p_e$object_dag, 2000, targets, "out", 1) |>
    unlist() |>
    names()

  # keep only objects
  object_table |>
    filter(
      data_asset_name %in% c(targets, targets_indirect),
      type == "object"
    ) |>
    arrange(hierarchy_level) |>
    pull(data_asset_name)
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
    pull(tag) |>
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
