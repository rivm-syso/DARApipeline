# Changelog

## DARApipeline v0.8.4

16-07-2026

#### 🛠️ Changed

- URL of gitpages was changed from dara.gitpages.rivm.nl/DARApipeline to
  gitpages.rivm.nl/dara/DARApipeline.

## DARApipeline v0.8.3

30-06-2026

#### 🛠️ Changed

- Fixed bug in
  [`check_most_recent_data()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/check_most_recent_data.md):
  the validity check was performed using 24-hour intervals instead of
  calendar dates. As a result, e.g., when checking data shortly after
  09:10 with `days_valid_data = 1`, data from the previous day at 09:10
  was incorrectly rejected.

## DARApipeline v0.8.2

07-05-2026

#### 🛠️ Changed

- Fixed bug in
  [`most_recent_file()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/most_recent_file.md),
  `open_tbl_con`, and
  [`load_data()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/load_data.md)where
  some error and some warning messages were uninformative or errored.

- Updated documentation on
  [`check_dependencies_not_listed()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/check_dependencies_not_listed.md),
  [`check_usage_dependencies()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/check_usage_dependencies.md).
  [`remove_comments()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/remove_comments.md).

## DARApipeline v0.8.1

10-03-2026

#### 🛠️ Changed

- Added the new function `check_most_recent_data` tot he pkgdown.yaml so
  the pkgdown website can be updated.

## DARApipeline v0.8.0

26-02-2026

#### ✨ Added

