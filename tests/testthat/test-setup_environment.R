test_that("setup_environment() works under normal circumstances, when not run interactively",
          {
            local_logger_sink()
            # Init pipeline
            setup_pipeline_init()

            # Init variables
            prepare_script <- "fixtures/scripts/00_prepare/prepare.R"
            p_e <- pipeline_env

            # We have to mock function getSourceEditorContext so that the object name is retrieved correctly
            assign("curr_object", value = "obj_A", envir = .GlobalEnv) # Object name

            cur_env <- .GlobalEnv

            # Expect no error
            expect_invisible(setup_environment(
              cur_env = cur_env,
              prepare_script = test_path(prepare_script),
              p_e = p_e
            ))
          })

test_that("setup_environment() works under normal circumstances, when run interactively", {
  local_logger_sink()
  # No logging
  withr::local_options(list(
    DARApipeline.configdir = test_path("fixtures", "configs", "config"),
    DARApipeline.skiplogging = TRUE
  ))

  # Init variables
  prepare_script <- "fixtures/scripts/00_prepare/prepare.R"
  p_e <- pipeline_env

  # We have to mock function getSourceEditorContext so that the object name is retrieved correctly
  cur_file <- "fixtures/scripts/setup_environment_test_objects/obj_A.R"
  local_mocked_bindings(getSourceEditorContext = function() list(path = cur_file))

  # We also have to mock interactive for this test - set to TRUE
  mockery::stub(setup_environment, "interactive", TRUE)

  cur_env <- .GlobalEnv

  # Expect no error
  expect_invisible(setup_environment(cur_env = cur_env,
                                     prepare_script = test_path(prepare_script),
                                     p_e = p_e))
}
)

test_that("check_usage_dependencies only warns when config dependencies are not used in object", {
  local_logger_sink()
  run_timestamp <- "20000101_1010"
  setup_pipeline_init(run_timestamp = run_timestamp, config_folder = "config_3")

  # obj_A uses all dependencies
  testthat::expect_no_warning(check_usage_dependencies("obj_A"))

  # for obj_C, the dependency abj_A is never used in the script
  testthat::expect_warning(check_usage_dependencies("obj_C"), "it is never used in the object generate script")
})

test_that("check_dependencies_not_listed only warns when config dependencies are not listed in object", {
  local_logger_sink()
  run_timestamp <- "20000101_1010"
  setup_pipeline_init(run_timestamp = run_timestamp, config_folder = "config_3")

  # obj_A uses all dependencies
  testthat::expect_no_warning(check_dependencies_not_listed("obj_A"))

  # for obj_C, the dependency abj_A is never used in the script
  testthat::expect_warning(check_dependencies_not_listed("obj_E"), "but this is not stated in the")
})
