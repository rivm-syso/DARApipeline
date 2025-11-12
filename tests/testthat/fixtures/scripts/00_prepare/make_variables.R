log_info("Variables are defined")

# define example dates
date_start_covid <- as_date("2020-02-27")
date_last_report <- as_date("2023-02-27")
date_run         <- as_date(ymd_hm(grab_run_timestamp()))

# COVID variants
date_start_delta   <- as_date("2021-07-01")
date_start_omicron <- as_date("2022-01-01")
