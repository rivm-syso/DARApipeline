# read non empty conf

Helper function to read in a config if not empty

## Usage

``` r
read_non_empty_conf(f, cli_f, .call = parent.frame())
```

## Arguments

- f:

  file location of config file

- cli_f:

  cli function to either warn or abort

- .call:

  Object: the parent environment from return_env, internal - do not use
