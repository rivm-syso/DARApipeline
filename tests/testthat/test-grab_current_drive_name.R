test_that("grab_current_drive_name is equal to value that is set in init_target_mount()", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  # Get expected value
  init_target_mount(pipeline_env)
  target_mount <- target_mount_drive <- system("df -P . | tail -1 | tr -s ' ' | cut -d' ' -f 6 ", intern = TRUE)
  if (startsWith(target_mount, "/mnt/")) {
    expected_current_drive_name <- "r-schijf"
  } else {
    expected_current_drive_name <- "r"
  }

  expect_type(grab_current_drive_name(), "character")
  expect_identical(grab_current_drive_name(), expected_current_drive_name)
})
