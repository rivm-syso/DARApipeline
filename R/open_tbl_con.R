#' Creates an active dbplyr tbl connection to a database
#'
#' @description open_tbl_con() takes a list of database and schema
#'   arguments and connects to a table in the database schema using the function
#'   \link[dplyr]{tbl}.
#'
#'   Since this function returns an active connection to the database it is up
#'   to the user to close the connection when they are done. It is recommended
#'   to not use open_tbl_con() directly, but instead use a (project-specific)
#'   wrapper function that ensures the connection gets closed once the data is
#'   accessed (see examples).
#'
#' @param con_specs List. Connection arguments for the database. It should be a
#'   named list with the names "name"/"con_args"/"tbl_args". con_args should be
#'   a named character with entries "server"/"database"/"uid"/"pwd" and tbl_args
#'   should be a named character with the entries
#'   "dbcatalog"(optional)/dbschema"/"dbtable".
#'
#' @return A list containing an active tbl and connection. Remember to close
#'   the connection once tbl has been used.
#'
#' @examples
#' \dontrun{
#' # import the above yaml
#' passwords <- read_yaml('passwords.yaml')
#'
#' # import function that wraps around open_tbl_con
#' # This could be placed in your projects functions/ folder
#' # or just on top of you import script to keep the import command
#' # easily accessible.
#' get_tab <- function(db_args){
#'   tbl_con <- open_tbl_con(db_args)
#'
#'   # this ensures the connection always gets closed properly
#'   on.exit(dbDisconnect(tbl_con$con))
#'
#'   # This part is project specific. filters and selects etc before
#'   # the collect() command will be done outside of R and may
#'   # significantly increase the fetch time
#'   # returns date of birth and municipality for 3 days in the data
#'   tbl_con$tbl |>
#'     filter(date >= as.Date("2023-01-01"),
#'            date  < as.Date("2023-01-04")) |>
#'     select(date_of_birth, municipality) |>
#'     collect()
#' }
#'
#' # fetch data using wrapper function
#' tab <- get_tab(passwords$prod)
#'
#' }
#'
#'
#'
#' @export

# function to connect to table and collect
# it depends on open_tbl_con_argcheck, open_con and open_tbl
open_tbl_con <- function(con_specs) {
  open_tbl_con_argcheck(con_specs)

  con <- open_con(con_specs)
  tbl_db <- open_tbl(con_specs, con)

  list(tbl = tbl_db, con = con)
}


### Helper functions -----------------------------------------------------------

#' @title Open table connection argument check
#' @description
#' Helper function to check missing/wrong values for con or tbl
#'
#' @param con_specs List. Connection arguments for the database. It should be a
#'   named list with the names "name"/"con_args"/"tbl_args". con_args should be
#'   a named character with entries "server"/"database"/"uid"/"pwd" and tbl_args
#'   should be a named character with the entries
#'   "dbcatalog"(optional)/dbschema"/"dbtable".
#' @param .call Object: the parent environment from return_env, internal - do not use
#'
#' @returns None
#' @keywords internal
#'
open_tbl_con_argcheck <-
  function(con_specs, .call = parent.frame()) {
    # Error message when the data name is missing or is not a character
    check_string(con_specs$name, call = .call)

    check_list(con_specs, call = .call)

    # Error message when function arguments are missing in [con_specs]
    if (!all(hasName(con_specs, c("name", "con_args", "tbl_args")))) {
      cli_abort(
        c("!" = "Incorrect input when importing {.arg con_specs$name}.",
          "x" = "{.val {c('name', 'con_args', 'tbl_args')}} should be in the names of {.arg con_specs}"),
        .call = .call
      )
    }

    # Error message when connection (con) specifications are not organized as a list
    check_list(con_specs$con_args, call = .call)

    # Error message when connection (tbl) specifications are not organized as a list
    check_list(con_specs$tbl_args, call = .call)

    # Error message when connection (con) specifications are missing
    if (!all(hasName(con_specs$con_args, c("server", "uid", "pwd")))) {
      cli_abort(
        c("!" = "Incorrect input when importing {.arg con_specs$name}.",
          "x" = "{.val {c('server', 'uid', 'pwd')}} should be in the names of {.arg con_specs$con_args}"),
        .call = .call
      )
    }

    # Error message when connection (con) specifications are missing
    if (!any(hasName(con_specs$con_args, c("database", "datasource")))) {
      warning(
        str_glue(
          "A 'database' or 'datasource' is missing from the con_specs$con_args in {.arg con_specs}
          - likely a connection won't work!.",
          "\nFor connection via tibco use: datasource",
          "\nFor connection via sql use: database"
        )
      )
    }

    # Error message when table (tbl) specifications are missing
    if (!hasName(con_specs$tbl_args, "dbtable")) {
      cli_abort(
        c("!" = "Incorrect input when importing {.arg con_specs$name}.",
          "x" = "{.val dbtable} not found in {.code names(con_specs$tbl_args)}"),
        .call = .call
      )
    }

    check_string(con_specs$con_args$server,
                 allow_null = TRUE,
                 call = .call)
    check_string(con_specs$con_args$datasource,
                 allow_null = TRUE,
                 call = .call)
    check_string(con_specs$con_args$database,
                 allow_null = TRUE,
                 call = .call)
    check_string(con_specs$con_args$uid,
                 allow_null = TRUE,
                 call = .call)
    check_string(con_specs$con_args$pwd,
                 allow_null = TRUE,
                 call = .call)

    check_string(con_specs$tbl_args$dbcatalog,
                 allow_null = TRUE,
                 call = .call)
    check_string(con_specs$tbl_args$dbschema,
                 allow_null = TRUE,
                 call = .call)
    check_string(con_specs$tbl_args$dbtable,
                 allow_null = TRUE,
                 call = .call)
  }

