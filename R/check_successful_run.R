#' @title Check last Successful run
#' @description
#' Function that determines the last successful production run of the pipeline, based on log files.
#'
#' @param log_dir string: Full path to log directory of desired project.
#' @param include_cronjob boolean: Include the logs from the cronjobs?
#' @param cronjob_only boolean: Only check cronjob logs? Default = FALSE, overwrites include_cronjob.
#' @param search_window integer: number of last lines in the logfile to check for. Default = 1
#' @param search_line string: Custom message to search for in log file
#' @param p_e Object: package_environment, internal - do not use
#' @param call Object: the parent environment from return_env, internal - do not use
#'
#' @returns timestamp of latest successful production run
#'
#' @examples
#' \dontrun{
#' Please note that the user has to provide the correct log directory path.
#' Find latest run, including cronjobs:
#' check_last_successful_run(log_dir = "Path_to_log_dir",
#'                           include_cronjob = TRUE)
#'
#' Find latest run, excluding cronjobs:
#' check_last_successful_run(log_dir = "Path_to_log_dir",
#'                           include_cronjob = FALSE)
#'
#' Look for custom completion messages:
#' check_last_successful_run(log_dir = "Path_to_log_dir"
#'                           include_cronjob = TRUE,
#'                           search_line = "Infectieradar saved clean joined, weekly and intake data.")
#'
#' Look for messages that might not be on the last line of the log file:
#' check_last_successful_run(log_dir = "Path_to_log_dir",
#'                           include_cronjob = FALSE,
#'                           search_line = "Done!",
#'                           search_window = 2)
#' }
#'
#' @export
check_last_successful_run <- function(log_dir = "",
                                      include_cronjob = FALSE,
                                      cronjob_only = FALSE,
                                      search_window = 1,
                                      search_line = "",
                                      p_e = pipeline_env,
                                      call = parent.frame()) {

  # Parameter checks
  check_string(log_dir)
  check_bool(include_cronjob)
  check_bool(cronjob_only)
  check_number_whole(search_window, min = 1) # Max gets tested and altered in read_log function
  check_string(search_line)

  if (log_dir == "") {
    log_info("No {.var log_dir} has been supplied. Attempting to read production path from config file...")
    log_dir <- log_from_config(dir = getwd())
  }

  if (!dir.exists(log_dir)) {
    cli_abort(
      c(
        "!" = "Can't find log directory.",
        "i1" = "Please make sure the filepath is correct: {.val {log_dir}}",
        "i2" = "Perhaps a '/' is missing at the start of the path?"
      ),
      call = call
    )
  }

  log_files <- get_file_list(log_dir, include_cronjob, cronjob_only)
  log_files_rev <- order_file_list(log_files)
  found_success <- FALSE

  for (i in seq_along(log_files_rev$filepath)){ # Loop through log files (newest to latest)
    if (!found_success) {
      found_success <- read_log(log_files_rev[i, ]$filepath, search_window, search_line)

      if (found_success) { # This is intentionally separated, due to looping.
        pretty_name <- log_files_rev[i, ]$filepath |>
          str_split_i("logs/", -1)
        pretty_mod_time <- log_files_rev[i, ]$mod_time |>
          str_split_i("\\.", 1)

        log_info("Lastest successful run found in logfile: {.val {pretty_name}}, with modification time: {.val {pretty_mod_time}}") # nolint: line_length_linter
        return(pretty_name)
      }
    }
  }

  if (!found_success) {
    log_info("No successful run has been found for: {.val {log_dir}}...")
    log_info("Try more lenient parameters with ({.var search_window} & {.var search_line})")
    return(NA_character_)
  }
}


