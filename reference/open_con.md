# open connection

Helper function to open connection used in:

## Usage

``` r
open_con(con_specs)
```

## Arguments

- con_specs:

  List. Connection arguments for the database. It should be a named list
  with the names "name"/"con_args"/"tbl_args". con_args should be a
  named character with entries "server"/"database"/"uid"/"pwd" and
  tbl_args should be a named character with the entries
  "dbcatalog"(optional)/dbschema"/"dbtable".

## Value

con
