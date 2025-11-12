#'Retrieves data from a store procedure database within a start and end
#'modification date
#'
#'@description get_sp_data() imports from the sp database with an
#'  infection_code, start_ and end_date.
#'
#'@param con_specs List. Connection arguments for the database. It should be a
#'  named list with the names "con_args"/"sp_args". con_args should be a named
#'  character with entries "server"/"database"/"uid"/"pwd" and sp_args should be
#'  a named character with the entries "sp_name"/"infection_code".
#'@param start_date Date. Records retrieved from the the database will not
#'  preceed this date. May also be a datetime or character string in the form
#'  YYYYMMDD or YYYYMMDD_hhmm. Default = "19000101".
#'@param end_date Date. Records retrieved from the the database will not exceed
#'  this date. May also be a datetime or character string starting with
#'  YYYYMMDD. Default = run_timestamp.
#'@param answer_format Character. Provide questionare answer formats with
#'  "text", "code" or "both".
#'
#'@returns A tibble
#'
#' @examples
#' \dontrun{
#' ```
#' #### yaml password file example
#'connections:
#' sp_inf_disease: # as example, shape of yaml without using variables:
#'   con_args:
#'     server: "YOUR_SERVER"
#'     database: "OWH_DWN_HIS"
#'     uid: "USERNAME"
#'     pwd: "PASSWORD"
#'   sp_args:
#'     sp_name: "DWH_EPIRES"
#'     infection_code: "INF_CODE"
#' ```
#' # import the above yaml
#' passwords <- read_yaml('passwords.yaml')
#'
#' # 'jump back' to august 31st and retrieve data from august 1 to 31
#' data_legi <- get_sp_data(
#'   con_specs = config$connections$sp_inf_disease
#'   start_date  =  "20230801",
#'   end_date  =  "20230831"
#' )
#'
#' }
#'
#'@export
get_sp_data <-
  function(con_specs,
           start_date = "19000101",
           end_date = run_timestamp,
           answer_format = c("text", "code", "both")) {
    # function to connect to store procedure table and collect
    # it depends on  get_sp_data_parse_date, get_sp_data_argcheck,open_con and open_sp
    start_date_parsed <- get_sp_data_parse_date(start_date)
    end_date_parsed <- get_sp_data_parse_date(end_date)
    get_sp_data_argcheck(con_specs)
    answer_format <- arg_match(answer_format)

    con <- open_con(con_specs)
    on.exit(dbDisconnect(con))

    value_vector <- case_when(
      answer_format == "text" ~ "antwoord_tekst",
      answer_format == "code" ~ "antwoord_code",
      answer_format == "both" ~ c("antwoord_code", "antwoord_tekst")
    )

    sp_data <- with(
      con_specs$sp_args,
      open_sp(
        con,
        sp_name,
        start_date_parsed,
        end_date_parsed,
        infection_code
      )
    ) |>
      as_tibble()

    log_info("Starting answer/code pivot...")
    cols_data <- colnames(sp_data)
    cols_id <- setdiff(
      cols_data,
      c(
        "vraag_code",
        "antwoord_code",
        "antwoord_tekst",
        "INFECTIECODE",
        "ValidDateStart",
        "ValidDateEnd"
      )
    )

    sp_data_pivot <- sp_data |>
      pivot_wider(
        id_cols = all_of(cols_id),
        names_from = vraag_code,
        values_from = value_vector,
        names_glue = "{vraag_code}_{.value}"
      ) |>
      rename_with(.cols = ends_with(value_vector),
                  .fn = ~ str_replace_all(.,
                                          c(
                                            "antwoord_code" = "code", "antwoord_tekst" = "text"
                                          ))) |>
      select(all_of(cols_id),
             sort(colnames(.)))

    log_info("Finished with {.val {con_specs$name}}")

    return(sp_data_pivot)
  }

#' @title open SP
#'
#' @param con Object: connection object
#' @param sp_name string: Name of the database
#' @param start_date Date: start date for the query
#' @param end_date Date: end date for the query
#' @param infection_code string: infection code
#'
#' @returns data
#' @keywords internal
#'
open_sp <-
  function(con,
           sp_name,
           start_date,
           end_date,
           infection_code) {
    log_info("Attempting to accces store procedure {.val {sp_name}}")

    query_string <-
      str_glue(
        "EXEC {sp_name}
        @StartDate= '{start_date}',
        @EndDate = '{end_date}',
        @InfectieCode = '{infection_code}';"
      )
    sp_data <- con |>
      dbGetQuery(query_string)

    if (sp_data |> nrow() > 0) {
      log_info(
        "Succesfully retrieved {.val {infection_code}} data from ",
        "{.val {ymd(start_date)}} up to {.val {ymd(end_date)}}"
      )
    } else {
      log_warn(
        "No {infection_code} data found from ",
        "{.val {ymd(start_date)}} up to {.val {ymd(end_date)}}"
      )
    }

    sp_data
  }

