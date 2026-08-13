# Save an object as output

save_output saves an object as output with the DARA naming convention.
Some standard formats can be used, or, alternatively, a custom function
that is found in the global environment. All files get timestamped. Note
that only 1 file for of each extension is saved, with the custom formats
having priority.

## Usage

``` r
save_output(
  object,
  object_name,
  output_dir,
  run_timestamp = run_timestamp,
  output_formats,
  output_formats_custom = list(),
  output_arguments = list()
)
```

## Arguments

- object:

  R object. The object that needs to be saved.

- object_name:

  Character. Name of the object Will be used in the output name.

- output_dir:

  character. Directory of the output file. Will be created if it doesn't
  exist yet.

- run_timestamp:

  character. The run_timestamp of the run. will be added to the
  filename.

- output_formats:

  character. Can be 'csv', 'png', 'svg' or 'xlsx'. Common saving
  formats.

- output_formats_custom:

  List. List in the form list(extension = name_of_function) e.g.
  list(tsv = 'write_tsv'). The function has to be loaded into the
  session an findable with [get](https://rdrr.io/r/base/get.html).

- output_arguments:

  List. Extra arguments for output_formats(\_custom) functions.

## Examples

``` r
if (FALSE) { # \dontrun{
dir_temp <- tempdir()
save_output(
  object = tab_example,
  object_name = "tab_example",
  output_dir = "output/2023-W01/osiris/tab_example/",
  run_timestamp = "20230109_1201",
  output_formats = "csv"
)
} # }
```
