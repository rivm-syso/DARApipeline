#' @title Initialize config
#' @description
#' # Helper function kicked of in pipeline_init
#'  This function was separated from the init.R file because of its size and many sub-helper functions
#'
#' @param dir_config Path: to directory which holds the configuration files.
#' @param p_e Object: package_environment, internal - do not use
#' @param .call Object: the parent environment from return_env, internal - do not use
#'
#' @returns NULL
#' @keywords internal
#'
init_config <- function(dir_config, p_e, .call = parent.frame()) {
  # loads the config file, but only if changed

  ## GET
  old_config_hash <- p_e$config_hash
  file_paths <- path(dir_config, "base", "file_paths.yaml")
  file_relations <- path(dir_config, "base", "object_relations.yaml")
  file_definitions <- path(dir_config, "base", "object_definitions.yaml")

  if (!all(file_exists(c(file_paths, file_relations, file_definitions)))) {
    cli_abort(
      c(
        "!" = "Config files not found! Can't interpret pipeline config.",
        "i" = "The following are needed: {.file {file_paths}}, {.file {file_relations}}, {.file {file_definitions}}"
      ),
      call = .call
    )
  }
  config_hash <- str_c(hash_file(file_paths),
                       hash_file(file_relations),
                       hash_file(file_definitions),
                       hash(p_e$run_timestamp))
  if (identical(config_hash, old_config_hash)) {
    log_info("{.file {dir_config}} is unchanged.")
    return(invisible(NULL))
  }
  if (!is.null(.GlobalEnv[["config_hash"]])) {
    log_info("{.file {dir_config}} has changed. Reloading..")
  } else {
    log_info("Importing config from {.file {dir_config}}..")
  }

  # checks and load config yamls
  conf_paths <- conf_check_load_proj_paths(file_paths)
  conf_relations <- conf_check_load_relations(file_relations)
  conf_definitions <- conf_check_load_definitions(file_definitions)

  # all objects in the project
  all_objects <- conf_get_all_objects(conf_relations, conf_definitions)

  # inter-object info
  object_dag <- conf_create_dag(conf_relations, all_objects)

  # object centric info, paths/tags
  object_param_list <- map(all_objects, \(x) {
    conf_register_object(x, conf_paths, conf_definitions, object_dag, p_e = p_e)
  }) |>
    set_names(all_objects)

  ## ASSIGN
  assign("config_hash", config_hash, envir = p_e)
  assign("object_param_list", object_param_list, envir = p_e)
  assign("object_dag", object_dag, envir = p_e)
  return(invisible(NULL))
}


### Helper functions -----------------------------------------------------------

#' @title Check and load project paths
#' @description
#' Helper function to read project paths
#'
#'
#' @param f Path: filepath
#' @param .call Object: the parent environment from return_env, internal - do not use
#'
#' @returns yaml
#' @keywords internal
#'
conf_check_load_proj_paths <- function(f, .call = parent.frame()) {
  conf <- read_yaml(f)

  conf_check_empty(conf)

  # check index names file_paths
  indexes_file_paths <- c("dir_outputs", "dir_scripts")
  if (grepl("file_paths.yaml$", f) &&
        !all(indexes_file_paths %in% names(conf))) {
    cli_abort(
      c("!" = "Not all expected indexes found in {.file {f}}! Can't interpret pipeline config.",
        "i" = "The following indexes are needed: {indexes_file_paths}"),
      call = .call
    )
  }
  return(conf)
}

#' @title Check and load relations
#' @description
#' Helper function to read object relations
#'
#' @param f Path: filepath
#' @param .call Object: the parent environment from return_env, internal - do not use
#'
#' @returns yaml
#' @keywords internal
#'
conf_check_load_relations <- function(f, .call = parent.frame()) {
  read_yaml(f)
}

#' @title check and load definitions
#' @description
#' Helper function to read object definitions
#'
#' @param f Path: filepath
#' @param .call Object: the parent environment from return_env, internal - do not use
#'
#' @returns yaml
#' @keywords internal
#'
conf_check_load_definitions <- function(f, .call = parent.frame()) {
  conf <- read_yaml(f)

  conf_check_empty(conf = conf)

  # check index names object_definitions
  indexes_object_definitions <- c("__defaults__")
  if (grepl("object_definitions.yaml$", f) &&
        !all(indexes_object_definitions %in% names(conf))) {
    cli_abort(
      c("!" = "Not all expected indexes found in {.file {f}}! Can't interpret pipeline config.",
        "i" = "The following index is needed: {indexes_object_definitions}"),
      call = .call
    )
  }
  return(conf)
}

#' @title check config empty
#' @description
#' Helper function to check if config is empty
#'
#' @param conf loaded config file
#' @param .call Object: the parent environment from return_env, internal - do not use
#'
#' @returns NULL
#' @keywords internal
#'
conf_check_empty <- function(conf = conf, .call = parent.frame()) {
  # check config not empty
  if (is.null(conf)) {
    cli_abort(c("!" = "Config file  {.file {f}} is empty! Can't interpret pipeline config."),
              call = .call)
  }
  return(invisible(NULL))
}
#' @title Get all objects
#' @description
#' Helper function to get all objects
#'
#' @param conf_relations yaml: loaded yaml containing object relations from configuration file
#' @param conf_definitions yaml: loaded yaml containing object definitions from configuration file
#' @param .call Object: the parent environment from return_env, internal - do not use
#'
#' @returns combined objects
#' @keywords internal
#'
conf_get_all_objects <- function(conf_relations, conf_definitions, .call = parent.frame()) {
  objects_relations <- c(names(conf_relations), unlist(conf_relations))
  objects_definitions <- setdiff(names(conf_definitions), "__defaults__")
  union(objects_relations, objects_definitions) |>
    unique() |>
    sort()
}


