# Grab object_params for all data_assets for the current EPI pipeline.

This function grabs the data_asset configuration (i.e. the
object_params) from the hidden pipeline state environment. These hold
information such as the paramaterised paths for retrieving / storing the
data_asset.

## Usage

``` r
grab_object_table(..., p_e = pipeline_env, call = parent.frame())
```

## Arguments

- ...:

  For internal use. Leave empty.

- p_e:

  For internal use. The hidden pipeline state environment.

- call:

  For internal use. Used for error tracing.

## Value

A tibble with object_params.
