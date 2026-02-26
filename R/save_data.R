#' Save data
#'
#' @description
#' Saves R objects as a file with a timestamp in a specified directory
#
#' @param object R object to save.
#' @param file_directory Character. the location used for saving data.
#' @param file_name Character. (optional) name of the file to save, default = object.
#' @param time Numeric. Valid time range to save file(s) c(START HHMM, END HHMM),
#' example c(0000, 2359). Default = c(0000, 2359)
#' @param days Numeric. Valid days to save, 1 is monday and 7 is sunday, example for mo-fr: 1:5. Default = 1:7
#' @param ext Character. File extention. Default = "rds"
#' @param save_function Function. Optional function to use for saving. First 2 arguments need to be:
#' object, file location. Default = saveRDS.
#' @param run_timestamp Character. YYYYMMDD_HHMM timestamp of the run.
#' @param save_function_options Character. Optional parameters for the save_function.
#' @param timestamp_file_name Boolean. TRUE/FALSE do you want a timestamp in the file_name. Default = TRUE.
#'
#' @examples
#' \dontrun{
#' save_data(
#'   object = cars,
#'   file_directory = "output/objects",
#'   file_name = "cars",
#'   run_timestamp = "19000101_0000"
#' )
#' }
#'
#' @export
save_data <- function(object,
                      file_directory,
                      file_name,
                      time = c(0000, 2359),
                      days = 1:7,
                      ext = "rds",
                      save_function = saveRDS,
                      save_function_options = list(),
                      run_timestamp = get("run_timestamp", envir = parent.frame()),
                      timestamp_file_name = TRUE) {
  # warning if extention and save_function differ
  if (str_to_lower(ext) != "rds" && (deparse(substitute(save_function)) %in% c("saveRDS", "write_rds"))) {
    log_warn(
      str_glue(
        "Wrong save_function? [ext] is '{ext}' but [save_function] is {deparse(substitute(save_function))}"
      )
    )
  }

  object_name <- deparse(substitute(object))

  file_name <-
    ifelse(!missing(file_name), file_name, object_name) # ! express geen if_else!

  # Warn and correct [time] variable
  if (length(time) > 2) {
    log_warn(
      "{.arg time} has an invalid time range, expected structure is {.code c(900,1300)}.",
      "{.code range(time)} is applied!"
    )
    time <- range(time)
  }

  if (timestamp_file_name) {
    # Check if day is correct
    if (!(wday(ymd_hm(run_timestamp), week_start = 1) %in% days)) {
      log_warn(
        "Skipping save step: {.arg run_timestamp} {.val {run_timestamp}}, {.arg days} is not in: {.val {days}}"
      )
      return(invisible(NULL))
    }

    # Skip saving if timestamp is not within valid time range
    if (!(as.numeric(run_timestamp |> str_extract(pattern = "[0-9]{4}$")) |> between(time[[1]], time[[2]]))) {
      log_warn(
        "Skipping save step:{.arg run_timestamp} {.val {run_timestamp}}
        is not within {.val {time[1]}}-{.val {time[2]}}"
      )
      return(invisible(NULL))
    }
  }

  #  create file_directory if it doesnt exist
  dir.create(
    file_directory,
    showWarnings = FALSE,
    recursive = TRUE
  )

  if (timestamp_file_name) {
    file_name_full <- file.path(
      file_directory,
      sprintf(
        "%s_%s.%s",
        file_name,
        run_timestamp,
        ext
      )
    )
  } else {
    file_name_full <- file.path(
      file_directory,
      sprintf("%s.%s", file_name, ext)
    )
  }
  # give warning if file_name_full and we will overwrite
  if (file.exists(file_name_full)) {
    log_warn("{.file {file_name_full}} exists, overwriting...")
  }

  log_info("Saving: {.arg {object_name}} --> {.file {file_name_full}}")

  # give current run_timestamp as attribute to object
  if (exists("run_timestamp")) {
    attr(object, "run_timestamp") <- run_timestamp
  }

  do.call(save_function, c(list(object, file_name_full), save_function_options))
  return(invisible(NULL))
}
