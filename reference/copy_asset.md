# Copy single asset

This functions copies an object/data to a given location under
`copy_to_file_path` in object_definitions.yaml.

## Usage

``` r
copy_asset(
  data_asset_name,
  p_e = pipeline_env,
  call = parent.frame(),
  test_mode = FALSE
)
```

## Arguments

- data_asset_name:

  Character. Name of object, as defined in object_definitions.yaml.

- p_e:

  For internal use. The hidden pipeline state environment.

- call:

  For internal use. Used for error tracing.

- test_mode:

  For internal use. Boolean to inject `test_path()` into file paths for
  testing purposes. Default = FALSE
