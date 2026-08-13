# Retrieves data from a store procedure database within a start and end modification date

get_sp_data() imports from the sp database with an infection_code,
start\_ and end_date.

## Usage

``` r
get_sp_data(
  con_specs,
  start_date = "19000101",
  end_date = grab_run_timestamp(),
  answer_format = c("text", "code", "both")
)
```

## Arguments

- con_specs:

  List. Connection arguments for the database. It should be a named list
  with the names "con_args"/"sp_args". con_args should be a named
  character with entries "server"/"database"/"uid"/"pwd" and sp_args
  should be a named character with the entries
  "sp_name"/"infection_code".

- start_date:

  Date. Records retrieved from the the database will not preceed this
  date. May also be a datetime or character string in the form YYYYMMDD
  or YYYYMMDD_hhmm. Default = "19000101".

- end_date:

  Date. Records retrieved from the the database will not exceed this
  date. May also be a datetime or character string starting with
  YYYYMMDD. Default = run_timestamp.

- answer_format:

  Character. Provide questionare answer formats with "text", "code" or
  "both".

## Value

A tibble

## Examples
