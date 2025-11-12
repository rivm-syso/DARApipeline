#' Grab the drive_name for the current EPI pipeline.
#'
#' @description
#' Part of the experimental pipeline functions.
#'
#' @returns A string in with the drive name
#'
#' @md
#' @export grab_current_drive_name
#' @inheritParams grab_object_table
grab_current_drive_name <- function(..., p_e = pipeline_env, call = parent.frame()) {
  check_dots_empty()
  check_pipeline_init(p_e, call = call)
  p_e$drive_name
}
