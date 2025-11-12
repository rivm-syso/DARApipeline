test_that("idle throws error when file not in folder", {
  withr::local_message_sink(withr::local_tempfile())
  withr::local_output_sink(withr::local_tempfile())

  file <- "file_example_idle.txt"
  expect_error(
    idle(".", file, max_mins = 0.05, sleep_mins = .05)
  )
})

test_that("idle continues on when file in folder", {
  withr::local_message_sink(withr::local_tempfile())
  withr::local_output_sink(withr::local_tempfile())
  tmpfile <- withr::local_tempfile()
  system(paste0("touch ", tmpfile))
  expect_null(
    idle(
      dirname(tmpfile),
      file_pattern = basename(tmpfile),
      max_mins = 0.05,
      sleep_mins = .05,
      file_modification_buffer_mins = 0.05
    )
  )
})
