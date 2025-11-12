test_that("grab_run_timestamp is equal to value that run_timestamp is set to in pipeline_init()", {
  DARAutils::local_logger_sink()
  # Init pipeline
  expected_run_timestamp <- "20240101_0000"
  setup_pipeline_init(run_timestamp = expected_run_timestamp)

  # Test
  expect_type(grab_run_timestamp(), "character")
  expect_identical(grab_run_timestamp(), expected_run_timestamp)
})
