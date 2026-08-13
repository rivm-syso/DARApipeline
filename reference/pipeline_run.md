# pipeline_run

Runs a EPI pipeline, given a set of tags/objects filters.

A pipeline consists of the following steps:

1.  Determine all the targets that needs to be generated.

2.  Then for each target not already in memory:

    1.  Source the script that generates it (which internally imports
        dependencies using
        [`pipeline_import_for()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/pipeline_import_for.md)).

    2.  Cache the object to the cache folder.

    3.  Save the object to the output folder.

All of the configuration of the pipeline should be defined inside the
config folder and loaded into R using
[`pipeline_init()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/pipeline_init.md).

## Usage

``` r
pipeline_run(tags = NULL, objects = NULL, ..., p_e = pipeline_env)
```

## Arguments

- tags:

  Character. Which tags should be in the list of targets? Defaults to
  all tags if objects = NULL.

- objects:

  Character. Which objects should be in the list of targets? Defaults to
  all objects if tags = NULL.

- ...:

  For internal use. Leave empty.

- p_e:

  For internal use. The hidden pipeline state environment.

## See also

[`mark_for_refresh()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/mark_for_refresh.md)
[`grab_target_list()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/grab_target_list.md)
