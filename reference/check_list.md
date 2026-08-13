# Check list

Helper function to check if input is in list. used in `open_tbl_con`

## Usage

``` r
check_list(
  x,
  ...,
  allow_null = FALSE,
  arg = caller_arg(x),
  call = caller_env()
)
```

## Arguments

- x:

  list object: the list to be checked

- ...:

  Additional arguments. Should be empty.

- allow_null:

  Boolean: option to set allowance for null.

- arg:

  Object: Argument name that gets fetched from argument

- call:

  Object: the parent environment from return_env, internal - do not use

## Value

None
