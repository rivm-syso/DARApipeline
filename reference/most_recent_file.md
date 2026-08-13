# Return path to most recent file in a directory with given pattern and extension

Return path to most recent file in a directory with given pattern and
extension.

## Usage

``` r
most_recent_file(
  dir,
  pattern = ".",
  ext = "",
  show_found_files = FALSE,
  ignore_tmp = FALSE,
  call = parent.frame()
)
```

## Arguments

- dir:

  Character. Path to directory.

- pattern:

  Character.

- ext:

  Character. Extension of the file.

- show_found_files:

  Logical.

- ignore_tmp:

  Logical. If TRUE, temporary owner files (~\$) are ignored.

- call:

  Context of the parent interpreted function: environments ('frames' in
  S terminology) associated with functions further up the calling stack.

## Examples

``` r
if (FALSE) { # \dontrun{
most_recent_data(dir = "./example")
} # }
```
