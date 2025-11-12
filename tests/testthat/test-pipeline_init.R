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

test_that("pipeline_init() gives error on empty config",
          {
            local_logger_sink()
            # Init pipeline
            withr::local_options(list(
              DARApipeline.configdir = test_path("fixtures", "configs", "config_no_file_paths"),
              DARApipeline.skiplogging = TRUE
            ))
            expect_error(
              pipeline_init()
            )
          })
