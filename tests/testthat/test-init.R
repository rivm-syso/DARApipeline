test_that("pipeline_init run_timestamp error", {
  local_logger_sink()

  expect_error(
    pipeline_init(1),
    "`run_timestamp` must be a single string or"
  )
  expect_error(
    pipeline_init("lakmsdlkasd"),
    "`run_timestamp` must be a valid date and a stri"
  )
})

test_that("init_run_timestamp sets global run timestamp", {
  local_logger_sink()

  # local pipeline environment
  local_pipeline_env <- new.env()

  # scenario 1: no stamp yet
  expect_identical(
    {
      init_run_timestamp(NULL, local_pipeline_env)
      local_pipeline_env$run_timestamp
    },
    lubridate::now() |> format(format = "%Y%m%d_%H%M")
  )


  # scenario 2: NULL, but old timestamp
  old_timestamp <- local_pipeline_env$run_timestamp
  expect_identical(
    {
      init_run_timestamp(NULL, local_pipeline_env)
      local_pipeline_env$run_timestamp
    },
    old_timestamp
  )

  # scenario 3: use manual timestamp
  local_pipeline_env$run_timestamp <- NULL
  manual_timestamp <- "19010102_1234"
  expect_identical(
    {
      init_run_timestamp(manual_timestamp, local_pipeline_env)
      local_pipeline_env$run_timestamp
    },
    manual_timestamp
  )

  # scenario 4: use manual timestamp, identical to before
  expect_identical(
    {
      init_run_timestamp(manual_timestamp, local_pipeline_env)
      local_pipeline_env$run_timestamp
    },
    manual_timestamp
  )

  # scenario 5: use manual timestamp, different from before
  manual_timestamp2 <- "21010102_1234"
  expect_identical(
    {
      init_run_timestamp(manual_timestamp2, local_pipeline_env)
      local_pipeline_env$run_timestamp
    },
    manual_timestamp2
  )
})
