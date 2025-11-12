#' @title open connection
#' @description
#' Helper function to open connection used in:
# - open_tbl_con
# - get_sp_data
#'
#' @param con_specs List. Connection arguments for the database. It should be a
#'   named list with the names "name"/"con_args"/"tbl_args". con_args should be
#'   a named character with entries "server"/"database"/"uid"/"pwd" and tbl_args
#'   should be a named character with the entries
#'   "dbcatalog"(optional)/dbschema"/"dbtable".
#'
#' @returns con
#' @keywords internal
#'
open_con <- function(con_specs) {
  log_info("Attempting to connect to {.val {con_specs$name}}")
  check_installed("odbc")
  # use default drv and driver for con (most common situation)
  CON_ARGS_DEFAULT <- list(drv = odbc::odbc(),
                           driver = "ODBC Driver 17 for SQL Server")
  # use drv and driver (if) given in [con_specs]
  con_args <- inheriting_merge(CON_ARGS_DEFAULT, con_specs$con_args)

  # open connection
  con <- do.call(dbConnect, con_args)
  log_info("Succesfully connected!")

  con
}