#' @title Register object
#' @description
#' Helper function to register object
#'
#' @param object_name String: name of the object
#' @param conf_paths yaml: loaded yaml containing object paths from configuration file
#' @param conf_definitions yaml: loaded yaml containing object definitions from configuration file
#' @param object_dag Dag: Directed Acyclic Graph object
#' @param p_e Object: package_environment, internal - do not use
#' @param .call Object: the parent environment from return_env, internal - do not use
#'
#' @returns conf_object
#' @keywords internal
#'
conf_register_object <- function(
    object_name,
    conf_paths,
    conf_definitions,
    object_dag,
    p_e = pipeline_env,
    .call = parent.frame()) {
  if (is.null(conf_definitions[["__defaults__"]])) {
    cli_abort(c(
      "!" = "No default params found for proj_definitions",
      "i" = "Provide an object named {.val __defaults__} to set default parameters across all objects."
    ))
  }
  default_params <- conf_definitions[["__defaults__"]]
  object_params <- conf_definitions[[object_name]]

  if (!is.null(object_params)) {
    conf_object <- inheriting_merge(default_params, object_params)
  } else {
    conf_object <- default_params
  }

  conf_object$hierarchy_level <- vertex_attr(object_dag, "hierarchy_level", object_name)

  timestamp_value <- ymd_hm(p_e$run_timestamp)

  envir_glue <- env()
  envir_glue$YEAR <- year(timestamp_value)
  envir_glue$MONTH <- month(timestamp_value)
  envir_glue$DAY <- day(timestamp_value)
  envir_glue$ISOWEEK <- isoweek(timestamp_value)
  envir_glue$ISOYEAR <- isoyear(timestamp_value)
  envir_glue$RUN_TIMESTAMP <- p_e$run_timestamp
  envir_glue$TARGET_MOUNT <- p_e$target_mount
  envir_glue$DRIVE_NAME <- p_e$drive_name
  envir_glue$TAG <- conf_object$tag
  envir_glue$OBJECT_NAME <- object_name

  # Paths will be interpreted by str_glue_expliciterror
  if (conf_object$type == "object") {
    # Allow for changing cache directory in the object_defintions config
    if (conf_object$skip_cache) {
      conf_object$cache_dir <- NA_character_
    } else if (is.null(conf_object$cache_dir)) {
      conf_object$cache_dir <- paste0(getOption("DARApipeline.cachedir"), "/{RUN_TIMESTAMP}")
    }
    conf_object$cache_file <- if_else(
      condition = conf_object$skip_cache,
      true = NA_character_,
      false = path(conf_object$cache_dir, "/{OBJECT_NAME}.rds"),
      missing = path(conf_object$cache_dir, "/{OBJECT_NAME}.rds")
    )
    conf_object$output_dir <- conf_paths$dir_outputs
    conf_object$script_dir <- conf_paths$dir_scripts

    conf_object$generate_script <- path(conf_object$script_dir, "{OBJECT_NAME}.R")

    conf_object$is_generated <- FALSE
  }
  conf_object$depends_on <- neighborhood(object_dag, 1, object_name, "out", 1) |>
    unlist() |>
    names()
  conf_object |>
    map_if(
      \(x) is.character(x) && length(x) == 1 && !is.na(x),
      \(x) str_glue_expliciterror(x, .envir = envir_glue) |> as.character()
    )
}


#' @title Create Dag
#' @description
#' Helper function to create DAGs
#'
#'
#' @param conf_relations yaml: loaded yaml containing object relations from configuration file
#' @param all_objects All objects, returned from `conf_get_all_objects`
#' @param call Object: the parent environment from return_env, internal - do not use
#'
#' @returns gr: Graph object
#' @keywords internal
#'
conf_create_dag <- function(conf_relations, all_objects, call = parent.frame()) {
  if (!is.null(conf_relations)) {
    gr <- tibble(to = names(conf_relations), from = conf_relations) |>
      unnest_longer(from) |>
      graph_from_data_frame(vertices = all_objects)
  } else {
    gr <- tibble(to = all_objects, from = all_objects) |>
      graph_from_data_frame() |>
      simplify(remove.multiple = FALSE,
               remove.loops = TRUE)
  }

  vertex_attr(gr, "hierarchy_level") <- -(gr |> set_hierarchy(call = call))

  gr
}

#' @title Set hierarchy
#' @description
#' Helper function to set hierarchy for `conf_create_dag`
#'
#'
#' @param gr Graph: Grab object that holds DAG
#' @param call the parent environment from return_env, internal - do not use
#'
#' @returns hierarchy_level
#' @keywords internal
#'
set_hierarchy <- function(gr, call = parent.frame()) {
  hierarchy_level <- rep(NA, length(gr))
  names(hierarchy_level) <- vertex_attr(gr, "name")
  cur_rank <- 0
  gr_sub <- gr
  while (length(gr_sub) > 0) {
    cur_rank <- cur_rank + 1
    # all vertices in subgraph with 0 inward edges
    is_curr_edge <- neighborhood(gr_sub, mode = "in", mindist = 1) |>
      map_lgl(~ length(.x) == 0)
    if (all(!is_curr_edge)) {
      cli_abort(
        c(
          "!" = "Edge hierarchy can't be determined! ",
          "i" = "Dependencies are probably cyclicacal so a directed acyclic graph cannot be constructed"
        ),
        call = call
      )
    }
    curr_edge <- vertex_attr(gr_sub, "name")[is_curr_edge]
    hierarchy_level[curr_edge] <- cur_rank
    # remove current edges from next subgraph
    gr_sub <- gr_sub |> subgraph(!is_curr_edge)
  }
  hierarchy_level
}
