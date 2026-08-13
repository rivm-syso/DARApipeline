# Check usage dependencies

From the initialized pipeline environment, `check_usage_dependencies`
checks whether the dependencies specified in the configuration files for
this object are being used in the R object script. The location of the R
script is retrieved from the pipeline environment object `p_e`. The
usage check is done by performing a string search within the R script
file with filename `object_name`.

## Usage

``` r
check_usage_dependencies(object_name, p_e = pipeline_env, test_mode = FALSE)
```

## Arguments

- object_name:

  Character. The name of the object.

- p_e:

  pipeline environment

## Value

invisible NULL
