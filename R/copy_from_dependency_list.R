#' Copy single asset
#'
#' @description
#' This functions copies an object/data to a given location under `copy_to_file_path` in object_definitions.yaml.
#'
#' @param data_asset_name Character. Name of object, as defined in object_definitions.yaml.
#' @param p_e  For internal use. The hidden pipeline state environment.
#' @param call For internal use. Used for error tracing.
#' @param test_mode For internal use. Boolean to inject `test_path()`
#'                  into file paths for testing purposes. Default = FALSE
#'
#' @returns NULL
#'
#' @md
#' @export
copy_asset <- function(data_asset_name, p_e = pipeline_env, call = parent.frame(), test_mode = FALSE) {
  check_data_asset(data_asset_name, c("data", "other", "object"), p_e, call = call)
  object_params <- p_e$object_param_list[[data_asset_name]]
  copy_from_file_path <- get_copy_from_file_path(data_asset_name, p_e, call = call, test_mode = test_mode)
  copy_to_dir_path <- get_copy_to_dir_path(data_asset_name, p_e, call = call)
  overwrite <- object_params$overwrite

  if (is.null(overwrite)) {
    log_info("No {.val overwrite parameter} has been found in {.val object_definitions.yaml}!")
    log_info("Manually setting {.var overwrite parameter} to {.val FALSE}...")
    overwrite <- FALSE
  }

  log_info("Attempting to copy {.val {data_asset_name}} from {.val {copy_from_file_path}} to {.val {copy_to_dir_path}}")
  tryCatch(
    {
      dir.create(copy_to_dir_path, showWarnings = FALSE, recursive = TRUE)
      copy_to_file_path <- file.path(copy_to_dir_path, basename(copy_from_file_path))
      file.copy(from = copy_from_file_path,
                to = copy_to_file_path,
                overwrite = overwrite)
    },
    error = function(e) {
      cli_abort(
        c(
          "!" = "Something went wrong whilst trying to copy: {.val {data_asset_name}}",
          "i" = "Original error message: {.val e$message}"
        ),
        call = call
      )
    }
  )

  if (file.exists(file.path(copy_to_file_path, basename(copy_from_file_path)))) {
    log_info("Successfully copied {.val {copy_from_file_path}} to {.val {copy_to_file_path}}")
  }

  return(copy_to_file_path)
}

#' Get the copy from file path from object_definitions
#'
#' @description
#' This functions uses the output_dir of a data_asset to determine where the object can be copied from.
#'
#' @param data_asset_name Character.
#' @param p_e  For internal use. The hidden pipeline state environment.
#' @param call For internal use. Used for error tracing.
#'
#' @returns string with filepath to copy from
#'
#' @keywords internal
#' @md
get_copy_from_file_path <- function(data_asset_name, p_e, call = parent.frame(), test_mode = FALSE) {
  object_params <- p_e$object_param_list[[data_asset_name]]
  # use output_dir for objects and dir_output for data in datasource

  if (!is.null(object_params$output_dir) &&
        (is.null(object_params$dir_output) || is.na(object_params$dir_output))) {
    from_dir_path <- object_params$output_dir
  } else if (!(is.null(object_params$dir_output) || is.na(object_params$dir_output))) {
    from_dir_path <- object_params$dir_output
  } else {
    cli_abort("Can't find file for copy for {.val {data_asset_name}} in {.file {object_params$source_path}}!
                If you want to copy data, please define a `dir_output`")
  }

  if (test_mode) {
    log_info("{.var TEST mode} is {.val Enabled}: injecting {.val test_path()} into {.var from_dir_path}...")
    from_dir_path <- test_path(from_dir_path)
  }

  # Extra try catch to update `most_recent_file` error message for `copy_asset` run.
  tryCatch(
    {
      copy_from_file_path <- most_recent_file(
        dir = file.path(from_dir_path),
        pattern = data_asset_name,
        show_found_files = FALSE
      )
    },
    error = function(e) {
      cli_abort(
        c(
          "!" = "Can't find the {.val {data_asset_name}} object in {.val {from_dir_path}}.",
          "i" = "Perhaps {.fn copy_asset} has been called before {.fn pipeline_run}?"
        ),
        call = call
      )
    }
  )

  return(copy_from_file_path)
}

#' Get the copy to dir path from object_definitions
#'
#' @description
#' Retrieve the given location under `copy_to_file_path` in object_definitions.yaml.
#'
#' @param data_asset_name Character.
#' @param p_e  For internal use. The hidden pipeline state environment.
#' @param call For internal use. Used for error tracing.
#'
#' @returns string with filepath to copy to
#'
#' @keywords internal
#' @md
get_copy_to_dir_path <- function(data_asset_name, p_e, call = parent.frame()) {
  object_params <- p_e$object_param_list[[data_asset_name]]

  if (is.null(object_params$copy_to_file_path)) {
    cli_abort("Please define a {.var copy_to_file_path} for {.val {data_asset_name}} in config file {.file object_definitions.yml}!") # nolint: line_length_linter
  } else {
    copy_to_file_path <- object_params$copy_to_file_path
  }

  return(copy_to_file_path)
}
