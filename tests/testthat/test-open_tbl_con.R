test_that("wrong arg errors", {
  local_logger_sink()

  # passwords list in correct shape (dummy values)
  passwords <- list(
    prod = list(
      name = "insert_name",
      con_args = list(
        server = "your_server.nl",
        database = "your_database",
        uid = "user",
        pwd = "PASSWORD"
      ),
      tbl_args = list(
        dbschema = "test",
        dbtable = "vw_test"
      )
    )
  )

  # top-layer names missing
  expect_error(
    open_tbl_con(passwords),
    "must be a single string, not "
  )

  # con_args is not list
  passwords1.1 <- passwords
  passwords1.1$prod$con_args <- as.character(passwords$prod$con_args)
  names(passwords1.1$prod$con_args) <- names(passwords1.1$prod$con_args)
  expect_error(
    open_tbl_con(passwords1.1$prod),
    "must be a list, not a "
  )

  # tbl_args is not list
  passwords1.2 <- passwords
  passwords1.2$prod$tbl_args <- as.character(passwords$prod$tbl_args)
  names(passwords1.2$prod$tbl_args) <- names(passwords1.2$prod$tbl_args)
  expect_error(
    open_tbl_con(passwords1.2$prod),
    "must be a list, not a "
  )

  # con_args names missing
  passwords2 <- passwords
  names(passwords2$prod$con_args)[[1]] <- "wrong"
  expect_error(
    open_tbl_con(passwords2$prod),
    "should be in the names of `con_specs.con_args`"
  )

  # tbl_args names missing
  passwords3 <- passwords
  names(passwords3$prod$tbl_args)[[2]] <- "wrong"
  expect_error(
    open_tbl_con(passwords3$prod),
    " not found in `names.con_specs.tbl_args.`"
  )

  # wrong type in name
  passwords4 <- passwords
  passwords4$prod$name <- 1
  expect_error(
    open_tbl_con(passwords4$prod),
    " must be a single string, not "
  )
  # wrong length in name
  passwords5 <- passwords
  passwords5$prod$name <- c("1", "2")
  expect_error(
    open_tbl_con(passwords5$prod),
    " must be a single string, not "
  )

  # wrong type in args
  passwords6 <- passwords
  passwords6$prod$tbl_args$dbtable <- 1
  expect_error(
    open_tbl_con(passwords6$prod),
    " must be a single string or `NULL`, not "
  )

  # wrong length in args
  passwords7 <- passwords
  passwords7$prod$tbl_args$dbtable <- c("1", "2")
  expect_error(
    open_tbl_con(passwords7$prod),
    " must be a single string or `NULL`, not "
  )

  # dummy info shouldn't work
  skip_if(!("ODBC Driver 17 for SQL Server" %in% odbc::odbcListDrivers()$name))
  expect_error(
    open_tbl_con(passwords$prod),
    ""
  )
})
