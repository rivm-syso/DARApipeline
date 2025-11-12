test_that("pipeline_status fails", {
  local_logger_sink()
  expect_invisible(pipeline_status())
})
