#' Visualizes object creation as a graph.
#'
#' @description
#'
#' Visualizes the network defined by the object_relations yaml config file using
#' the [visNetwork](https://datastorm-open.github.io/visNetwork/) package. This
#' function is meant for interactive use to view the structure of an EPI report
#' pipeline and can be very useful for inspecting the dependencies of your
#' objects. The pipeline_vis() function can maximally visualize 18 tags.
#'
#' @returns NULL
#'
#' @export
#' @inheritParams pipeline_run
pipeline_vis <- function(..., p_e = pipeline_env) {
  check_dots_empty()

  check_pipeline_init(p_e = p_e)

  # shape useful for visNetwork
  graph_outputs_visnetwork <- p_e$object_dag |>
    toVisNetworkData()

  # check if there are nodes to visualize
  if (is_empty(graph_outputs_visnetwork$nodes)) {
    cli_abort(
      c(
        "!" = "Can't find any pipeline objects (nodes) to visualize.",
        "i" = "Perhaps the file {.code object_relations.yaml} is empty?"
      )
    )
  }

  graph_outputs_visnetwork$nodes <- graph_outputs_visnetwork$nodes |>
    left_join(
      grab_object_table() |> select(label = "data_asset_name", data_type = "type", "tag"),
      by = "label"
    ) |>
    mutate(tag = replace_na(.data$tag, "<NA>"))

  # coloring is done by tag
  n_clrs <- n_distinct(graph_outputs_visnetwork$nodes$tag)
  # use RIVM colors (also available through the DARAvis package)
  colors_categorical_rivm <- c(
    "#007bc7",
    "#ffb612",
    "#ca005d",
    "#552c6f",
    "#76d2b6",
    "#e17000",
    "#39870c",
    "#673327"
  )
  colors_extra_rivm <- c(
    "#154273",
    "#f092cd",
    "#f9e11e",
    "#275937",
    "#d52b1e",
    "#8fcae7",
    "#94710a",
    "#a90061",
    "#01689b",
    "#777b00"
  )
  # use the categorical palette as default, complement with a sample of extra colors if there are too many tags
  if (n_clrs <= length(colors_categorical_rivm)) {
    clrs <- colors_categorical_rivm[1:n_clrs] |>
      set_names(sort(unique(graph_outputs_visnetwork$nodes$tag)))
  } else if (n_clrs <= (length(colors_categorical_rivm) + length(colors_extra_rivm))) {
    extra_clrs <- colors_extra_rivm[1:(n_clrs - length(colors_categorical_rivm))]
    clrs <- c(colors_categorical_rivm, extra_clrs) |>
      set_names(sort(unique(graph_outputs_visnetwork$nodes$tag)))
  } else {
    cli_abort(
      c(
        "!" = "The pipeline_vis function can maximally visualize 18 tags."
      )
    )
  }

  # clean up nodes and edge data
  d_nodes <- graph_outputs_visnetwork$nodes |>
    mutate(
      color = clrs[.data$tag],
      shape = c("square", "dot", "diamond")[as.factor(.data$data_type)],
      title = sprintf("%s<br>type:%s<br>tag:%s", .data$id, .data$data_type, .data$tag),
      label = .data$id,
      level = -.data$hierarchy_level # flipped
    ) |>
    arrange("hierarchy_level", "tag", "data_type") |>
    select("id", "level", "color", "title", "label", "shape", "tag")

  if (nrow(graph_outputs_visnetwork$edges) > 0) {
    d_edges <- graph_outputs_visnetwork$edges |>
      left_join(d_nodes |>
                  select(from = "id", "tag", "color"), by = "from") |>
      mutate(title = .data$tag |>
               as.factor()) |>
      select("from",
             "to",
             "color",
             "title")
  } else {
    d_edges <- graph_outputs_visnetwork$edges
  }

  visNetwork(d_nodes, d_edges) |>
    visEdges(arrows = "from") |> # flipped
    visOptions(selectedBy = "tag") |>
    visHierarchicalLayout(
      edgeMinimization = FALSE,
      direction = "RL", # flipped
      levelSeparation = 300
    )
}