#' @title open table
#' @description
#' Helper function to access data table (tbl)
#'
#' @param con_specs List. Connection arguments for the database. It should be a
#'   named list with the names "name"/"con_args"/"tbl_args". con_args should be
#'   a named character with entries "server"/"database"/"uid"/"pwd" and tbl_args
#'   should be a named character with the entries
#'   "dbcatalog"(optional)/dbschema"/"dbtable".
#' @param con Connection, which is established with `open_con`
#'
#' @returns tbl_db
#' @keywords internal
#'
open_tbl <- function(con_specs, con) {
  log_info(
    "Attempting to access {.arg dbtable} {.val {con_specs$tbl_args$dbtable}} inside the connection"
  )

  # if dbcatalog is specified in [con_specs]:
  if ("dbcatalog" %in% names(con_specs$tbl_args)) {
    if (!("dbschema" %in% names(con_specs$tbl_args))) {
      cli_abort(
        c("!" = "{.arg dbcatalog} is specified in {.arg con_specs$tbl_args},
          but not {.arg dbschema}! Please supply both!")
      )
    }
    tbl_db <-
      tbl(
        src = con,
        in_catalog(
          con_specs$tbl_args$dbcatalog,
          con_specs$tbl_args$dbschema,
          con_specs$tbl_args$dbtable
        )
      )

    # if dbschema is specified in [con_specs]:
  } else if ("dbschema" %in% names(con_specs$tbl_args)) {
    tbl_db <-  tbl(src = con,
                   in_schema(con_specs$tbl_args$dbschema,
                             con_specs$tbl_args$dbtable))

    # if neither dbcatalog nor dbschema are specified in [con_specs]:
  } else {
    # cli_warn rather than log_warn for testing purposes
    cli_warn(
      c(
        str_c(
          "{.arg dbschema}/{.arg dbcatalog} is missing in {.arg con_specs}, and therefore {.code tbl()} ",
          "called with only {.arg dbtable}. This may lead to conflicts if this particular {.arg dbtable} ",
          "is present in multiple {.arg dbschema} or {.arg dbcatalog}!"
        ),
        i = "It is recommended to specify {.arg dbtable}, {.arg dbschema} and {.arg dbcatalog} in {.arg con_specs}."
      )
    )

    # access the database table
    tbl_db <-  tbl(src = con, con_specs$tbl_args$dbtable)

  }
  log_info("Succesfully accessed {.val {con_specs$tbl_args$dbtable}}!")
  tbl_db
}
