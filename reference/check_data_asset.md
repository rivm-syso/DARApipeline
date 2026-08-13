# Check data asset

Helper function to check data asset Used in:

- copy_from_dependency_list

- grab_target_list

- pipeline_import_for

- mark_for_refresh

- pipeline_run

## Usage

``` r
check_data_asset(data_assets, types, p_e, call = parent.frame())
```

## Arguments

- data_assets:

  List: list of data assets to be checked

- types:

  List: list of types to be checked

- p_e:

  Object: package_environment, internal - do not use

- call:

  Object: the parent environment from return_env, internal - do not use

## Value

None
