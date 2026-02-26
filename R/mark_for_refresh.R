#' Mark data_assets for refresh
#'
#' @description
#'
#' Ensures that data_asset will be reimported by
#'  [pipeline_import_for()] or regenerated during [pipeline_run()] (whichever
#'  comes first).
#'
#'
#' @param data_assets Character. Which data_assets (objects/data/other) should be
#'  refreshed? Defaults to all data_assets of the pipeline.
#'
#' @returns NULL
#'
#' @md
#' @export
#' @inheritParams pipeline_run
mark_for_refresh <- function(data_assets = NULL, ..., p_e = pipeline_env) {
  check_dots_empty()
  check_data_asset(data_assets, c("data", "object", "other"), p_e = p_e)

  object_table <- grab_object_table(p_e = p_e, call = call)
  all_data_assets <- object_table |> pull(.data$data_asset_name)

  data_assets <- data_assets %||% all_data_assets

  data_asset_invalid <- setdiff(data_assets, all_data_assets)
  if (length(data_asset_invalid)) {
    cli_abort(c(
      "!" = "Can't find {.arg data_assets} = {.val {data_asset_invalid}} in the object_table.",
      "i1" = "Valid entries: {all_data_assets}",
      "i2" = "Run {.run DARApipeline::grab_object_table()} to see the object params register."
    ))
  }
  data_assets_imported <- intersect(names(.GlobalEnv), data_assets)

  if (length(data_assets_imported) == 0) {
    return(invisible(NULL))
  }

  log_info("Marking {.val {data_assets_imported}} for refresh.")
  p_e$refresh <- c(p_e$refresh, data_assets_imported)
  return(invisible(NULL))
}
