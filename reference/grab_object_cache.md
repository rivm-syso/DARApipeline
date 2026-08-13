# grab the cache path from the object_table in the pipeline_env

Function grabs the cache path from the object_table in the pipeline_env.
Especially useful when the cache file differs from the standard format
cache/{RUN_TIMESTAMP}

## Usage

``` r
grab_object_cache(object_name, ..., p_e = pipeline_env, call = parent.frame())
```

## Arguments

- p_e:

  Object: package_environment, internal - do not use

- call:

  Object: the parent environment from return_env, internal - do not use
