# Setup the R environment for creation of objects

setup_environment() is run at the top of an object creation script and
ensures the dependencies are loaded. If this function is run
interactively() by the user at the top of an object script, then,
additionally, setup_environment() deduces which object is worked on and
detemines the object_name.

## Usage

``` r
setup_environment(
  cur_env,
  prepare_script = "scripts/00_prepare/prepare.R",
  config_checks = TRUE,
  p_e = pipeline_env
)
```

## Arguments

- cur_env:

  Environment. The environment from which setup_environment() is called.
  object_name (only if cur_env == .GlobalEnv) and the list of imported
  objects will be attached to this environment.

- prepare_script:

  Character. Location of the script that prepares R by importing
  packages etc. Default ="scripts/00_prepare/prepare.R"

- config_checks:

  run the config checks for this object. Default is TRUE.

- p_e:

  pipeline environment.

## Value

invisible(NULL)

## Examples

``` r
if (FALSE) { # \dontrun{
setup_environment(environment())
### ### ### DO NOT EDIT ABOVE THIS LINE! ### ### ###
# (place the above at the top of a new object script)
} # }
```
