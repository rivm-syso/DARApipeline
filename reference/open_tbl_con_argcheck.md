# Open table connection argument check

Helper function to check missing/wrong values for con or tbl

## Usage

``` r
open_tbl_con_argcheck(con_specs, .call = parent.frame())
```

## Arguments

- con_specs:

  List. Connection arguments for the database. It should be a named list
  with the names "name"/"con_args"/"tbl_args". con_args should be a
  named character with entries "server"/"database"/"uid"/"pwd" and
  tbl_args should be a named character with the entries
  "dbcatalog"(optional)/dbschema"/"dbtable".

- .call:

  Object: the parent environment from return_env, internal - do not use

## Value

None
