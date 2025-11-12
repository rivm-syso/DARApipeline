#' Initiate DARApipeline for an EPI pipeline
#'
#' @description
#'
#' Initiates configuration of DARApipeline for use in an EPI pipeline. Does the following steps:
#'
#' 1. Creates a run_timestamp
#' 2. Initiates logging to log file
#' 3. Interprets the configuration in config/
#'
#' DARApipeline will keep track any parameters (such as the `run_timestamp` and the
#' configuration) in a hidden pipeline state environment.
#'
#'
#' @param run_timestamp Character. run_timestamp in the format YYYMMDD_HHMM.
#'  Defaults to the current day + time. Set this parameter to an old
#'  run_timestamp to 'go back in time'.
#'
#' @seealso [grab_object_table()].
#'
#' @examples
#' \dontrun{
#' pipeline_init()
#' }
#'
#' @inheritParams grab_object_table
#' @export
pipeline_init <- function(run_timestamp = NULL, ..., p_e = pipeline_env) {
  check_dots_empty()
  # check run_timestamp format
  check_string(run_timestamp, allow_null = TRUE) # also checks length = 1
  if (!is.null(run_timestamp)) {
    invalid_run_timestamp <- is.na(suppressWarnings(ymd_hm(run_timestamp))) ||
      !str_detect(run_timestamp, "^[0-9]{8}_[0-9]{4}$")
    if (invalid_run_timestamp) {
      cli_abort(c(
        "!" = "{.arg run_timestamp} must be a valid date and a string of the format YYYMMDD_HHMM",
        "i" = "given {.val {run_timestamp}}"
      ))
    }
  }

  log_info("Initiating EPI pipeline...")

  # run initiate steps (NB file_config, pipeline_env are given as parameter to
  # enable testing)
  init_run_timestamp(run_timestamp, p_e = p_e)
  init_target_mount(p_e = p_e)
  if (!getOption("DARApipeline.skiplogging")) {
    init_logging(getOption("DARApipeline.logsdir"), p_e = p_e)
  }
  init_config(getOption("DARApipeline.configdir"), p_e = p_e)

  log_info("Init finished!")

  invisible(NULL)
}

### Helper functions -----------------------------------------------------------
#' @title Initialize target mount
#' @description
#' Helper function used to initialize target mount
#'
#' @param p_e Object: package_environment, internal - do not use
#'
#' @returns NULL
#' @keywords internal
#'
init_target_mount <- function(p_e) {

  target_mount_drive <- system("df -P . | tail -1 | tr -s ' ' | cut -d' ' -f 6 ", intern = TRUE)

  target_mount <- str_extract(target_mount_drive, "(?<=/)[^/]+(?=/)") |>
    # replace current mount for rivm if mount is equal to home
    str_replace_all(pattern = "home", replacement = "rivm")

  assign("target_mount", target_mount, envir = p_e)

  drive_name <- if_else(target_mount == "rivm",
                        true = "r",
                        false = "r-schijf",
                        missing = "r")
  assign("drive_name", drive_name, envir = p_e)

  log_info("{.arg target_mount} is {.val {target_mount}}, using {.arg drive_name} {.val {drive_name}}")

  invisible(NULL)
}

#' @title Initialize run timestamp
#' @description
#' Helper function that initializes a run timestamp
#'
#' @param run_timestamp string: String in timestamp format (YYYYMMDD_HHMM)
#' @param p_e Object: package_environment, internal - do not use
#'
#' @returns NULL
#' @keywords internal
#'
init_run_timestamp <- function(run_timestamp, p_e) {
  # 5 scenarios depending on value of run_timestamp given and previous runs.
  # Note that scenarios 3-5 result in the same but have different messages.

  ## GET
  # here $ is used so NULL is returned if run_timestamp is not defined
  old_run_timestamp <- p_e$run_timestamp

  if (is.null(old_run_timestamp) && is.null(run_timestamp)) {
    # scenario1: no old run_timestamp no manual run_timestamp given: create 1
    run_timestamp <- now() |> format(format = "%Y%m%d_%H%M")
    log_info("{.arg run_timestamp} set to {.val {run_timestamp}}")
  } else if (!is.null(old_run_timestamp) && is.null(run_timestamp)) {
    # scenario2: old run_timestamp found, no manual run_timestamp given: keep old one
    log_info("Old {.arg run_timestamp} found ({.val {old_run_timestamp}}). Not refreshing.")
    return(invisible(NULL))
  } else if (is.null(old_run_timestamp)) {
    # scenario3: no old run_timestamp found, manual run_timestamp given: set to manual
    log_warn("Manually set {.arg run_timestamp} to ({.val {run_timestamp}}).")
  } else if (old_run_timestamp == run_timestamp) {
    # scenario4: old run_timestamp found and manual run_timestamp and are identical: set to manual
    log_warn(str_c(
      "Manually set {.arg run_timestamp} to ({.val {run_timestamp}}). ",
      "Value did not change."
    ))
  } else {
    # scenario4: old run_timestamp found and manual run_timestamp and are not identical: set to manual
    log_warn(str_c(
      "Manually set {.arg run_timestamp} to ({.val {run_timestamp}}). ",
      "Value changed from {.val {old_run_timestamp}}"
    ))
  }

  ## ASSIGN
  # Change run_timestamp for scenarios 1,3,4,5
  assign("run_timestamp", run_timestamp, envir = p_e)
  invisible(NULL)
}


#' @title Initialize logging
#' @description
#' Helper function that intializes logging
#'
#' @param path_logs Path: Path to log file
#' @param p_e Object: package_environment, internal - do not use
#'
#' @returns NULL
#' @keywords internal
#'
init_logging <- function(path_logs, p_e) {
  # setup logging to file: creates a log file, sets the appender to this file and
  # redirects 'normal' messages/errors to these files as well

  ## GET
  run_timestamp <- get("run_timestamp", envir = p_e)

  # Create path for log
  path_log <- sprintf(
    "%s/%s/%s_%s.log",
    path_logs,
    format(ymd_hm(run_timestamp), "%Y%m"),
    # year-month
    run_timestamp,
    getwd() |> basename()
  )

  ## ASSIGN
  assign("path_log", path_log, envir = p_e)

  # Create log directory
  dir_create(dirname(path_log))
  if (file.exists(path_log)) {
    log_warn("Log file {.file {path_log}} exists, appending logs to end of file.")
  }

  # End logging this session to file for all namespaces (typcally global + DARApipeline)
  log_appender(
    appender = appender_tee(p_e$path_log),
    namespace = log_namespaces(),
    index = 1
  )

  # collect warnings and errors in logger, but only if not already collecting
  if (!("warning" %in% names(globalCallingHandlers()))) {
    log_warnings()
  }
  if (!("error" %in% names(globalCallingHandlers()))) {
    log_errors()
  }
  if (!("message" %in% names(globalCallingHandlers()))) {
    log_messages()
  }
  user <- Sys.info()[["effective_user"]]
  log_info("Logs are now writing to {.file {path_log}} with {.arg run_timestamp} =
           {.val {run_timestamp}} and {.arg user} =  {.val {user}}")
  invisible(NULL)
}

# init_config is moved to a separate init_config.R file because of its size and many sub-helper functions
