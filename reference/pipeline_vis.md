# Visualizes object creation as a graph.

Visualizes the network defined by the object_relations yaml config file
using the [visNetwork](https://datastorm-open.github.io/visNetwork/)
package. This function is meant for interactive use to view the
structure of an EPI report pipeline and can be very useful for
inspecting the dependencies of your objects. The pipeline_vis() function
can maximally visualize 18 tags.

## Usage

``` r
pipeline_vis(..., p_e = pipeline_env)
```

## Arguments

- ...:

  For internal use. Leave empty.

- p_e:

  For internal use. The hidden pipeline state environment.
