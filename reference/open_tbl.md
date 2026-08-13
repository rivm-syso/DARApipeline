# open table

Helper function to access data table (tbl)

## Usage

``` r
open_tbl(con_specs, con)
```

## Arguments

- con_specs:

  List. Connection arguments for the database. It should be a named list
  with the names "name"/"con_args"/"tbl_args". con_args should be a
  named character with entries "server"/"database"/"uid"/"pwd" and
  tbl_args should be a named character with the entries
  "dbcatalog"(optional)/dbschema"/"dbtable".

- con:

  Connection, which is established with `open_con`

## Value

tbl_db
