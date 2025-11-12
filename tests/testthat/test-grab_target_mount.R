test_that("grab_target_mount is equal to value that is set in init_target_mount()", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  # Get expected value
  init_target_mount(pipeline_env)
  expected_target_mount <- pipeline_env$target_mount

  # Test
  expect_type(grab_target_mount(), "character")
  expect_identical(grab_target_mount(), expected_target_mount)
})
