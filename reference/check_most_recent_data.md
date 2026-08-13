# Check most recent data file within x days

Determines the most recent data file based on a timestamp in the data
filename, and filtering on a maximum file age in days. The comparison is
made relative to the current date via parameter use_run_timestamp the
comparison can be made relative to the pipeline's run_timestamp.

## Usage

``` r
check_most_recent_data(
  dir,
  pattern = ".",
  days_valid_data = 1,
  ext = ".rds",
  ignore_tmp = FALSE,
  verbose_run_timestamp = TRUE,
  use_run_timestamp = FALSE,
  error_on_invalid = TRUE,
  p_e = pipeline_env,
  call = parent.frame()
)
```

## Arguments

- dir:

  Character. Full path to the directory containing data files.

- pattern:

  Character. Pattern to match data files. Default = ".".

- days_valid_data:

  Numeric. The number of days back from today to consider data as valid.
  If days_valid_data = 0, only data from today is considered. Default is
  1 (data from yesterday).

- ext:

  Character. File extension. Default = ".rds".

- ignore_tmp:

  Logical. Ignore temporary/lock files. Default = FALSE.

- verbose_run_timestamp:

  Logical. Report found file and timestamp. Default = TRUE.

- use_run_timestamp:

  Logical. Use run timestamp of the pipeline for comparison of dates.
  Default = FALSE.

- error_on_invalid:

  Logical. If TRUE, the function stops with an error on invalid input.
  If FALSE, the function returns TRUE/FALSE to indicate validity.
  Default is TRUE.

- p_e:

  Object: package_environment, internal - do not use

- call:

  Object: the parent environment from return_env, internal - do not use

## Value

NULL (invisibly), or throws error if no valid file is found.

## Examples

``` r
if (FALSE) { # \dontrun{
check_last_successful_run(
  dir = "Path_to_data_dir",
  pattern = "data_osiris",
  days_valid_data = 7
)
} # }
```
