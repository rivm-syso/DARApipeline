test_that("init_config imports config", {
  local_logger_sink()

  withr::local_options(list(
    DARApipeline.configdir = test_path("fixtures", "configs", "config_2"),
    DARApipeline.skiplogging = TRUE
  ))

  # local pipeline environment
  local_pipeline_env <- new.env()

  expect_error(
    init_config("nonexisting", local_pipeline_env),
    "Config files not found!"
  )
})
