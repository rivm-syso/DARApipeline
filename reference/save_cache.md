# Save an object to the cache directory

Saves an object to the cache directory. This function is dependent on
DARA's directory structure.

save_cache is deprecated as of version 0.6.0.

## Usage

``` r
save_cache(object, object_name, cache_dir)
```

## Arguments

- object:

  The object that needs to be saved.

- object_name:

  The name of the object. This will be used as filename.

- cache_dir:

  The location of the cache. It is advised to use a timestamped
  directory.

## Examples

``` r
if (FALSE) { # \dontrun{
save_cache(cars, "cars", "cache/19000101_0000")
} # }
```
