#' Print a status overview of the EPI pipeline
#'
#' @description
#'
#'  This function prints the current status of the pipeline:
#'  1. Whether the pipeline has been initiated.
#'  2. The initiated run_timestamp.
#'  3. How many objects have been created so far.
#'  4. The location of the log file.
#'
#' @returns NULL
#'
#' @export
#' @inheritParams grab_object_table
pipeline_status <- function(..., p_e = pipeline_env) {
  is_init <- tryCatch(
    {
      check_pipeline_init(p_e = p_e)
      TRUE
    },
    error = function(msg) {
      FALSE
    }
  )
  if (!is_init) {
    log_info("No EPI pipeline has been (succesfully) initiated. (Run {.run DARApipeline::pipeline_init()}}")
    return(invisible(NULL))
  }

  log_info(
    "Pipeline was initiated with {.var run_timestamp} = {.val {grab_run_timestamp(p_e = p_e)}}.
    (Run {.run DARApipeline::grab_run_timestamp()}}"
  )
  log_info(
    "Pipeline was initiated on mount {.var target_mount} = {.val {grab_target_mount(p_e = p_e)}}.
     (Run {.run DARApipeline::grab_target_mount()})"
  )
  log_info(
    "Pipeline was initiated with current drive name {.var drive_name} = {.val {grab_current_drive_name(p_e = p_e)}}.
    (Run {.run DARApipeline::grab_current_drive_name()})"
  )

  object_table <- grab_object_table(p_e = p_e)
  n_data <- sum(object_table$type == "data")
  n_other <- sum(object_table$type == "other")
  n_object <- sum(object_table$type == "object")
  log_info("The object_table contains {n_data} entr{?y/ies} of type {.var data},
           {n_other} entr{?y/ies} of type {.var other} and {n_object} entr{?y/ies} of type {.var other}.
           (Run {.run DARApipeline::grab_object_table()}}")

  n_generated <- object_table |>
    filter(type == "object", is_generated) |>
    nrow()
  log_info("{n_generated} out of {n_object} object{?s} {?has/have} been generated so far.")

  log_info("Log file is located at {.file {p_e$path_log}}")
}
