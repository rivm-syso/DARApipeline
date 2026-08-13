# Initialize config

Initialize config

## Usage

``` r
init_config(dir_config, p_e, .call = parent.frame())
```

## Arguments

- dir_config:

  Path: to directory which holds the configuration files.

- p_e:

  Object: package_environment, internal - do not use

- .call:

  Object: the parent environment from return_env, internal - do not use

## Helper function kicked of in pipeline_init

This function was separated from the init.R file because of its size and
many sub-helper functions
