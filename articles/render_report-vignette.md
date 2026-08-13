# Advanced use of pipeline_render_report

First, we need to load the required packages.

``` r

library(DARApipeline)
```

### Introduction

The `pipeline_render_report` function has been developed to tackle the
known issue that syntax errors in Rmarkdown reports don’t show up when
they are rendered. Instead, the users gets a vague error stating that
the log file couldn’t be found. **This function addresses that issue.**

In this article we will go over the new features of the function and
also show how to easily change your old render report scripts to using
the new method!

The parameters, and basic examples can be found in the documentation of
the function. This can be found in the references tab, or in R using:

``` r

?pipeline_render_report
```

### Basic example

To make the usage of this function as simple as possible and keeping in
mind the EPI pipeline structure, the user only has to state the
`filename` of their Rmarkdown file, and the name of their output file to
render their report. An example of what the new
`02_report/produce_dummy_report.R` would look like, can be found below:

``` r

log_info("Produce dummy report - HTML")

# Import nps data assets -------------------------------------------------------
pipeline_import_for(data_assets = "html_report")

# Produce report ---------------------------------------------------------------
pipeline_render_report(markdown_file = "dummy_report.Rmd",
                       output_file = "dummy_report.htmll")
```

The function searches for a `dummy_report.Rmd` in `scripts/02_report/`,
and tries to save the report to what is stated in
`object_definitions.yaml` under the rmarkdown object with variable
`dir_html:`. The default is `dir_html: output/report/`.

> Looking for rendering with custom paths? See custom paths section.

### Advanced example

Whilst developing this function, the flexibility of `rmakrdown::render`
has been kept in mind. Because of this **all flexibility that you are
used to, is also available in `pipeline_render_report`.** One of the
more advanced use cases is looping trough a vector of different
*Municipal Health services*, and generating a report for each Health
service:

``` r

log_info("Produce dummy report - HTML")

# Import nps data assets -------------------------------------------------------
pipeline_import_for(data_assets = "html_report")

# Produce report ---------------------------------------------------------------
health_services <- c("group_1", "group_2", " group_3")

for (service in health_services){
  pipeline_render_report(markdown_file = "dummy_report.Rmd",
                         add_timestamp = FALSE,
                         output_file = str_c("report_", service, ".html"),
                         params = list(service = service))
}
```

### Custom paths

Even though most users will have their files in the standard EPI
pipeline folders, some might want to have more customization options.
Changing the standard markdown- and output file locations, can be done
with the `custom_markdown_path` & `custom_output_path` parameters
respectively.

Whilst the `custom_markdown_path` expects a relative path *(due to our
EPI pipeline working methods)*, the `custom_output_path` supports both
relative and absolute paths, meaning the user could also supply a save
location outside of the Rproject.

See the example below:

``` r

log_info("Produce dummy report - HTML")

# Import nps data assets -------------------------------------------------------
pipeline_import_for(data_assets = "html_report")

# Produce report ---------------------------------------------------------------
pipeline_render_report(markdown_file = "dummy_report.Rmd",
                       output_file = "dummy_report.hmtl",
                       custom_markdown_path = file.path("custom_markdown_folder"),
                       custom_output_path = file.path("custom_report_folder"))
```

> Note, the user is still expected to submit the file names. The customs
> *PATHS* only change the paths of the files.
