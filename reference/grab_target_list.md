# Grab a list of target objects given tag/object filters.

Retrieves a list of object(s) given a tag or object filters. This
function is run by
[pipeline_run](http://dara.gitpages.rivm.nl/DARApipeline/reference/pipeline_run.md)
internally to determine which target objects need to be created. It
determines which other objects need to be generated in case of
dependencies between objects and returns these even if they fall outside
the tags/objects filter (because they are upstream of the pipeline). Use
this function to figure out which objects
[pipeline_run](http://dara.gitpages.rivm.nl/DARApipeline/reference/pipeline_run.md)
will create without actually running
[pipeline_run](http://dara.gitpages.rivm.nl/DARApipeline/reference/pipeline_run.md)
yet.

Note that it only returns **objects** not other types of data_assets
(data/other).

## Usage

``` r
grab_target_list(
  tags = NULL,
  objects = NULL,
  ...,
  p_e = pipeline_env,
  call = parent.frame()
)
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

- call:

  For internal use. Used for error tracing.

## Value

A character of object names.
