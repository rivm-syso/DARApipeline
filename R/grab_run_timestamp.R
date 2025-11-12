#' Grab the run_timestamp for the current EPI pipeline.
#'
#' @description
#' Grabs and returns the used run_timestamp.
#' @returns A string in the form YYYMMDD_HHMM
#'
#' @md
#' @export
#' @inheritParams grab_object_table
grab_run_timestamp <- function(..., p_e = pipeline_env, call = parent.frame()) {
  check_dots_empty()
  check_pipeline_init(p_e, call = call)
  p_e$run_timestamp
}
