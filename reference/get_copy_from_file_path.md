# Get the copy from file path from object_definitions

This functions uses the output_dir of a data_asset to determine where
the object can be copied from.

## Usage

``` r
get_copy_from_file_path(
  data_asset_name,
  p_e,
  call = parent.frame(),
  test_mode = FALSE
)
```

## Arguments

- data_asset_name:

  Character.

- p_e:

  For internal use. The hidden pipeline state environment.

- call:

  For internal use. Used for error tracing.

- test_mode:

  For internal use. Boolean to inject `test_path()` into file paths for
  testing purposes. Default = FALSE

## Value

string with filepath to copy from
