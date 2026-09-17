test_that("pipeline_init() gives error when no config is found",
          {
            DARAutils::local_logger_sink()
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
  DARAutils::local_logger_sink()  # Init pipeline
  withr::local_options(list(
    DARApipeline.configdir = test_path("fixtures", "configs", "config_no_file_paths"),
    DARApipeline.skiplogging = TRUE
  ))

  warnings <- capture_warnings(pipeline_init())

  expect_length(warnings, 2)
  expect_match(warnings[1], "Can't interpret pipeline config.") # file_paths
  expect_match(warnings[2], "Can't interpret pipeline config.") # object_relations
})

test_that("Pipeline_init() gives error when incorrect formats are used for custom stamps", {
  DARAutils::local_logger_sink()
  expect_error(pipeline_init(custom_stamp = 20271957),
               "`custom_stamp` must be a single string or `NULL`, not")

  expect_error(pipeline_init(custom_stamp = TRUE),
               "`custom_stamp` must be a single string or `NULL`, not")

  expect_error(pipeline_init(custom_stamp = c("test1", "test2")),
               "`custom_stamp` must be a single string or `NULL`, not")
})


test_that("pipeline_init() gives error when both run_stamp and custom stamp are provided, give an error.", {
  DARAutils::local_logger_sink()
  expect_error(pipeline_init(run_timestamp = "20251208_0929",
                             custom_stamp = "I'm special"),
               "Both `run_timestamp` and `custom_stamp` detected!")
})

test_that("pipeline_init() adds custom stamp to timestamp.", {
  DARAutils::local_logger_sink()
  withr::local_options(list(
    DARApipeline.configdir = test_path("fixtures", "configs", "config"),
    DARApipeline.skiplogging = TRUE
  ))
  my_custom_stamp = "custom"
  pipeline_init(custom_stamp = my_custom_stamp)

  expect_identical(strsplit(pipeline_env$run_timestamp, "-")[[1]][2],
                   my_custom_stamp)
})

test_that("init_logging() changes log_location correctly when is_custom_stamp is true.", {
  # Mocking of log function is needed to to "handlers on the stack" warning.
  with_mocked_bindings(
    log_warnings = function(...) invisible(NULL),
    log_errors = function(...) invisible(NULL),
    log_messages = function(...) invisible(NULL),
    .package = "DARApipeline",
    {
      DARAutils::local_logger_sink()
      withr::local_options(list(
        DARApipeline.configdir = test_path("fixtures", "configs", "config")
      ))

      my_custom_stamp = "custom2"
      pipeline_init(custom_stamp = my_custom_stamp)

      # Test if the dir is made in the correct location
      init_logging(path_logs = test_path("fixtures", "logs", "custom_stamp"),
                   is_custom_stamp = TRUE,
                   p_e = pipeline_env)
    }
  )
  expect_true(file.exists(test_path("fixtures", "logs", "custom_stamp")))

  log_folder_name <- list.files(test_path("fixtures", "logs", "custom_stamp"))[1]

  # Test if the custom_stamp log_dir only uses year and month.
  parsed_date <- parse_date_time(log_folder_name, orders = "Y%m")
  expect_false(is.na(parsed_date))

  # Test if the custom_stamp log_dir adds a trailing "_multithread
  expect_identical(strsplit(log_folder_name, "_")[[1]][-1], "multithread")

  # Remove testing folders.
  unlink(test_path("fixtures", "logs", "custom_stamp"), recursive = TRUE)
})
