setup_pipeline_init <- function(run_timestamp = NULL, config_folder = "config") {
  withr::local_options(list(
    DARApipeline.configdir = test_path("fixtures", "configs", config_folder),
    DARApipeline.skiplogging = TRUE
  ))
  pipeline_init(run_timestamp = run_timestamp)
}
