#' Grab the mount for the current EPI pipeline.
#'
#' @description
#' Grabs and returns the current mount for the EPI pipeline.
#' @returns A string in the form of "rivm"
#'
#' @md
#' @export
#' @inheritParams grab_object_table
grab_target_mount <- function(..., p_e = pipeline_env, call = parent.frame()) {
  check_dots_empty()
  check_pipeline_init(p_e, call = call)
  p_e$target_mount
}
