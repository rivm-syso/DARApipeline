# pipeline import for

Imports the dependencies (objects / data / other) given a list of asset
names. The imported objects will be loaded into the global environment.

## Usage

``` r
pipeline_import_for(
  data_assets,
  ...,
  p_e = pipeline_env,
  call = parent.frame()
)
```

## Arguments

- data_assets:

  Character. Name of the data_assets (objects/other) that you want to
  import objects for. Multiple asset names should passed in an array of
  the form 'c()'.

- ...:

  Additional arguments. Should be empty.

- p_e:

  For internal use. The hidden pipeline state environment.

- call:

  For internal use. Used for error tracing.
