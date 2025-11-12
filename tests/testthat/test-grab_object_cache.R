test_that("grab_object_cache() returns the same value as cache_dir from the config.",
          {
            local_logger_sink()
            # Init pipeline
            setup_pipeline_init()

            expect_type(grab_object_cache("obj_A"), "character")
            expect_identical(grab_object_cache("obj_A"),
                             paste0("cache/", grab_run_timestamp()))
            expect_identical(grab_object_cache("obj_H"),
                             paste0("cache/", grab_run_timestamp() |> substr(0, 4)))
          })
