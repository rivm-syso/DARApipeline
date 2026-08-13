# Load data from specified location and date

Load data from specified location and date. Optionally a time range can
be given and a file reading function. When no file reading function is
given, it is derived from the file extension. With the fst extension,
optional parameters can be given to filter the data.

## Usage

``` r
load_data(loc, date, timerange, readFunc, fstcolumns = NULL, fstfilter = NULL)
```

## Arguments

- loc:

  Character. Location of data (recursive).

- date:

  Date. Date in filename of the data in format "%Y%m%d".

- timerange:

  Integer vector indicating time range

- readFunc:

  Function, with what function should data be read?

- fstcolumns:

  Character vector. Columns to load.

- fstfilter:

  Named list with 1 call.

## Value

Most recent file with specified date in the name at specified location.

## Examples

``` r
if (FALSE) { # \dontrun{
load_data(loc = "./example", date = as.Date("2000-01-01"))
} # }
```
