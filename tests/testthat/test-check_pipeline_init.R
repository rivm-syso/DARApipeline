test_that("Check that when pipeline init goes right, check_pipeline_init works", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  expect_invisible(check_pipeline_init())
})

test_that("Check that when pipeline init gets a wrong argument, check_pipeline_init fails", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  # Example 1: numeric
  expect_error(check_pipeline_init(1))
  # Example 2: character
  expect_error(check_pipeline_init("test"))
  # Example 3: boolean
  expect_error(check_pipeline_init(TRUE))
})

test_that("Check that when pipeline env has no run_timestamp, check_pipeline_init fails", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  run_timestamp <- pipeline_env$run_timestamp
  pipeline_env$run_timestamp <- NULL

  expect_error(check_pipeline_init(), "run_timestamp")

  # Reset to initial values
  pipeline_env$run_timestamp <- run_timestamp
  setup_pipeline_init()
})

test_that("Check that when pipeline env has no object_param_list, check_pipeline_init fails", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  object_param_list <- pipeline_env$object_param_list
  pipeline_env$object_param_list <- NULL

  expect_error(check_pipeline_init(), "object_param_list")

  # Reset to initial values
  pipeline_env$object_param_list <- object_param_list
  setup_pipeline_init()
})

test_that("Check that when pipeline env has no object_dag, check_pipeline_init fails", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  object_dag <- pipeline_env$object_dag
  pipeline_env$object_dag <- NULL

  expect_error(check_pipeline_init(), "object_dag")

  # Reset to initial values
  pipeline_env$object_dag <- object_dag
  setup_pipeline_init()
})
