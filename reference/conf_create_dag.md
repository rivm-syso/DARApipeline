# Create Dag

Helper function to create DAGs

## Usage

``` r
conf_create_dag(conf_relations, all_objects, call = parent.frame())
```

## Arguments

- conf_relations:

  yaml: loaded yaml containing object relations from configuration file

- all_objects:

  All objects, returned from `conf_get_all_objects`

- call:

  Object: the parent environment from return_env, internal - do not use

## Value

gr: Graph object
