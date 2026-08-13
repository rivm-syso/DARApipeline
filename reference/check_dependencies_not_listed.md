# Check dependencies used and not mentioned in object_relations

From the initialized pipeline environment,
`check_dependencies_not_listed` to check whether any of the dependencies
specified in the config files are used but not listed in
`object_relations.yaml` config. The location of the R script is
retrieved from the pipeline environment object `p_e`. The usage check is
done by performing a string search within the R script file. This is
necessary because dependency relations may be missing, but the pipeline
can still succeed if the dependency is referenced in an object that was
generated earlier.

## Usage

``` r
check_dependencies_not_listed(
  object_name,
  p_e = pipeline_env,
  test_mode = FALSE
)
```

## Arguments

- object_name:

  Character. The name of the object.

- p_e:

  pipeline environment

## Value

invisible NULL
