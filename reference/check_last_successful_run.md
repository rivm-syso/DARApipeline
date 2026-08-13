# Check last Successful run

Function that determines the last successful production run of the
pipeline, based on log files.

## Usage

``` r
check_last_successful_run(
  log_dir = "",
  include_cronjob = FALSE,
  cronjob_only = FALSE,
  search_window = 1,
  search_line = "",
  p_e = pipeline_env,
  call = parent.frame()
)
```

## Arguments

- log_dir:

  string: Full path to log directory of desired project.

- include_cronjob:

  boolean: Include the logs from the cronjobs?

- cronjob_only:

  boolean: Only check cronjob logs? Default = FALSE, overwrites
  include_cronjob.

- search_window:

  integer: number of last lines in the logfile to check for. Default = 1

- search_line:

  string: Custom message to search for in log file

- p_e:

  Object: package_environment, internal - do not use

- call:

  Object: the parent environment from return_env, internal - do not use

## Value

timestamp of latest successful production run

## Examples
