#' @title Check most recent data file within x days
#' @description
#' Determines the most recent data file based on a timestamp in the data filename,
#' and filtering on a maximum file age in days. The comparison is made relative
#' to the current date via parameter use_run_timestamp the comparison can be made relative to the pipeline's
#' run_timestamp.
#'
#' @param dir Character. Full path to the directory containing data files.
#' @param pattern Character. Pattern to match data files. Default = ".".
#' @param days_valid_data Numeric. The number of days back from today to consider data as valid.
#' If days_valid_data = 0, only data from today is considered. Default is 1.
#' @param ext Character. File extension. Default = ".rds".
#' @param ignore_tmp Logical. Ignore temporary/lock files. Default = FALSE.
#' @param verbose_run_timestamp Logical. Report found file and timestamp. Default = TRUE.
#' @param use_run_timestamp Logical. Use run timestamp of the pipeline for comparison. Default = FALSE.
#' @param error_on_invalid Logical. If TRUE, the function stops with an error on invalid input.
#' If FALSE, the function returns TRUE/FALSE to indicate validity. Default is TRUE.
#' @param p_e Object: package_environment, internal - do not use
#' @param call Object: the parent environment from return_env, internal - do not use
#' @return NULL (invisibly), or throws error if no valid file is found.
#'
#' @examples
#' \dontrun{
#' check_last_successful_run(
#'   dir = "Path_to_data_dir",
#'   pattern = "data_osiris",
#'   days_valid_data = 7
#' )
#' }
#' @export

check_most_recent_data <- function(dir,
                                   pattern = ".",
                                   days_valid_data = 1,
                                   ext = ".rds",
                                   ignore_tmp = FALSE,
                                   verbose_run_timestamp = TRUE,
                                   use_run_timestamp = FALSE,
                                   error_on_invalid = TRUE,
                                   p_e = pipeline_env,
                                   call = parent.frame()) {
  most_recent_file_str <- most_recent_file(
    dir = dir,
    pattern = pattern,
    ext = ext,
    ignore_tmp = ignore_tmp,
    call = parent.frame()
  )
  # pattern is run timestamp with the given extention
  pattern_timestamp <- paste0("(\\d{8}_\\d{4})\\", ext, "$")
  datetime_str <- sub(paste0(".*", pattern_timestamp),
                      "\\1",
                      basename(most_recent_file_str))
  datetime <- strptime(datetime_str, format = "%Y%m%d_%H%M")

  if (verbose_run_timestamp) {
    log_info(
      "Latest data file found: {.val {most_recent_file_str}}, with date time: {.val {paste0(datetime)}}"
    )
  }

  if (use_run_timestamp) {
    date_from <- p_e$run_timestamp |> strptime(format = "%Y%m%d_%H%M")
  } else {
    date_from <- now()
  }

  if ((date_from - days(days_valid_data)) > datetime) {
    if (!error_on_invalid) {
      return(FALSE)
    }
    cli_abort(
      "Data is too old! Data should be from or newer than {.val {date_from - days(days_valid_data)}},
              but data is from {.val {paste0(datetime)}}"
    )
  }
  if (!error_on_invalid) {
    return(TRUE)
  }
  return(invisible(NULL))
}
