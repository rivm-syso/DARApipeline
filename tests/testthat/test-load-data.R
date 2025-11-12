test_that("load_data throws error when folder does not exist", {
  expect_error(
    load_data(loc = "non_existing_folder", date = as.Date("2000-01-01")),
    "No files found in "
  )
})
