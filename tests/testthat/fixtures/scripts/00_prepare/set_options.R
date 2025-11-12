# Set default options
Sys.setlocale("LC_TIME", "en_US.UTF-8")
# week starts on Monday
options(lubridate.week.start = 1)
# options(dir_output_log = "logs/outputs/") # example
log_info("Default options are set")
