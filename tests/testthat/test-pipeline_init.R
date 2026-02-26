test_that("pipeline_init() gives error when no config is found",
          {
            local_logger_sink()
            # Init pipeline
            withr::local_options(list(
              DARApipeline.configdir = test_path("fixtures", "configs", "not_a_config"),
              DARApipeline.skiplogging = TRUE
            ))
            expect_error(
              pipeline_init()
            )
          })

test_that("pipeline_init() gives two warnings on empty file_path and object_relations config", {
  local_logger_sink()
  # Init pipeline
  withr::local_options(list(
    DARApipeline.configdir = test_path("fixtures", "configs", "config_no_file_paths"),
    DARApipeline.skiplogging = TRUE
  ))

  warnings <- capture_warnings(pipeline_init())

  expect_length(warnings, 2)
  expect_match(warnings[1], "Can't interpret pipeline config.") # file_paths
  expect_match(warnings[2], "Can't interpret pipeline config.") # object_relations
})
