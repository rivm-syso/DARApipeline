test_that("check_data_asset fails with no arguments", {
  expect_error(check_data_asset(), "is missing")
})

test_that("check_data_asset fails with wrong data_assets", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  wrong_data_asset_name <- "wrong_data_asset_name"
  expect_error(check_data_asset(wrong_data_asset_name,
                                types = c("object", "other", "data"),
                                p_e = pipeline_env), wrong_data_asset_name)
})

test_that("all 'object' objects are correctly found by check_data_asset", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  all_objects <- grab_object_table() |>
    filter(type == "object") |>
    pull(data_asset_name)

  # First, only check a single object
  expect_invisible(check_data_asset(all_objects[1], "object", p_e = pipeline_env))
  # Then, a list of objects (all_objects)
  expect_invisible(check_data_asset(all_objects, "object", p_e = pipeline_env))
})

test_that("all 'data' objects are correctly found by check_data_asset", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  all_data <- grab_object_table() |>
    filter(type == "data") |>
    pull(data_asset_name)

  # First, only check a single data object
  expect_invisible(check_data_asset(all_data[1], "data", p_e = pipeline_env))
  # Then, a list of objects (all_data)
  expect_invisible(check_data_asset(all_data, "data", p_e = pipeline_env))
})

test_that("all 'other' objects are correctly found by check_data_asset", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  all_data <- grab_object_table() |>
    filter(type == "other") |>
    pull(data_asset_name)

  # First, only check a single data object
  expect_invisible(check_data_asset(all_data[1], "other", p_e = pipeline_env))
  # Then, a list of objects (all_data)
  expect_invisible(check_data_asset(all_data, "other", p_e = pipeline_env))
})

test_that("combinations of objects are correctly found by check_data_asset", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  all_other_data <- grab_object_table() |>
    filter(type %in% c("other", "data")) |>
    pull(data_asset_name)

  all_other_object <- grab_object_table() |>
    filter(type %in% c("other", "object")) |>
    pull(data_asset_name)

  all_object_data <- grab_object_table() |>
    filter(type %in% c("object", "data")) |>
    pull(data_asset_name)

  all_object_data_other <- grab_object_table() |>
    filter(type %in% c("object", "data", "other")) |>
    pull(data_asset_name)

  # other + data
  expect_invisible(check_data_asset(all_other_data, c("other", "data"), p_e = pipeline_env))
  # other + object
  expect_invisible(check_data_asset(all_other_object, c("other", "object"), p_e = pipeline_env))
  # object + data
  expect_invisible(check_data_asset(all_object_data, c("object", "data"), p_e = pipeline_env))
  # object + data + other
  expect_invisible(check_data_asset(all_object_data_other, c("object", "data", "other"), p_e = pipeline_env))
})
