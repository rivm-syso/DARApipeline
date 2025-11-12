test_that("pipeline_run",
          {
            local_logger_sink()
            run_timestamp <- "20000101_1010"
            setup_pipeline_init(run_timestamp = run_timestamp)

            expect_identical({
              pipeline_run(objects = "obj_A")
              list.files(str_c("cache/", run_timestamp)) |> str_remove(".rds")
            },
            "obj_A")
            list.files(str_c("cache/", run_timestamp), full.names = TRUE) |> file.remove()
            mark_for_refresh()

            expect_identical({
              pipeline_run(objects = c("obj_A", "obj_B", "obj_C", "obj_D"))
              list.files(str_c("cache/", run_timestamp)) |> str_remove(".rds")
            },
            c("obj_A", "obj_B", "obj_C", "obj_D"))
            list.files(str_c("cache/", run_timestamp), full.names = TRUE) |> file.remove()
            mark_for_refresh()

            expect_identical({
              pipeline_run(tags = "t1")
              list.files(str_c("cache/", run_timestamp)) |> str_remove(".rds")
            },
            c("obj_A", "obj_B"))
            list.files(str_c("cache/", run_timestamp), full.names = TRUE) |> file.remove()
            mark_for_refresh()

            expect_identical({
              pipeline_run(tags = c("t0", "t1"))
              list.files(str_c("cache/", run_timestamp)) |> str_remove(".rds")
            },
            c("obj_A", "obj_B"))
            list.files(str_c("cache/", run_timestamp), full.names = TRUE) |> file.remove()
            mark_for_refresh()
          })

fails_func <- list(list(fn = pipeline_run, params = list(objects = "unk")),
                   list(fn = pipeline_run, params = list(tags = "unk")))

# Use walk to apply each function with its parameter values
walk(fails_func, function(x) {
  test_that("pipeline_run fails",
            {
              local_logger_sink()
              run_timestamp <- "20000101_1010"
              setup_pipeline_init(run_timestamp = run_timestamp)
              expect_error(do.call(x$fn, x$params))
            })
})
