# helper get_file_list

helper get_file_list

## Usage

``` r
get_file_list(log_dir, incl_cron, cron_only)
```

## Arguments

- log_dir:

  string: path to the log directory

- incl_cron:

  boolean: Include cronjob logs

- cron_only:

  boolean: Only check cronjob logs? Default = FALSE, overwrites
  include_cron.

## Value

list of log filepaths
