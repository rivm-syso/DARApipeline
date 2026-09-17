test_that("copy_asset copies asset", {
  local_logger_sink()
  run_timestamp <- "20240710_1957"
  setup_pipeline_init(run_timestamp = run_timestamp, config_folder = "config_2")

  copy_path <- copy_asset("obj_H", p_e = pipeline_env, call = parent.frame(), test_mode = TRUE)
  print(copy_path)
  expect_true(file.exists(copy_path))
  file.remove(copy_path)
})

test_that("get_copy_from_file_path gives correct copy-from-path", {
  local_logger_sink()
  run_timestamp <- "20240710_1957"
  setup_pipeline_init(run_timestamp = run_timestamp,
                      config_folder = "config_2")

  expect_identical(get_copy_from_file_path("obj_H",
                                           p_e = pipeline_env,
                                           call = parent.frame(),
                                           test_mode = TRUE),
                   test_path("fixtures/outputs/20240710_1957/obj_H_20240710_1957.csv"))
})

test_that("get_copy_to_dir_path gives correct copy-to-path", {
  local_logger_sink()
  run_timestamp <- "20240710_1957"
  setup_pipeline_init(run_timestamp = run_timestamp,
                      config_folder = "config_2")

  expect_identical(get_copy_to_dir_path("obj_H", p_e = pipeline_env, call = parent.frame()),
                   "tests/testthat/fixtures/data/copied/")
})


test_that("get_copy_from_file_path gives error when no/wrong copy_to_file_path param is given", {
  local_logger_sink()
  run_timestamp <- "20240710_1957"

  setup_pipeline_init(run_timestamp = run_timestamp,
                      config_folder = "config_2")

  expect_error(
    get_copy_to_dir_path("obj_F"),
    "Please define a"
  )
})


test_that("copy_asset gives error when no object can be found", {
  local_logger_sink()
  run_timestamp <- "20240710_1957"

  setup_pipeline_init(run_timestamp = run_timestamp,
                      config_folder = "config_2")

  expect_error(
    copy_asset("obj_F", test_mode = TRUE),
    "Please define a "
  )
})


test_that("sets overwrite to FALSE, when no parameter has been supplied", {
  local_logger_sink()
  run_timestamp <- "20240710_1957"
  setup_pipeline_init(
    run_timestamp = run_timestamp,
    config_folder = "config_2"
  )
  expect_warning(
    expect_message(copy_asset("obj_G_no_overwrite", test_mode = TRUE),
                   "Manually setting ")
  )
})

test_that("copy_asset gives correct message when overwrite is false", {
  local_logger_sink()
  run_timestamp <- "20240710_1957"
  setup_pipeline_init(
    run_timestamp = run_timestamp,
    config_folder = "config_2"
  )

  expect_warning(
    copy_asset("obj_H_no_overwrite", test_mode = TRUE),
    "File already exists and "
  )
})
