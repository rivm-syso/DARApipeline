test_that("save_output saves csv", {
  local_logger_sink()

  dir_temp <- withr::local_tempdir()
  expect_invisible(
    save_output(
      object = cars,
      object_name = "cars",
      output_dir = dir_temp,
      run_timestamp = "20230109_1201",
      output_formats = "csv"
    )
  )
  expect_true(file_exists(path(dir_temp, "cars_20230109_1201.csv")))
})


test_that("save_output saves xlsx", {
  local_logger_sink()

  dir_temp <- withr::local_tempdir()
  expect_invisible(
    save_output(
      object = cars,
      object_name = "cars",
      output_dir = dir_temp,
      run_timestamp = "20230109_1201",
      output_formats = "xlsx"
    )
  )
  expect_true(file_exists(path(dir_temp, "cars_20230109_1201.xlsx")))
})

test_that("save_output saves csv+xlsx", {
  local_logger_sink()

  dir_temp <- withr::local_tempdir()
  expect_invisible(
    save_output(
      object = cars,
      object_name = "cars",
      output_dir = dir_temp,
      run_timestamp = "20230109_1201",
      output_formats = c("csv", "xlsx")
    )
  )
  expect_true(file_exists(path(dir_temp, "cars_20230109_1201.xlsx")))
  expect_true(file_exists(path(dir_temp, "cars_20230109_1201.csv")))
})

test_that("save_output saves png", {
  local_logger_sink()

  dir_temp <- withr::local_tempdir()
  pl <- ggplot2::ggplot(data = cars)
  expect_invisible(
    save_output(
      object = pl,
      object_name = "cars",
      output_dir = dir_temp,
      run_timestamp = "20230109_1201",
      output_formats = "png"
    )
  )
  expect_true(file_exists(path(dir_temp, "cars_20230109_1201.png")))
})

test_that("save_output saves svg", {
  local_logger_sink()

  dir_temp <- withr::local_tempdir()
  pl <- ggplot2::ggplot(data = cars)
  expect_invisible(
    save_output(
      object = pl,
      object_name = "cars",
      output_dir = dir_temp,
      run_timestamp = "20230109_1201",
      output_formats = "svg"
    )
  )
  expect_true(file_exists(path(dir_temp, "cars_20230109_1201.svg")))
})

test_that("save_output saves png with user defined arguments", {
  local_logger_sink()

  dir_temp <- withr::local_tempdir()
  pl <- ggplot2::ggplot(data = cars)
  expect_invisible(
    save_output(
      object = pl,
      object_name = "cars",
      output_dir = dir_temp,
      run_timestamp = "20230109_1201",
      output_formats = "png",
      output_arguments = list(
        png =
          list(
            width = 10,
            height = 50,
            units = "cm",
            scale = 2
          )
      )
    )
  )
  expect_true(file_exists(path(dir_temp, "cars_20230109_1201.png")))
})

test_that("save_output saves csv with user defined arguments", {
  local_logger_sink()

  dir_temp <- withr::local_tempdir()
  expect_invisible(
    save_output(
      object = cars,
      object_name = "cars",
      output_dir = dir_temp,
      run_timestamp = "20230109_1201",
      output_formats = "csv",
      output_arguments = list(
        csv =
          list(
            eol = "\r\n",
            col_names = FALSE
          )
      )
    )
  )
  expect_true(file_exists(path(dir_temp, "cars_20230109_1201.csv")))
})

test_that("save_output skips unknown output_formats", {
  local_logger_sink()

  dir_temp <- withr::local_tempdir()
  expect_error(
    save_output(
      object = cars,
      object_name = "cars",
      output_dir = dir_temp,
      run_timestamp = "20230109_1201",
      output_formats = "ext_unknown"
    ),
    "Object can't be saved with the `output_format`"
  )
})


test_that("save_output can't find custom function", {
  local_logger_sink()

  dir_temp <- withr::local_tempdir()
  expect_error(
    save_output(
      object = cars,
      object_name = "cars",
      output_dir = dir_temp,
      run_timestamp = "20230109_1201",
      output_formats_custom = list("ext" = "non_existing_function")
    ),
    "Object can't be saved because the custom saving function"
  )
})


test_that("save_output saves with custom functions", {
  local_logger_sink()

  dir_temp <- withr::local_tempdir()
  .GlobalEnv[["custom_f"]] <- readr::write_csv2
  on.exit({
    .GlobalEnv[["custom_f"]] <- NULL
  })
  expect_invisible(
    save_output(
      object = cars,
      object_name = "cars",
      output_dir = dir_temp,
      run_timestamp = "20230109_1201",
      output_formats = character(),
      output_formats_custom = list("csv" = "custom_f")
    )
  )
  expect_true(file_exists(path(dir_temp, "cars_20230109_1201.csv")))
})

test_that("save_output saves with custom functions, not available as default function", {
  local_logger_sink()

  dir_temp <- withr::local_tempdir()
  .GlobalEnv[["custom_f"]] <- function(object, bestand) {
    ggsave(bestand, object,
      device = jpeg, width = 15,
      height = 10, units = "cm", scale = 2
    )
  }
  on.exit({
    .GlobalEnv[["custom_f"]] <- NULL
  })
  pl <- ggplot2::ggplot(data = cars)
  expect_invisible(
    save_output(
      object = pl,
      object_name = "cars",
      output_dir = dir_temp,
      run_timestamp = "20230109_1201",
      output_formats = character(),
      output_formats_custom = list("jpeg" = "custom_f")
    )
  )
  expect_true(file_exists(path(dir_temp, "cars_20230109_1201.jpeg")))
})

test_that(
  "save_output saves with custom functions, not available as default function, with user defined arguments",
  {
    dir_temp <- withr::local_tempdir()
    .GlobalEnv[["custom_f"]] <- function(object, bestand, ...) {
      grDevices::pdf(
        file = bestand,
        paper = "a4",
        ...
      )
      object |> print()
      dev.off()
    }

    on.exit({
      .GlobalEnv[["custom_f"]] <- NULL
    })
    pl <- ggplot2::ggplot(data = cars)
    expect_invisible(
      save_output(
        object = pl,
        object_name = "cars",
        output_dir = dir_temp,
        run_timestamp = "20230109_1201",
        output_formats = character(),
        output_formats_custom = list("pdf" = "custom_f"),
        list(pdf = list(
          height = 29.7 / 2.54,
          width = 21 / 2.54
        ))
      )
    )
    expect_true(file_exists(path(dir_temp, "cars_20230109_1201.pdf")))
  }
)
