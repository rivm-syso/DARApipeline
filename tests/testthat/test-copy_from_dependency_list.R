test_that("copy_asset copies asset", {
  local_logger_sink()
  run_timestamp <- "20240710_1957"
  setup_pipeline_init(run_timestamp = run_timestamp, config_folder = "config_2")

  copy_path <- copy_asset("obj_H", p_e = pipeline_env, call = parent.frame(), test_mode = TRUE)
  print(copy_path)
  expect_true(file.exists(copy_path))
  file.remove(copy_path)
})

test_that("get_copy_from_dir_path gives correct copy-from-path", {
  local_logger_sink()
  run_timestamp <- "20240710_1957"
  setup_pipeline_init(run_timestamp = run_timestamp, config_folder = "config_2")

  expect_identical(get_copy_from_file_path("obj_H",
                                           p_e = pipeline_env,
                                           call = parent.frame(),
                                           test_mode = TRUE),
                   test_path("fixtures/outputs/20240710_1957/obj_H_20240710_1957.csv"))
})

test_that("get_copy_to_dir_path gives correct copy-to-path", {
  local_logger_sink()
  run_timestamp <- "20240710_1957"
  setup_pipeline_init(run_timestamp = run_timestamp, config_folder = "config_2")

  expect_identical(get_copy_to_dir_path("obj_H", p_e = pipeline_env, call = parent.frame()),
                   "tests/testthat/fixtures/data/copied/")
})
