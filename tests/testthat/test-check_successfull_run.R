test_that("check_successfull_run gives correct error when incorrect parameter types are used", {
  local_logger_sink()

  expect_error( # test log_dir parameter
    check_last_successful_run(log_dir = 1957,
                              include_cronjob = FALSE,
                              search_window = 1,
                              search_line = ""),
    "must be a single string, not"
  )

  expect_error( # test include_cronjob parameter
    check_last_successful_run(log_dir = "",
                              include_cronjob = "Yes",
                              search_window = 1,
                              search_line = ""),
    "must be `TRUE` or `FALSE`, not"
  )

  expect_error( # test search_window parameter
    check_last_successful_run(log_dir = "",
                              include_cronjob = FALSE,
                              search_window = "2017",
                              search_line = ""),
    "must be a whole number, "
  )

  expect_error( # test search_line parameter
    check_last_successful_run(log_dir = "",
                              include_cronjob = FALSE,
                              search_window = 1,
                              search_line = 4869204441524121),
    "must be a single string, not"
  )
})

test_that("get_file_list includes cronjob logs if param is set to TRUE", {
  local_logger_sink()

  expect_identical(get_file_list(log_dir = test_path("fixtures", "logs"),
                                 incl_cron = TRUE,
                                 cron_only = FALSE) |>
                     length(),
                   6L)
})

test_that("get_file_list excludes cronjobs logs if param is set to FALSE", {
  local_logger_sink()

  expect_identical(get_file_list(log_dir = test_path("fixtures", "logs"),
                                 incl_cron = FALSE,
                                 cron_only = FALSE) |>
                     length(),
                   4L)
})

test_that("get_file_list only includes cronjob logs if cron_only is set to TRUE", {
  local_logger_sink()

  expect_identical(get_file_list(log_dir = test_path("fixtures", "logs"),
                                 incl_cron = FALSE,
                                 cron_only = TRUE) |>
                     length(),
                   2L)
})

test_that("get_file_list `cron_only` parameter overwrites `incl_cron` parameter", {
  local_logger_sink()

  expect_identical(get_file_list(log_dir = test_path("fixtures", "logs"),
                                 incl_cron = TRUE,
                                 cron_only = TRUE) |>
                     length(),
                   2L)
})

test_that("check_succesfull_run gives correct output when NO completion line in logs is found", {
  local_logger_sink()

  expect_identical(check_last_successful_run(log_dir = test_path("fixtures", "logs"),
                                             search_line = "Bogus completion line!"),
                   NA_character_)
})

test_that("check_succesfull_run gives correct output when completion line in logs is found", {
  local_logger_sink()

  expect_identical(check_last_successful_run(log_dir = test_path("fixtures", "logs"),
                                             search_window = 1),
                   "datasource-dummy_succes.log")
})

test_that("read_log correctly finds completion line 'Save step done!' ", {
  local_logger_sink()

  expect_true(read_log(path = test_path("fixtures", "logs", "datasource-dummy_succes.log"),
                       window = 1,
                       search_line = ""))
})

test_that("read_log correctly finds completion line 'reporting step done!'", {
  local_logger_sink()

  expect_true(read_log(path = test_path("fixtures", "logs", "report-dummy_succes.log"),
                       window = 2,
                       search_line = ""))
})

test_that("read_log correctly finds custom provided completion lines.", {
  local_logger_sink()

  expect_true(read_log(path = test_path("fixtures", "logs", "datasource-dummy_custom_succes.log"),
                       window = 1,
                       search_line = "=== Custom complete message ==="))
})

test_that("read_log correctly decrease search window if numbers exceeds n.o lines.", {
  expect_warning(read_log(path = test_path("fixtures", "logs", "report-dummy_succes.log"),
                          window = 99,
                          search_line = ""),
                 "Adjusting `window` to the number of lines in the file: ")
})
