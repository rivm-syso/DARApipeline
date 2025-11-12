#' @title Check pipeline init
#' @description
#' Helper function to check pipeline used in:
#' - grab_target_list
#' - grab_current_drive_name
#' - grab_target_mount
#' - grab_run_timestamp
#' - grab_object_table
#' - pipeline_vis
#' - pipeline_status
#'
#' @param p_e Object: package_environment, internal - do not use
#' @param call Object: the parent environment from return_env, internal - do not use
#'
#' @returns call
#' @keywords internal
#'
check_pipeline_init <- function(p_e = pipeline_env, call = parent.frame()) {
  if (is.null(p_e$run_timestamp)) {
    cli_abort(
      c(
        "!" = "Can't find the {.val run_timestamp}.",
        "i" = "Perhaps {.run DARApipeline::pipeline_init()} wasn't run?"
      ),
      call = call
    )
  }
  if (is.null(p_e$object_param_list)) {
    cli_abort(
      c(
        "!" = "Can't find the {.val object_param_list}.",
        "i" = "Perhaps {.run DARApipeline::pipeline_init()} wasn't run?"
      ),
      call = call
    )
  }
  if (is.null(p_e$object_dag)) {
    cli_abort(
      c(
        "!" = "Can't find the {.val object_dag}.",
        "i" = "Perhaps {.run DARApipeline::pipeline_init()} wasn't run?"
      ),
      call = call
    )
  }
}
