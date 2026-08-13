# remove comments

Helper function, using R's built-in parser to remove comments from code
(both full- & inline) Used instead of regex due to \# usage in strings
e.g. my_string \<- "using \# inside string"

## Usage

``` r
remove_comments(code)
```

## Arguments

- code:

  String: code that needs to be stripped from comments

## Value

String: input without comments
