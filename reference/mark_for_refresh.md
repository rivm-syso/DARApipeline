# Mark data_assets for refresh

Ensures that data_asset will be reimported by
[`pipeline_import_for()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/pipeline_import_for.md)
or regenerated during
[`pipeline_run()`](http://dara.gitpages.rivm.nl/DARApipeline/reference/pipeline_run.md)
(whichever comes first).

## Usage

``` r
mark_for_refresh(data_assets = NULL, ..., p_e = pipeline_env)
```

## Arguments

- data_assets:

  Character. Which data_assets (objects/data/other) should be refreshed?
  Defaults to all data_assets of the pipeline.

- ...:

  For internal use. Leave empty.

- p_e:

  For internal use. The hidden pipeline state environment.
