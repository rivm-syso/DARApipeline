# Package index

## Pipeline functions

The full set of functions to initialize, start, and check your pipeline.
Including setup_environment to interactively start a pipeline for a
specific object.

- [`pipeline_init()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/pipeline_init.md)
  : Initiate DARApipeline for an EPI pipeline
- [`pipeline_run()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/pipeline_run.md)
  : pipeline_run
- [`pipeline_import_for()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/pipeline_import_for.md)
  : pipeline import for
- [`pipeline_status()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/pipeline_status.md)
  : Print a status overview of the EPI pipeline
- [`pipeline_vis()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/pipeline_vis.md)
  : Visualizes object creation as a graph.
- [`setup_environment()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/setup_environment.md)
  : Setup the R environment for creation of objects
- [`pipeline_render_report()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/pipeline_render_report.md)
  : DARA function that renders markdown files
- [`check_last_successful_run()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/check_last_successful_run.md)
  : Check last Successful run
- [`check_most_recent_data()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/check_most_recent_data.md)
  : Check most recent data file within x days

## Grab functions

Functions to grab parameters of the current EPI pipeline, such as
timestamp, mount, drive name and more.

- [`grab_current_drive_name()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/grab_current_drive_name.md)
  : Grab the drive_name for the current EPI pipeline.
- [`grab_object_table()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/grab_object_table.md)
  : Grab object_params for all data_assets for the current EPI pipeline.
- [`grab_run_timestamp()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/grab_run_timestamp.md)
  : Grab the run_timestamp for the current EPI pipeline.
- [`grab_target_list()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/grab_target_list.md)
  : Grab a list of target objects given tag/object filters.
- [`grab_target_mount()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/grab_target_mount.md)
  : Grab the mount for the current EPI pipeline.

## Load and save functions

Including functions to open database connections and get the most file
path for the most recent file in a given directory.

- [`get_sp_data()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/get_sp_data.md)
  : Retrieves data from a store procedure database within a start and
  end modification date
- [`load_data()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/load_data.md)
  : Load data from specified location and date
- [`most_recent_file()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/most_recent_file.md)
  : Return path to most recent file in a directory with given pattern
  and extension
- [`open_tbl_con()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/open_tbl_con.md)
  : Creates an active dbplyr tbl connection to a database
- [`save_cache()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/save_cache.md)
  : Save an object to the cache directory
- [`save_data()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/save_data.md)
  : Save data
- [`save_output()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/save_output.md)
  : Save an object as output

## Copy functions

Functions used to copy files and paths to and from copy locations.

- [`copy_asset()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/copy_asset.md)
  : Copy single asset
- [`get_copy_from_file_path()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/get_copy_from_file_path.md)
  : Get the copy from file path from object_definitions
- [`get_copy_to_dir_path()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/get_copy_to_dir_path.md)
  : Get the copy to dir path from object_definitions

## Other functions

- [`idle()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/idle.md)
  : Idle
- [`mark_for_refresh()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/mark_for_refresh.md)
  : Mark data_assets for refresh
