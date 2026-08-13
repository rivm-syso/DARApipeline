# Register object

Helper function to register object

## Usage

``` r
conf_register_object(
  object_name,
  conf_paths,
  conf_definitions,
  object_dag,
  p_e = pipeline_env,
  .call = parent.frame()
)
```

## Arguments

- object_name:

  String: name of the object

- conf_paths:

  yaml: loaded yaml containing object paths from configuration file

- conf_definitions:

  yaml: loaded yaml containing object definitions from configuration
  file

- object_dag:

  Dag: Directed Acyclic Graph object

- p_e:

  Object: package_environment, internal - do not use

- .call:

  Object: the parent environment from return_env, internal - do not use

## Value

conf_object
