test_that("grab_object_table fails when unnamed arguments are given", {
  DARAutils::local_logger_sink()
  setup_pipeline_init()

  # Example 1: numeric
  expect_error(grab_object_table(1))
  # Example 2: string
  expect_error(grab_object_table("error"))
  # Example 3: boolean
  expect_error(grab_object_table(TRUE))
})

test_that("check that grab_object_table contains all column names that are in the object_param_list", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  # Get actual and expected values
  actual_column_names <- names(grab_object_table())
  expected_column_names <- names(pipeline_env$object_param_list[[1]])

  # Test
  expect_true(all(expected_column_names %in% actual_column_names))
})

test_that("names in column data_asset_name are equal to unique names in object_param_list", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  # Get actual and expected values
  data_asset_names <- grab_object_table()$data_asset_name
  object_param_list_names <- names(pipeline_env$object_param_list)

  # Test
  expect_identical(data_asset_names, object_param_list_names)
})
