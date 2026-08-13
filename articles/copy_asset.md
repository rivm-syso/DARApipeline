# copy asset / object to another location

### Introduction

Some pipelines require data to be placed in multiple locations after
creation. The updated version of the
[`copy_asset()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/copy_asset.md)
function allows users to automate and streamline this process.

To use this functionality, users need add both the
[`copy_asset()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/copy_asset.md)
to their pipeline and add a new parameter to their
`object_definitions.yaml` file. The parameter is `copy_to_file_path`,
which specifies the destination path for the copied asset. This will be
explained further in the examples below.

The main reason this parameter was added to the config instead of the
function is that it allows the user for a simpler change of location:
instead of looking for all instances of
[`copy_asset()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/copy_asset.md)
in the pipeline code, the user can simply define a new path in the
config.

Below we will show a basic and advanced example of how to use the
[`copy_asset()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/copy_asset.md)
function along with some tips and tricks.

### Basic example

The following example shows a basic use case of the
[`copy_asset()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/copy_asset.md)
function. The function call `copy_asset` needs a single parameter: the
`object_name` that’s defined in the `object_definitions.yaml` file.

``` r

# Prepare ----------------------------------------------------------------------
source("scripts/00_prepare/prepare.R")

# Make backup and save objects -------------------------------------------------
source("scripts/01_objects/objects.R")

# Make report ------------------------------------------------------------------
source("scripts/02_report/report.R")

# Copy assets ------------------------------------------------------------------
DARApipeline::copy_asset("tab_cov_epicurve_agegr")
```

The function call can be placed anywhere in the pipeline **after** the
asset has been created. When placed before the object creation, the user
will be greeted with a fitting ‘object not found error’.

Next, the user needs to add the `copy_to_file_path` parameter to the
`object_definitions.yaml` file for each object that needs to be copied,
see example below:

``` r
tab_cov_epicurve_agegr:
  type: object
  tag: objects
  output_formats: xlsx
  copy_to_file_path: extra_output/
```

After running the pipeline, the user should find a copy of the object in
the folder `extra_output/`.

### Advanced example

To copy multiple objects, the user can call the
[`copy_asset()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/copy_asset.md)
function multiple times, once for each object.

Further more the user is also able to use the same config variables
which are mostly used in `file_paths.yaml`, such as `{RUN_TIMESTAMP}`
and `{YEAR}`.

The second paramter the user can use is `overwrite`, which is a boolean
parameter (TRUE/FALSE) that controls whether existing files should be
overwritten during the copy process. If set to TRUE, any existing files
at the destination will be replaced with the new copies. If set to FALSE
or not specified, the function will not overwrite existing files,
preserving the original versions.

``` r

# Prepare ----------------------------------------------------------------------
source("scripts/00_prepare/prepare.R")

# Make backup and save objects -------------------------------------------------
source("scripts/01_objects/objects.R")

# Make report ------------------------------------------------------------------
source("scripts/02_report/report.R")

# Copy assets ------------------------------------------------------------------
DARApipeline::copy_asset("tab_cov_epicurve_agegr")
DARApipeline::copy_asset("map_cov_incidence_mun")
```

``` r

tab_cov_epicurve_agegr:
  type: object
  tag: objects
  output_formats: xlsx
  copy_to_file_path: extra_output/{RUN_TIMESTAMP}/{YEAR}
map_cov_incidence_mun:
  type: object
  tag: objects
  output_formats: png
  copy_to_file_path: extra_output/
  overwrite: TRUE
```

> We recommend placing multiple functions calls together (if applicable)
> in the save or main scripts for clarity.

### Other

**Renaming the copied objects.** We purposely did not add functionality
to rename the copied objects during the copy process. The main reason
for this is clarity where objects got copied from or to and to avoid
confusion. If renaming an object is needed, this can be done manually or
using other functions such as
[`file.rename()`](https://rdrr.io/r/base/files.html) after the copy
process.

**Copying a single object to multiple locations.** This functionality
has not been added yet and will be considered in later updates.
