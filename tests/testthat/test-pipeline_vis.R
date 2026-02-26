test_that("pipeline_vis success", {
  local_logger_sink()
  setup_pipeline_init()

  expect_snapshot({
    network <- pipeline_vis()
    network[["x"]][c("nodes", "edges")]
  })
})

test_that("pipeline_vis error", {
  local_logger_sink()
  # this is not a warning we want to test but pipeline_init already warns for the empty config
  expect_warning(setup_pipeline_init(config_folder = "config_empty"))

  expect_error(pipeline_vis(), "Can\'t find any pipeline objects")
})
