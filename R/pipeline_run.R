#' @title pipeline_run
#'
#' @description
#' Runs a EPI pipeline, given a set of tags/objects filters.
#'
#' A pipeline consists of the following steps:
#'
#' 1. Determine all the targets that needs to be generated.
#' 2. Then for each target not already in memory:
#'    1. Source the script that generates it (which internally imports dependencies using [pipeline_import_for()]).
#'    2. Cache the object to the cache folder.
#'    3. Save the object to the output folder.
#'
#' All of the configuration of the pipeline should be defined inside the config folder
#' and loaded into R using [pipeline_init()].
#'
#' @returns NULL
#'
#' @md
#' @export
#' @inheritParams grab_target_list
#' @seealso [mark_for_refresh()]
#' [grab_target_list()]
pipeline_run <- function(tags = NULL, objects = NULL, ..., p_e = pipeline_env) {
  check_dots_empty()
  log_info("Running {.code {get_expr(current_call())}}")

  objects_to_generate <- grab_target_list(tags, objects, p_e = p_e)
  n_objects <- length(objects_to_generate)

  defer(log_layout())

  for (i in 1:n_objects) {
    object_name <- objects_to_generate[[i]]
    log_layout(layout_generator_subject(object_name))

    if (!is.null(p_e$refresh) && (object_name %in% p_e$refresh)) {
      log_info("{.val {object_name}} was marked for refresh by {.code DARApipeline::mark_for_refresh()}")
    } else if (object_name %in% names(.GlobalEnv)) {
      log_info("{.val {object_name}} already generated")
      next
    }

    log_info("Starting... [{i} of {n_objects}]")
    source_object(object_name, p_e = p_e)
    cache_object(object_name, p_e = p_e)
    save_object(object_name, p_e = p_e)

    # only remove refresh status if sourcing was successful
    if (!is.null(p_e$refresh) && (object_name %in% p_e$refresh)) {
      p_e$refresh <- p_e$refresh[p_e$refresh != object_name]
    }
    log_info("Done!")
  }
  log_layout(layout = layout_simple)
  log_success("{.code {get_expr(current_call())}} finished! Generated {n_objects}.")
  invisible(NULL)
}


### Helper functions -----------------------------------------------------------

#' @title Source object
#' @description
#' helper function that sources the target objects.
#'
#'
#' @param object_name Character: the name of the object
#' @param p_e Object: package_environment, internal - do not use
#' @param return_env Object: the function execution environment, internal - do not use
#' @param call Object: the parent environment from return_env, internal - do not use
#'
#' @returns NULL
#' @keywords internal
#'
source_object <- function(object_name, p_e, return_env = .GlobalEnv, call = parent.frame()) {
  object_params <- p_e$object_param_list[[object_name]]
  generate_script <- object_params$generate_script
  assign(x = "curr_object", value = object_name, envir = p_e)
  object <- source(generate_script, local = TRUE)$value
  rm("curr_object", envir = p_e)

  # check if object returns NULL
  if (is.null(object)) {
    cli_abort(
      c(
        "!" = "No object found after sourcing {.file {generate_script}}",
        i = "The last (unnamed) object in this script is returned for saving."
      ),
      call = call
    )
  } else {
    log_info("Object succesfully created!")
  }
  return_env[[object_name]] <- object
  p_e$object_param_list[[object_name]]$is_generated <- TRUE
  invisible(NULL)
}

#' @title Cache object
#' @description
#' Helper function that caches the object.
#'
#'
#' @param object_name Character: the name of the object
#' @param p_e Object: package_environment, internal - do not use
#' @param call Object: the parent environment from return_env, internal - do not use
#'
#' @returns NULL
#' @keywords internal
#'
cache_object <- function(object_name, p_e, call = parent.frame()) {
  check_string(object_name, call = call)
  check_data_asset(object_name, "object", p_e = p_e, call = call)
  object_params <- p_e$object_param_list[[object_name]]

  if (object_params$skip_cache) {
    return(invisible(NULL))
  }

  if (!exists(object_name, .GlobalEnv)) {
    cli_abort(c("!" = "{.code cache_object()} can't save {.var {object_name}}. Object not found!"), call = call)
  }

  cache_file <- object_params$cache_file

  if (!dir.exists(dirname(cache_file))) {
    log_info("Creating cache-directory {.file {dirname(cache_file)}}")
    dir.create(dirname(cache_file), recursive = TRUE)
  }
  if (file.exists(cache_file)) {
    log_warn("Overwriting previous cache on {.file {cache_file}}")
  } else {
    log_info("Caching to {.file {cache_file}}")
  }
  saveRDS(get(object_name, envir = .GlobalEnv), cache_file)
  invisible(NULL)
}

