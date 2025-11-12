test_that("save_cache creates a non existing folder if needed", {
  local_logger_sink()

  tmpdir <- withr::local_tempdir()
  suppressWarnings(save_cache(object = cars, "test", tmpdir))
  expect_true(file_exists(path(tmpdir, "test.rds")))
})


test_that("save_cache returns invible null on succes", {
  local_logger_sink()

  tmpdir <- withr::local_tempdir()
  expectedfilepath <- path(tmpdir, "test.rds")
  expect_warning(
    save_cache(object = cars, "test", tmpdir),
    "deprecated"
  )
})

test_that("save_cache saves a file as .rds", {
  local_logger_sink()

  tmpdir <- withr::local_tempdir()
  expectedfilepath <- path(tmpdir, "test.rds")
  suppressWarnings(save_cache(object = cars, "test", tmpdir))
  expect_true(file.exists(expectedfilepath))
})
