# Idle

Waits for a file to be available in a given directory.

## Usage

``` r
idle(
  dir,
  file_pattern,
  max_mins = 15,
  sleep_mins = 0.2,
  file_modification_buffer_mins = 1
)
```

## Arguments

- dir:

  Character. Directory path.

- file_pattern:

  Character. Pattern of file that will be waited on.

- max_mins:

  Integer. Maximum number of minutes to be idle.

- sleep_mins:

  Double. Refresh time to check for file.

- file_modification_buffer_mins:

  Integer. Time since last update time of file.

## Examples
