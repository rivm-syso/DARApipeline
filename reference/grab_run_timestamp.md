# Grab the run_timestamp for the current EPI pipeline.

Grabs and returns the used run_timestamp.

## Usage

``` r
grab_run_timestamp(..., p_e = pipeline_env, call = parent.frame())
```

## Arguments

- ...:

  For internal use. Leave empty.

- p_e:

  For internal use. The hidden pipeline state environment.

- call:

  For internal use. Used for error tracing.

## Value

A string in the form YYYMMDD_HHMM
