#' Load data from specified location and date
#'
#' @description Load data from specified location and date.
#' Optionally a time range can be given and a file reading function.
#' When no file reading function is given, it is derived from the file extension.
#' With the fst extension, optional parameters can be given to filter the data.
#'
#' @param loc Character. Location of data (recursive).
#' @param date Date. Date in filename of the data in format "%Y%m%d".
#' @param timerange Integer vector indicating time range
#' @param readFunc Function, with what function should data be read?
#' @param fstcolumns Character vector. Columns to load.
#' @param fstfilter Named list with 1 call.
#' @return Most recent file with specified date in the name at specified location.
#'
#' @examples
#' \dontrun{
#' load_data(loc = "./example", date = as.Date("2000-01-01"))
#' }
#'
#' @export
load_data <- function(loc, date, timerange, readFunc, fstcolumns = NULL, fstfilter = NULL) {
  datestring <- format(date, "%Y%m%d")
  files <- list.files(loc, full.names = TRUE, recursive = TRUE, pattern = datestring)
  # Optional timerange filter
  if (!missing(timerange)) {
    file_time <- str_extract(files, str_glue("(?<={datestring}_)[0-9]{{4}}")) |> as.numeric()
    files <- files[map_lgl(file_time, ~ between(.x, range(timerange)[1], range(timerange)[2]))]
  }
  # Warning if there are multiple valid files
  if (length(files) == 0) {
    cli_abort(c(
      "No files found in {.file {loc}}"
    ))
  } else if (length(files) > 1) {
    warning("Multiple files found, only the file with the most recent modification time is loaded")
    files <- files[[which.max(file.mtime(files))[[1]]]]
  }

  # Find out what import function to use
  if (missing(readFunc)) {
    ext <- str_to_lower(str_extract(files, "[^.]+$"))

    if (ext != "fst" || is.null(fstcolumns)) {
      columnstring <- ""
    }
    if (ext != "fst" && !is.null(fstcolumns)) {
      cli_warn("{ext} != 'fst' so fstcolumns option will be ignored!")
      columnstring <- ""
    } else if (ext == "fst" && !is.null(fstcolumns)) {
      columnstring <- sprintf(" With fstcolumns = [%s]", str_c(fstcolumns, collapse = ", "))
    } else {
      columnstring <- ""
    }

    if (ext != "fst" || is.null(fstfilter)) {
      filterstring <- ""
    }
    if (ext != "fst" && !is.null(fstfilter)) {
      cli_warn("{ext} != 'fst' so fstfilter option will be ignored!")
      filterstring <- ""
    } else if (ext == "fst" && !is.null(fstfilter)) {
      if (length(names(fstfilter)) != 1 || !is.list(fstfilter) || !is.call(fstfilter[[1]])) {
        stop("Something is wrong with fstfilter. It should be a named list with 1 call. E.g.: list(Start_date
= quote(Start_date > ymd(\"2022-02-26\"))")
      }
      filterstring <- sprintf(" The column [%s] will be filtered with: '%s'",
                              names(fstfilter),
                              paste(unname(fstfilter)))
    }

    if (ext == "rds") {
      readFunc <- readRDS
    } else if (ext == "fst") {
      check_installed("fst")
      fst::threads_fst(4)
      readFunc <- function(...) {
        ft <- fst::fst(...)
        if (!is.null(fstfilter)) {
          rows <- ft[, names(fstfilter), drop = FALSE] |>
            mutate(filt = !!(fstfilter[[1]])) |> # Look out, only 1 filter possible
            pull(.data$filt) |>
            which()
        } else {
          rows <- seq_len(nrow(ft)) # simply rows <- TRUE or NULL doesn't work
        }
        ft[rows, fstcolumns, drop = FALSE] |>
          as_tibble()
      }
    } else {
      cli_abort(c(
        "{.arg ext} {ext} is not recognized",
        i = "Supply a custum function in {.arg readFunc} to use a custom {.arg ext}"
      ))
    }
  }
  message(str_glue("'{files}' is loading...{columnstring}{filterstring}"))
  return(readFunc(files))
}
