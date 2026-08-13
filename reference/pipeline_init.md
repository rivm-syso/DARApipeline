# Initiate DARApipeline for an EPI pipeline

Initiates configuration of DARApipeline for use in an EPI pipeline. Does
the following steps:

1.  Creates a run_timestamp

2.  Initiates logging to log file

3.  Interprets the configuration in config/

DARApipeline will keep track any parameters (such as the `run_timestamp`
and the configuration) in a hidden pipeline state environment.

## Usage

``` r
pipeline_init(run_timestamp = NULL, ..., p_e = pipeline_env)
```

## Arguments

- run_timestamp:

  Character. run_timestamp in the format YYYMMDD_HHMM. Defaults to the
  current day + time. Set this parameter to an old run_timestamp to 'go
  back in time'.

- ...:

  For internal use. Leave empty.

- p_e:

  For internal use. The hidden pipeline state environment.

## See also

[`grab_object_table()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/grab_object_table.md).

## Examples

``` r
if (FALSE) { # \dontrun{
pipeline_init()
} # }
```
