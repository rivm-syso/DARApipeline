# Create path for log
path_log <- sprintf(
  "fixtures/scripts/setup_environment_test_objects/%s/%s/%s_%s.log",
  "logs",
  format(Sys.time(), "%Y%m"),
  # year-month
  format(Sys.time(), "%Y%m%d_%H%M"),
  "datasource-cookiecutter"
)

# Create log directory
dir.create(dirname(path_log), showWarnings = FALSE, recursive = TRUE)

# End logging this session to file
log_appender(appender_tee(path_log), index = 1)

# # collect warnings and errors in logger
warning <- function(m) {
  logger::log_warn(m$message)
}

error <- function(m) {
  logger::log_error(m$message)
}

message <- function(m) {
  logger::log_info(m$message)
}

# log_warnings()
# log_errors()
# log_messages()
