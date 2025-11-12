#' Grab object_params for all data_assets for the current EPI pipeline.
#'
#' This function grabs the data_asset configuration (i.e. the object_params)
#'  from the hidden pipeline state environment. These hold information such as
#'  the paramaterised paths for retrieving / storing the data_asset.
#'
#'
#' @param ... For internal use. Leave empty.
#' @param p_e  For internal use. The hidden pipeline state environment.
#' @param call For internal use. Used for error tracing.
#'
#' @returns A tibble with object_params.
#'
#' @export
grab_object_table <- function(..., p_e = pipeline_env, call = parent.frame()) {
  check_dots_empty()
  check_pipeline_init(p_e = p_e, call = call)

  # this data.frame has only list cols, only some need to be unnested by
  # 'unnest_longer'. NB i tried simply bind_rows(p_e$object_param_list) but this
  # expands the list cols we don't want to expand
  object_param_list <- p_e$object_param_list |>
    map(vec_rbind) |>
    bind_rows() |>
    mutate(data_asset_name = names(p_e$object_param_list), .before = 1)

  # which cols have all values of length 1 or 0 (for NULLs)
  nonlistcol <- object_param_list |>
    summarise(across(
      everything(),
      \(col) all(map_lgl(col, \(x) length(x) <= 1))
    )) |>
    keep(\(x) x)

  object_param_list |> unnest_longer(names(nonlistcol), keep_empty = TRUE)
}
