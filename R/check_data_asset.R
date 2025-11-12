#' @title Check data asset
#' @description
#' Helper function to check data asset
#' Used in:
#' - copy_from_dependency_list
#' - grab_target_list
#' - pipeline_import_for
#' - mark_for_refresh
#' - pipeline_run
#'
#'
#' @param data_assets List: list of data assets to be checked
#' @param types List: list of types to be checked
#' @param p_e Object: package_environment, internal - do not use
#' @param call Object: the parent environment from return_env, internal - do not use
#'
#' @returns None
#' @keywords internal
#'
check_data_asset <- function(data_assets, types, p_e, call = parent.frame()) {
  object_table <- grab_object_table(p_e = p_e, call = call)
  all_data_assets_oftype <- object_table |>
    filter(type %in% types) |>
    pull(data_asset_name)

  data_assets_invalid <- setdiff(data_assets, all_data_assets_oftype)
  if (length(data_assets_invalid)) {
    cli_abort(
      c(
        "!" = "Can't find {.arg data_assets} = {.val {data_assets_invalid}} in the object_table.",
        "i1" = "Valid entries: {all_data_assets_oftype}",
        "i2" = "Run {.run DARApipeline::grab_object_table()} to see the object params register."
      ),
      call = call
    )
  }
}
