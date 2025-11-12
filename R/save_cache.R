#' Save an object to the cache directory
#'
#' @description
#' Saves an object to the cache directory. This function is dependent on DARA's directory structure.
#'
#' save_cache is deprecated as of version 0.6.0.
#'
#' @param object The object that needs to be saved.
#' @param object_name The name of the object. This will be used as filename.
#' @param cache_dir The location of the cache. It is advised to use a timestamped directory.
#'
#' @examples
#' \dontrun{
#' save_cache(cars, "cars", "cache/19000101_0000")
#' }
#'
#' @export
#'
save_cache <- function(object, object_name, cache_dir) {
  check_installed("lifecycle")
  lifecycle::deprecate_warn(
    when = "0.6.0",
    what = "DARApipeline::save_cache()",
    with = "DARApipeline::pipeline_run()",
    details = "with skip_cache: no in the config object_definitions.yaml file"
  )
  cache_file <- str_glue("{cache_dir}/{object_name}.rds")
  if (!dir.exists(cache_dir)) {
    log_info("{.arg cache_dir} doesn't exists, creating {.file {cache_dir}}")
    dir.create(cache_dir, recursive = TRUE)
  }
  if (file.exists(cache_file)) {
    log_warn("Overwriting previous cache on {.file {cache_file}}")
  } else {
    log_info("Caching to {.file {cache_file}}")
  }
  saveRDS(object, cache_file)
  invisible(NULL)
}
