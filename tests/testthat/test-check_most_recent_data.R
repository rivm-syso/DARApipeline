test_that("check_data_asset fails with no arguments", {
  expect_error(check_most_recent_data(), "is missing")
})

# Some data should have date 2023-11-15
test_that("check_data_asset fails when data is too old", {
  expect_error(check_most_recent_data(dir = test_path("fixtures", "data", "somedata")), "Data is too old!")
})

test_that("check_data_asset fails when data is too old when using run_timestamp", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  expect_error(
    check_most_recent_data(
      dir = test_path("fixtures", "data", "somedata"),
      use_run_timestamp = TRUE
    ),
    "Data is too old!"
  )
})

test_that("check_data_asset tests for day after data timestamp", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init(run_timestamp = "20231116_1200")

  # Data from yesterday
  expect_invisible(check_most_recent_data(
    dir = test_path("fixtures", "data", "somedata"),
    use_run_timestamp = TRUE
  ))

  # Data from yesterday but only accept today
  expect_error(
    check_most_recent_data(
      dir = test_path("fixtures", "data", "somedata"),
      use_run_timestamp = TRUE,
      days_valid_data = 0
    ),
    "Data is too old!"
  )
})

test_that("check_data_asset tests for two days after data timestamp", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init(run_timestamp = "20231117_1200")

  # Data one day too old
  expect_error(
    check_most_recent_data(
      dir = test_path("fixtures", "data", "somedata"),
      use_run_timestamp = TRUE
    ),
    "Data is too old!"
  )

  # Data one day too old
  expect_invisible(
    check_most_recent_data(
      dir = test_path("fixtures", "data", "somedata"),
      use_run_timestamp = TRUE,
      days_valid_data = 2
    ),
    "Data is too old!"
  )
})

test_that("check_data_asset tests for return logical", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init(run_timestamp = "20231117_1200")

  # Data one day too old
  expect_false(
    check_most_recent_data(
      dir = test_path("fixtures", "data", "somedata"),
      use_run_timestamp = TRUE,
      error_on_invalid = FALSE
    )
  )

  # Data one day too old
  expect_true(
    check_most_recent_data(
      dir = test_path("fixtures", "data", "somedata"),
      use_run_timestamp = TRUE,
      days_valid_data = 2,
      error_on_invalid = FALSE
    )
  )
})