#' @title Parse date for get sp data
#' @description
#' Helper function to correctly parse date objects
#'
#'
#' @param d Date: Date object that could be either character, Date or POSIXct format
#' @param call Object: the parent environment from return_env, internal - do not use
#'
#' @returns formatted date
#' @keywords internal
#'
get_sp_data_parse_date <- function(d, call = parent.frame()) {
  if (length(d) != 1) {
    cli_abort(
      "'{deparse(substitute(d))}' is expected to be of length 1! ",
      " Actual length: {length(d)}",
      call = call
    )
  }
  if (!(class(d)[[1]] %in% c("character", "Date", "POSIXct"))) {
    cli_abort(
      c(
        "'{deparse(substitute(d))}' is expected to be a character, ",
        "date or datetime.  Actual class: {class(d)}"
      ),
      call = call
    )
  }

  if (is.character(d)) {
    d <- ymd(str_extract(d, "^[0-9]{8}")) # to ensure valid date
    if (is.na(d)) {
      cli_abort(
        c(
          "Casting '{deparse(substitute(d))}' to a valid date failed. ",
          "Expected a string starting with 'YYYYMMDD.' Actual value: {d}
        "
        ),
        call = call
      )

    }
  }
  format(d, format = "%Y%m%d")
}

#' @title Argument check for get sp data
#' @description
#' Helper function that checks connection arguments
#'
#'
#' @param con_specs List: list with connection specifications
#' @param call Object: the parent environment from return_env, internal - do not use
#'
#' @returns checked arguments
#' @keywords internal
#'
get_sp_data_argcheck <- function(con_specs, call = parent.frame()) {
  # Error message when function arguments are missing in [con_specs]
  if (!all(hasName(con_specs, c("name", "con_args", "sp_args")))) {
    cli_abort(
      c(
        "Incorrect input! c('name', con_args', 'sp_args') should be in the names of [con_specs]"
      ),
      call = call
    )
  }

  # Error message when the data name is missing or is not a character
  if (length(con_specs$name) != 1 || class(con_specs$name) != "character") {
    cli_abort(c(
      "con_specs$name should be given in [con_specs] as a character of length 1!"
    ),
    call = call)
  }

  # Error message when connection (con) specifications are not organized as a list
  if (!is.list(con_specs$con_args)) {
    cli_abort(c("con_specs$con_args should be a list in [con_specs]"),
              call = call)
  }

  # Error message when connection (tbl) specifications are not organized as a list
  if (!is.list(con_specs$sp_args)) {
    cli_abort(c("con_specs$sp_args should be a list in [con_specs]"),
              call = call)
  }

  # Error message when connection (con) specifications are missing
  if (!all(hasName(con_specs$con_args, c("server", "database", "uid", "pwd")))) {
    cli_abort(
      c(
        "Incorrect input when importing [con_specs$name]! ",
        "c('server', 'database', 'uid', 'pwd') should be in the ",
        "names of con_specs$con_args in [con_specs]"
      ),
      call = call
    )
  }

  # Error message when connection (con) specifications are missing
  if (!all(hasName(con_specs$sp_args,
                   c("sp_name", "infection_code")))) {
    cli_abort(
      c(
        "Incorrect input when importing [con_specs$name]! ",
        "c('sp_name', 'infection_code') should be in the ",
        "names of con_specs$sp_args in [con_specs]"
      ),
      call = call
    )
  }

  # List all con and tbl specifications given in [con_specs]
  listed_input <-
    c(con_specs$con_args[c("server", "database", "uid", "pwd")],
      con_specs$sp_args[c("sp_name", "infection_code")]) |>
    keep(~ !is.null(.x))

  # Error message when con and tbl specifications are not a character
  if (!all(map_lgl(listed_input, is.character))) {
    cli_abort(
      c(
        "Incorrect input when importing [con_specs]! ",
        str_c(names(listed_input)[!map_lgl(listed_input, is.character)], collapse = "+"),
        " is/are not of class character in [con_specs]!"
      ),
      call = call
    )
  }

  # Error message when con and tbl specifications are missing or are not unique
  if (!all(map_lgl(listed_input, ~ length(.x) == 1))) {
    cli_abort(
      c(
        "Incorrect input when importing [con_specs]! ",
        str_c(names(listed_input)[!map_lgl(listed_input, ~ length(.x) == 1)], collapse = "+"),
        " is/are not of length 1 in [con_specs]!"
      ),
      call = call
    )
  }
}
