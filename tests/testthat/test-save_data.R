test_that("save_data returns invible null on succes", {
  local_logger_sink()
  tmpdir <- withr::local_tempdir()

  run_timestamp <- lubridate::now() |> format(format = "%Y%m%d_%H%M")
  expect_identical( # using default val for run_timestamp
    invisible(NULL),
    save_data(
      object = cars,
      file_directory = tmpdir
    )
  )
  expect_identical(
    invisible(NULL),
    save_data(
      object = cars,
      file_directory = tmpdir,
      run_timestamp = run_timestamp
    )
  )
  list.files(tmpdir, full.names = TRUE) |>
    file.remove()
})

test_that("save_data returns error with incorrect options", {
  local_logger_sink()
  tmpdir <- withr::local_tempdir()
  expect_error(
    save_data(
      object = cars,
      file_directory = tmpdir,
      save_function_options = list(compress = "Ja, graag"),
      run_timestamp = "20220101_0101"
    ),
    "invalid 'compress' argument"
  )
})
