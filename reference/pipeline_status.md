# Print a status overview of the EPI pipeline

This function prints the current status of the pipeline:

1.  Whether the pipeline has been initiated.

2.  The initiated run_timestamp.

3.  How many objects have been created so far.

4.  The location of the log file.

## Usage

``` r
pipeline_status(..., p_e = pipeline_env)
```

## Arguments

- ...:

  For internal use. Leave empty.

- p_e:

  For internal use. The hidden pipeline state environment.
