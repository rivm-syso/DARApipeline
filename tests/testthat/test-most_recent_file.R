test_that("Find only the most recent with correct timestamp/pattern/ext", {
  dir_temp <- withr::local_tempdir()

  files <- withr::local_file(list(
    f1 = path(dir_temp, "dummyfile_20220101_0001.ext1"),
    f2 = path(dir_temp, "dummyfile_20220101_0002.ext1"),
    f3 = path(dir_temp, "dummyfile_20220101_0002.ext2"),
    f4 = path(dir_temp, "wrongfile_20220101_0011.ext1")
  ))
  fs::file_touch(files)
  expect_identical(
    most_recent_file(
      dir = dir_temp,
      pattern = ".",
      ext = "",
      show_found_files = FALSE
    ),
    files[["f4"]]
  )
  expect_identical(
    most_recent_file(
      dir = dir_temp,
      pattern = "dummyfile",
      ext = "",
      show_found_files = FALSE
    ),
    files[["f2"]]
  )
  expect_identical(
    most_recent_file(
      dir = dir_temp,
      pattern = "dummyfile",
      ext = "ext1",
      show_found_files = FALSE
    ),
    files[["f2"]]
  )
  fs::file_touch(files[["f4"]])
  expect_identical(
    most_recent_file(
      dir = dir_temp,
      pattern = ".",
      ext = "ext1",
      show_found_files = FALSE
    ),
    files[["f4"]]
  )
})


test_that("Error messages when empty (timestamps)", {
  dir_temp <- withr::local_tempdir()

  files <- withr::local_file(list(
    f1 = path(dir_temp, "dummyfile_20220101_0001.ext1"),
    f2 = path(dir_temp, "dummyfile_20220101_0002.ext1"),
    f3 = path(dir_temp, "dummyfile_20220101_0002.ext2"),
    f4 = path(dir_temp, "wrongfile_20220101_0011.ext1")
  ))
  fs::file_touch(files)
  fs::dir_create(file.path(dir_temp, "empty"))

  # wrong ext
  expect_error(
    {
      most_recent_file(
        dir = dir_temp,
        pattern = "dummyfile",
        ext = "ext3",
        show_found_files = FALSE
      )
    },
    "No files found with `ext`"
  )
  # non-existing folder
  dir_nonexisting <- path(dir_temp, "nonexistingfolder")
  expect_error(
    most_recent_file(
      dir = dir_nonexisting,
      pattern = ".",
      ext = "",
      show_found_files = FALSE
    ),
    regexp = "`dir` .+ does not exist."
  )

  # wrong pattern
  expect_error(
    most_recent_file(
      dir = dir_temp,
      pattern = "wrongpattern",
      ext = "",
      show_found_files = FALSE
    ),
    regexp = "No files found with `pattern`"
  )

  # no files found
  expect_error(
    most_recent_file(
      dir = file.path(dir_temp, "empty"),
      ext = "",
      show_found_files = FALSE
    ),
    regexp = "No files found in "
  )
})

test_that("Error messages when empty (no timestamps)", {
  dir_temp <- withr::local_tempdir()

  files <- withr::local_file(list(
    f1 = fs::path(dir_temp, "dummyfile.ext1"),
    f2 = fs::path(dir_temp, "dummyfile_20220101.ext2")
  ))
  fs::file_touch(files)

  # no timestamped files found
  expect_warning(
    most_recent_file(
      dir = dir_temp,
      pattern = ".",
      ext = "",
      show_found_files = FALSE
    ),
    regexp = "Not one file found with a timestamp in"
  )
})

test_that("paralel inputs", {
  dir_temp1 <- withr::local_tempdir()
  dir_temp2 <- withr::local_tempdir()
  files <- withr::local_file(list(
    f1 = path(dir_temp1, "dummyfile1_20220101_0001.ext1"),
    f2 = path(dir_temp2, "dummyfile2_20220101_0002.ext1")
  ))

  fs::file_touch(files)

  expect_identical(
    most_recent_file(
      dir = c(dir_temp1, dir_temp2),
      pattern = c("dummyfile1", "dummyfile2"),
      ext = "ext1",
      show_found_files = FALSE
    ),
    paste(files)
  )
  expect_error(
    most_recent_file(
      dir = c(dir_temp1, dir_temp2),
      pattern = c("dummyfile1", "dummyfile2"),
      ext = "ext100",
      show_found_files = FALSE
    ),
    "No files found with `ext`"
  )
  expect_error(
    most_recent_file(
      dir = c(dir_temp1, dir_temp2),
      pattern = c("dummyfile1", "dummyfile1", "dummyfile3"),
      ext = "ext1",
      show_found_files = FALSE
    ),
    regexp = "consistent length"
  )
})
