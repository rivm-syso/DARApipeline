#' @title grab the cache path from the object_table in the pipeline_env
#' @description
#' Function grabs the cache path from the object_table in the pipeline_env. Especially
#' useful when the cache file differs from the standard format cache/{RUN_TIMESTAMP}
#'
#' @param dir_config Path: to directory which holds the configuration files.
#' @param p_e Object: package_environment, internal - do not use
#' @param call Object: the parent environment from return_env, internal - do not use
#'
#' @returns NULL
#' @keywords internal
#' @export

grab_object_cache <- function(object_name,
                              ...,
                              p_e = pipeline_env,
                              call = parent.frame()) {
  check_dots_empty()
  check_pipeline_init(p_e = p_e, call = call)
  check_character(object_name)

  object_table <- grab_object_table(p_e = p_e, call = call)

  cache_directory <- object_table |>
    filter(data_asset_name == object_name) |>
    pull(cache_dir)
  return(cache_directory)
}