#' Helper function to get log directory from config file
#'
#' @param dir string: current working directory.
#'
#' @returns string: log directory path.
#'
#' @keywords internal
log_from_config <- function(dir) {
  path_yaml <- read_yaml(file.path(dir, "config", "base", "file_paths.yaml"))

  if (is.null(path_yaml$dir_mnt)) {
    cli_abort(c(
      "!" = "The {.val dir_mnt} or is not set in the config file.",
      "i" = "Please make sure to set these parameters in the config file, or provide log_dir path!"
    ),
    call = call
    )
  }

  if (!startsWith(path_yaml$dir_mnt, "/")) { # Ensure the path starts with a slash
    path_yaml$dir_mnt <- str_c("/", path_yaml$dir_mnt)
  }

  log_dir <- file.path(path_yaml$dir_mnt, path_yaml$dir_proj, "logs")

  log_info("Fetched log directory: {.val {log_dir}} from config file. If this is incorrect, please provide a {.var log_dir} parameter.") # nolint: line_length_linter
  return(log_dir)
}

#' helper get_file_list
#'
#' @param log_dir string: path to the log directory
#' @param incl_cron boolean: Include cronjob logs
#' @param cron_only boolean: Only check cronjob logs? Default = FALSE, overwrites include_cron.
#'
#' @returns list of log filepaths
#' @keywords internal
get_file_list <- function(log_dir, incl_cron, cron_only) {
  if (cron_only) {
    log_info("{.var Cronjob_only} has been selected, including only cronjob runs...")
    log_files <- list.files(path = log_dir, pattern = ".log$", recursive = TRUE, full.names = TRUE) |>
      str_subset("cron_jobs", negate = FALSE)

  } else if (!cron_only) {
    if (incl_cron) {
      log_info("{.var include_cronjob} has been set to {.val {incl_cron}}, including cronjob runs...")
      log_files <- list.files(path = log_dir, pattern = ".log$", recursive = TRUE, full.names = TRUE) |>
        str_subset("cron_logs", negate = TRUE)
    } else {
      log_info("{.var include_cronjob} has been set to {.val {incl_cron}}, excluding cronjob runs...")
      log_files <- list.files(path = log_dir, pattern = ".log$", recursive = TRUE, full.names = TRUE) |>
        str_subset("cron_logs", negate = TRUE) |>
        str_subset("cron_jobs", negate = TRUE)
    }
  }

  if (length(log_files) == 0) {
    cli_abort(c(
      "!" = "No log files found in {.val {log_dir}}",
      "i" = "Please make sure the filepath is correct."
    ),
    call = call)
  }
  return(log_files)
}

#' Helper order file list
#'
#' @param file_list list: list of file paths to order by modification time
#'
#' @returns df: containing file paths and their modification times, ordered by most recent
#' @keywords internal
order_file_list <- function(file_list) {
  file_details <- file.info(file_list)$mtime
  sorted_indices <- order(file_details, decreasing = TRUE)
  sorted_paths <- file_list[sorted_indices]

  results_df <- data.frame(
    filepath = sorted_paths,
    mod_time = file_details[sorted_indices]
  )
  return(results_df)
}


#' Read log files
#'
#' @param path string: path to the log files
#' @param window integer: specifies the size of the search window in the log files.
#' @param search_line string: Custom message to search for in log file
#'
#' @returns success_file string of latest filename that successfully ran.
#'
#' @keywords internal
read_log <- function(path, window, search_line) {
  if (search_line != "") {  # If the user specified custom search criteria, use that instead.
    completion_lines <- search_line
  } else {  # Else use the standard search criteria.
    completion_lines <- c("=== Save step done! ===",
                          "=== Reporting step done! ===")
  }
  conn <- file(path, open = "r")
  read_lines <- readLines(conn)
  success_file <- ""
  found_completion <- FALSE

  if (window > length(read_lines)) {
    window <- length(read_lines)  # Adjust window size when larger than the number of lines
    cli_warn(c(
      "!" = "The {.var window} parameter is larger than the number of lines in the log file.",
      "i" = "Adjusting {.var window} to the number of lines in the file: {.val {window}}."
    ))
  }

  if (any(str_detect(rev(read_lines)[window], completion_lines))) {
    found_completion <- TRUE
  }

  close(conn)
  return(found_completion)
}
