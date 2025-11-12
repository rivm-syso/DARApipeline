# success
test_that("pipeline_import_for success", {
  local_logger_sink()
  setup_pipeline_init()
  pipeline_import_for(data_assets = "obj_A")

  expect_identical({
    somedata # var taken from rds file below.
  },
  read_rds("fixtures/data/somedata//somedata_20231115_1234.rds"))

  expect_identical({
    staticdata # var taken from rds below.
  },
  read_rds("fixtures/data/staticdata.rds"))
})

# error
fails_func_import <-
  list(
    list(fn = pipeline_import_for, params = list(data_assets = "unk")),
    list(fn = pipeline_import_for, params = list(data_assets = c("unk", 2)))
  )

# Use walk to apply each function with its parameter values
walk(fails_func_import, function(x) {
  test_that("pipeline_import_for fails",
            {
              local_logger_sink()
              run_timestamp <- "20000101_1010"
              setup_pipeline_init(run_timestamp = run_timestamp)
              expect_error(do.call(x$fn, x$params))
            })
})
