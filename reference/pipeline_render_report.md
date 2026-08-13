# DARA function that renders markdown files

Runs rmarkdown::render() with extra functionality. Default markdown
filepath is inside the EPI /scripts/02_report folder Default output
filepath is `dir_html`, which is stated in the config file:
grab_object_table() %\>% filter(tag == "html") %\>% pull(dir_html)

Custom paths overide the default paths

## Usage

``` r
pipeline_render_report(
  markdown_file,
  output_file,
  add_timestamp = TRUE,
  custom_markdown_path = "",
  custom_output_path = "",
  quiet = TRUE,
  ...
)
```

## Arguments

- markdown_file:

  name of .Rmd file inside EPI 02_report folder to be rendered

- output_file:

  name of he .html output file. save location is dir_html

- add_timestamp:

  boolean to add timestamp to output file. default = TRUE

- custom_markdown_path:

  advanced use only. If not empty, this path overwrites the default
  markdown filepath

- custom_output_path:

  advanced use only. If not empty, this path overwrites the default save
  location for reports

- quiet:

  boolean used by rmarkdown::render to determine verbose usage.

- ...:

  For internal use. Leave empty.

## Value

None, renders markdown file

## Examples