- Deploy DARApipeline on RIVM Syso Github
- Added the function `check_most_recent_data`, which prints the runtime
  stamp of the most recent data file and errors if the data is older
  than the specified time window in days (#143).

#### 🛠️ Changed

- Changed the CICD Rpackage setup. Now it first scans the known libpaths
  (including the docker image), before installing missing packages. This
  results in a faster CICD-pipeline runtime. (#174).

#### 🐛 Fixed

- Commented object names are no longer flagged by
  check_dependencies_not_listed function (#181).

- All config checks now give warnings instead of errors and an empty
  config should not result in an error(#177).

#### ⚰️ Deprecated

## DARApipeline v0.7.2

18-11-2025

#### 🐛 Fixed

- Fixed wrong missing dependencies are returned from
  [`check_usage_dependencies()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/check_usage_dependencies.md)
  and
  [`check_dependencies_not_listed()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/check_dependencies_not_listed.md)
  in
  [`setup_environment()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/setup_environment.md)
  when two names of dependencies partly overlap (#172)

## DARApipeline v0.7.1

30-10-2025

#### 🐛 Fixed

- Fixed function index in `_pkgdown.yml` (#158)

## DARApipeline v0.7.0

30-10-2025

#### ✨ Added

- Added vignette for `copy_asset` function (#111).
- Added `check_usage_dependencies`, to check that the dependencies
  specified in the object_relation.yaml file are actually used in the R
  object script. (#42)
- Added a checks on the content of the config file (#125) (#126)
- Added `check_dependencies_not_listed`, to check whether any of the
  dependencies specified in the config files are used but not listed in
  `object_relations.yaml`config. (#131)
- Added `check_last_successful_run` function to check when the last
  successful run of a pipeline happened (#86).
- Added option to change cache_dir in config/object_defintions.yaml.
  Default is cache_dir: cache/{RUN_TIMESTAMP}, however cache_dir:
  cache/{YEAR} or cache_dir: cache/{MONTH} is also possible (#90).

#### 🛠️ Changed

- ci/cd changes: seperated the stages, added check and coverage (#121),
  fix cache (#137)
- Fix naming of variables if they were unclear (#141)
- Clean comments in test and R folders (#142)
- Remove unused fixtures for unittests (#144)
- Check unused dependencies and move dependencies to suggest if possible
  (#146)

#### 🐛 Fixed

- Big refactor of the function `copy_asset` (#111)
- correction in the vignette instruction (#147)

#### ⚰️ Deprecated

- Ambiguous helper functions for `copy_asset` (#111)

## DARApipeline v0.6.0

07-08-2025

#### ✨ Added

- Added extension ‘svg’ as a standard option for saving outputs (#112).
- Added a new vignette on how to run your pipeline with an old timestamp
  (#43).
- Added common mistakes linters and linted whole package (#110).
- Added executing lintr tag (#116).
- Changed CI/CD structure and image (#113).

#### 🐛 Fixed

#### ⚰️ Deprecated

- Function save_cache is now deprecated, because cache_object() is used
  in pipeline_run()

## DARApipeline v0.5.1

11-06-2025

#### ✨ Added

- Set code example install instruction build = FALSE (#101)
- Internal documentation for helper functions (#104)

#### 🛠️ Changed

- Removed internal helper functions from pkgdown website reference page
  (#96)

#### 🐛 Fixed

- remove logger 0.3.0 remotes URL from DESCRIPTION file (#99)
- fix typos in suggestion message “proj_definitions.yaml” to
  “object_definitions.yaml” in pipeline_import_for() and pipeline_run()
  (#103) \### ⚰️ Deprecated

## DARApipeline v0.5.0

19-05-2025

#### ✨ Added

- Added `pipeline_render_report`, a wrapper for
  [`rmarkdown::render`](https://pkgs.rstudio.com/rmarkdown/reference/render.html),
  which fixes the displaying errors in markdown files bug.

- `pipeline_import_for` now has the ability to import a single, specific
  excel sheet. Previously all sheets in the excel workbook were
  imported. This is still the default. A specific sheet can be imported
  via the `sheet_arg` argument in the `config/object_definitions.yaml`
  file. (#85)

#### 🛠️ Changed

- Organized all functions in the Reference tab on Pages site. (#64)

- logger dependency back to \>=0.3.0 (instead of fixed at ==0.3.0) \###
  🐛 Fixed

#### ⚰️ Deprecated

## DARApipeline v0.4.1

12-02-2025

#### ✨ Added

#### 🛠️ Changed

#### 🐛 Fixed

- NEWS.md header fix

#### ⚰️ Deprecated

## DARApipeline v0.4.0

12-02-2025

#### ✨ Added

#### 🛠️ Changed

#### 🐛 Fixed

- grab_current_drive_name() now returns either “r” for target_mount
  equal to “rivm” and “r-schijf” for target_mount equal to “mnt”

#### ⚰️ Deprecated

## DARApipeline v0.3.0

13-01-2025

#### ✨ Added

#### 🛠️ Changed

- Changed name of function `grab_current_mount` to `grab_target_mount`
  (#61)

- Updated NEWS.md file so it would work with pkgdown (#72).

#### 🐛 Fixed

#### ⚰️ Deprecated

## DARApipeline v0.2.0

11-12-2024

#### ✨ Added

- Downgraded minimal pkgdown version to 2.0.7 (#71).

- Added a coverage report and pkgdown site via GitLab Pages (#59).

#### 🛠️ Changed

#### 🐛 Fixed

- Fix logger 0.3.0 dependency (#68).

#### ⚰️ Deprecated

## DARApipeline v0.1.1

05-11-2024

#### 🐛 Fixed

- Version bump to correct the tag versioning.

## DARApipeline v0.1.0

31-10-2024

#### ✨ Added

- Created a coverage report and hosted the pkgdown site on GitLab Pages.

- Added `pipeline_status`, which prints a status overview of the EPI
  pipeline (#1).

- Added `pipeline_viz`, which visualizes the network defined by the
  object_relations.yaml config file(#1).

- Added `mark_for_refresh`, which marks data_assets for refresh (#1).

- Added `pipeline_import_for`, which imports the dependencies given a
  list of asset names (#1).

- Added `pipeline_run`, which runs a EPI pipeline, given a set of
  tags/objects filters (#1).

- Added `setup_environment`, which should run before creation of each
  object in a EPI pipeline to ensure that the dependencies are loaded
  (#8).

- Added `grab_object_table`, `grab_run_timestamp` ,
  `grab_current_drive_name`, `grab_current_mount`, and
  `grab_target_list` (#12).

- Added `pipeline_init`, which initiates configuration of DARApipeline
  for use in an EPI pipeline (#2).

- Added `save_data`, which saves R objects as a file with a timestamp in
  a specified directory (#9).

- Added `open_tbl_con`, which takes a list of database and schema
  arguments and connects to a table in the database (#11).

- Added `get_sp_data`, which retrieves data from a store procedure
  database within a start and end modification date (#7).

- Added `idle`, which waits for a file to be available in a given
  directory (#5).

- Added `save_output`, which saves an object as output with the DARA
  naming (#13).

- Added `save_cache`, which saves an object to the cache directory (#3).

- Added `copy`, which uses the output_dir of a data_asset to determine
  where the object can be copied from (#6).

- Added `most_recent_file`, which returns path to most recent file in a
  directory with given pattern and extension. Fixed in (#6), but issue
  description in (#10).

- Added `load_data`, which loads data from specified location and date
  (#4).

#### 🛠️ Changed

- Renamed pipeline_viz to pipeline_vis, to maintain consistency with the
  naming style of the DARAvis package (#30).

- Restructured R folder: 1 exported function per script to increase
  readibility and findability of functions (#34).

- Removed dependency on DARAvis package, used hex color codes directly
  in pipeline_viz instead of DARAvis:::palette_rivm (#31).

- Added coverage and pipeline badges to readme (#37).

- Removed the setup_environment code that still worked with the
  deprecated function import_from_config. Also removed the now unused
  depends_on_quoted parameter. Fixed this in the tests as well. (#27).

- Replace magrittr pipe by R’s native pipe (#21).

#### 🐛 Fixed

- Fixed `save_data`, so that `run_timestamp` is not required when
  parameter `timestamp_file_name` is set to FALSE (#25).

#### ⚰️ Deprecated
