# General helper functions (not exported) that expand upon import-standalone-obj-type.R
# and import-standalone-types-check.R

# check if input is list
#' @title Check list
#' @description
#' Helper function to check if input is in list.
#' used in `open_tbl_con`
#'
#' @param x list object: the list to be checked
#' @param ... Additional arguments. Should be empty.
#' @param allow_null Boolean: option to set allowance for null.
#' @param arg Object: Argument name that gets fetched from argument
#' @param call Object: the parent environment from return_env, internal - do not use
#'
#' @returns None
#' @keywords internal
#'
check_list <- function(x,
                       ...,
                       allow_null = FALSE,
                       arg = caller_arg(x),
                       call = caller_env()) {
  if (!missing(x)) {
    if (is.list(x)) {
      return(invisible(NULL))
    }
    if (allow_null && is_null(x)) {
      return(invisible(NULL))
    }
  }

  stop_input_type(
    x,
    "a list",
    ...,
    allow_null = allow_null,
    arg = arg,
    call = call
  )
}


#' @title remove comments
#' @description
#' Helper function, using R's built-in parser to remove comments from code (both full- & inline)
#' Used instead of regex due to # usage in strings
#' e.g. my_string <- "using # inside string"
#'
#' @param code String: code that needs to be stripped from comments
#'
#' @returns String: input without comments
#' @keywords internal
#'
remove_comments <- function(code) {
  expr <- parse(text = code, keep.source = FALSE)
  return(paste(deparse(expr), collapse = "\n"))
}


#' @title string glue explicit error
#' @description
#' Helper function, used for wrapping explicit errors
#' used in: conf_register_object
#'
#' @param ... Additional arguments. Should be empty.
#' @param sep String: Seperator
#' @param .envir Object: the parent environment from return_env, internal - do not use
#'
#' @returns Error
#' @keywords internal
#'
str_glue_expliciterror <- function(..., sep = "", .envir = parent.frame()) {
  tryCatch(
    {
      str_glue(..., sep = sep, .envir = .envir)
    },
    error = function(msg) {
      stop(
        "Error in str_glue(), did you use invalid str_glue expressions (between the brackets {})? input='",
        paste0(as.list(...), collapse = "|"), "'"
      )
    }
  )
}
