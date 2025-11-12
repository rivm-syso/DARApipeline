test_that("pipeline_render_report gives correct error when incorrect parameter types are used", {
  local_logger_sink()

  expect_error( # test markdown_file parameter
    pipeline_render_report(markdown_file = "",
                           output_file = "test.html",
                           add_timestamp = TRUE,
                           custom_markdown_path = "",
                           custom_output_path = "",
                           quiet = TRUE),
    "must be a single string, not"
  )

  expect_error( # test output_file parameter
    pipeline_render_report(markdown_file = "test.Rmd",
                           output_file = ,
                           add_timestamp = TRUE,
                           custom_markdown_path = "",
                           custom_output_path = "",
                           quiet = TRUE),
    "must be a single string, not"
  )

  expect_error( # test add_timestamp parameter
    pipeline_render_report(markdown_file = "test.Rmd",
                           output_file = "test.html",
                           add_timestamp = 1,
                           custom_markdown_path = "",
                           custom_output_path = "",
                           quiet = TRUE),
    "must be `TRUE` or `FALSE`, not"
  )

  expect_error( # test custom_markdown_path parameter
    pipeline_render_report(markdown_file = "test.Rmd",
                           output_file = "test.html",
                           add_timestamp = TRUE,
                           custom_markdown_path = c(0, 0, 0),
                           custom_output_path = "",
                           quiet = TRUE),
    "must be a single string, not"
  )

  expect_error( # test custom_markdown_path parameter
    pipeline_render_report(markdown_file = "test.Rmd",
                           output_file = "test.html",
                           add_timestamp = TRUE,
                           custom_markdown_path = "",
                           custom_output_path = 0.57,
                           quiet = TRUE),
    "must be a single string, not"
  )

  expect_error( # test custom_markdown_path parameter
    pipeline_render_report(markdown_file = "test.Rmd",
                           output_file = "test.html",
                           add_timestamp = TRUE,
                           custom_markdown_path = "",
                           custom_output_path = "",
                           quiet = "TRUE"),
    "must be `TRUE` or `FALSE`, not"
  )
})

test_that("Check path helper gives correct errors", {
  local_logger_sink()

  expect_error( # tests that markdown file in default path can't be found
    check_path_helper(path = test_path("fixtures", "report"),
      file = "dummy_repor.Rmd" # Note the missing "t".
    ),
    "please specify an existing path to the file."
  )
})

test_that("Check path helper returns correct paths", {
  local_logger_sink()
  default_path <- test_path("fixtures", "report")
  custom_path <- test_path("fixtures", "custom_report")

  # Default
  expect_identical(
    check_path_helper(path = default_path,
                      file = "dummy_report.Rmd"),
    test_path("fixtures", "report", "dummy_report.Rmd")
  )

  expect_identical(
    check_path_helper(path = default_path,
                      file = "dummy_report.html"),
    test_path("fixtures", "report", "dummy_report.html")
  )

  # Custom
  expect_identical(
    check_path_helper(path = custom_path,
                      file = "custom_dummy_report.Rmd"),
    test_path("fixtures", "custom_report", "custom_dummy_report.Rmd")
  )

  expect_identical(
    check_path_helper(path = custom_path,
                      file = "custom_dummy_report.html"),
    test_path("fixtures", "custom_report", "custom_dummy_report.html")
  )

})

test_that("Extension helper returns warning when extension is not present", {
  local_logger_sink()

  expect_message(
    check_extension_helper(filename = "testing",
                           ext = ".pdf"),
    "Can't find extension in"
  )
})

test_that("pipeline_render_report gives correct error if out directory has no write acces", {
  local_logger_sink()
  setup_pipeline_init()

  expect_error(pipeline_render_report(markdown_file = "dummy_report.Rmd",
                                      output_file = "dummy_report.html",
                                      custom_markdown_path = test_path("fixtures", "report"),
                                      custom_output_path = "/sys"),
    "You have no write acces to "
  )
})

test_that("pipeline_render_report gives correct error if output directory hasen't been created", {
  local_logger_sink()
  setup_pipeline_init()

  expect_error(pipeline_render_report(markdown_file = "dummy_report.Rmd",
                                      output_file = "dummy_report.html",
                                      custom_markdown_path = test_path("fixtures", "report"),
                                      custom_output_path = "/sys/test"),
    "Unable to create output directory "
  )
})

test_that("Check_extension_helper gives error when another, not expected extension is present in the filename.", {
  local_logger_sink()
  # Checking for messages doesn't work nicely, checking for output instead.
  expect_error(
    check_extension_helper(filename = "testing.txt",
                           ext = ".Rmd"),
    "A different extension has been supplied to"
  )
})

test_that("Check_extension_helper returns the desired output if extension is already present.", {
  local_logger_sink()

  expect_identical(
    check_extension_helper(filename = "testing.Rmd",
                           ext = ".Rmd"),
    "testing.Rmd"
  )
})

test_that("Check_extension_helper return correct extension if the user didn't supply this.", {
  local_logger_sink()

  expect_identical(
    check_extension_helper(filename = "testing",
                           ext = ".Rmd"),
    "testing.Rmd"
  )
})