#' @title Save image
#' @description
#' Helper function that saves an image.
#'
#'
#' @param object Object to be saved as image
#' @param bestand File name to create on disk
#' @param device Device to use. Parameter to be used within ggsave
#'
#' @returns NULL
#' @keywords internal
#'
save_image <- function(object, bestand, device, ...) {
  if (!length(list(...))) { # Default
    ggsave(
      bestand,
      object,
      device = device, width = 15,
      height = 10, units = "cm", scale = 2
    )
  } else { # Custom
    ggsave(bestand, object, device = device, ...)
  }
}

#' @title Save object
#' @description
#' Helper function that saves the object.
#'
#'
#' @param object_name Character: the name of the object
#' @param p_e Object: package_environment, internal - do not use
#' @param call Object: the parent environment from return_env, internal - do not use
#'
#' @returns NULL
#' @keywords internal
#'
save_object <- function(object_name, p_e, call = parent.frame()) {
  check_data_asset(object_name, "object", p_e, call = call)
  object_params <- p_e$object_param_list[[object_name]]
  if (length(object_params$output_formats) + length(object_params$output_formats_custom) == 0) {
    return(invisible(NULL))
  }

  if (!exists(object_name, .GlobalEnv)) {
    cli_abort(c("!" = "{.code cache_object()} can't save {.var {object_name}}. Object not found!"), call = call)
  }

  output_formats <- object_params$output_formats
  output_formats_custom <- object_params$output_formats_custom
  output_arguments <- object_params$output_arguments
  output_dir <- object_params$output_dir
  copy_to_filepath <- object_params$copy_to_file_path

  # default list of save functions
  default_save_funcs <- list(
    csv = write_csv2,
    png = function(object, bestand, ...) {
      save_image(object, bestand, device = grDevices::png, ...) # Here, the device *function* 'png'
    },
    svg = function(object, bestand, ...) {
      save_image(object, bestand, device = "svg", ...) # Here, the *string* 'svg'
    },
    xlsx = write_xlsx
  )
  # filter save_funcs for selected output_formats
  ext_options <- names(default_save_funcs)
  if (length(setdiff(output_formats, ext_options))) {
    unnknown_ext <- output_formats[!output_formats %in% names(default_save_funcs)]
    cli_abort(c(
      "!" = "Parameter output_formats for data/object {.val {object_name}} must be one of
            {.val {names(default_save_funcs)}}, not {.val {unnknown_ext}}",
      "i1" = "Adjust the config file {.file config/base/object_definitions.yaml} and rerun
            {.run DARApipeline::pipeline_init()}.",
      "i2" = "Alternatively, see {.help DARApipeline:::save_object()} for explanation
            on how to use custom formats with custom functions."
    ))
  }

  ext_std <- intersect(output_formats, ext_options)
  save_funcs <- default_save_funcs[ext_std]

  for (ext in names(output_formats_custom)) {
    func_name <- output_formats_custom[[ext]]
    if (length(find(func_name)) == 0) {
      cli_abort(c(
        "!" = "Object can't be saved because the custom saving function {.val {func_name}} can't be found.",
        "i" = "Load {.val {func_name}} into R before running {.code pipeline_ru()}."
      ))
    }
    save_funcs[[ext]] <- get(func_name)
  }

  save_parms <- list()

  # Add optional extra arguments
  for (ext in unique(c(output_formats, names(output_formats_custom)))) {
    save_parms[[ext]] <- output_arguments[[ext]]
  }

  for (ext in names(save_funcs)) {
    save_f <- save_funcs[[ext]]
    save_p <- save_parms[[ext]]
    ## GET
    run_timestamp <- get("run_timestamp", envir = p_e)
    output_file_ext <- str_glue("{output_dir}/{object_name}_{run_timestamp}.{ext}")
    log_info("Saving with {.arg ext} {.val {ext}} to {.file {output_file_ext}}")
    dir.create(output_dir, FALSE, TRUE)
    do.call(save_f, c(list(get(object_name, envir = .GlobalEnv)), c(output_file_ext), save_p))
  }
  invisible(NULL)
}
