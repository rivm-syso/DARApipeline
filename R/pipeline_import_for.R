#' @title pipeline import for
#'
#' @description
#' Imports the dependencies (objects / data / other) given a
#'  list of asset names. The imported objects will be loaded into the global
#'  environment.
#'
#' @param data_assets Character. Name of the data_assets (objects/other) that you want to import objects for.
#' Multiple asset names should passed in an array of the form 'c()'.
#' @param ... Additional arguments. Should be empty.
#'
#' @returns NULL
#'
#' @md
#' @export
#' @inheritParams pipeline_run
#' @inheritParams grab_object_table
pipeline_import_for <- function(data_assets, ..., p_e = pipeline_env, call = parent.frame()) {
  check_data_asset(data_assets, c("object", "other"), p_e = p_e, call = call)

  depends_on <- grab_object_table() |>
    filter(data_asset_name %in% data_assets) |>
    pull(depends_on) |>
    unlist() |>
    unique()

  walk(depends_on, \(x) import_object(x, p_e = p_e, call = call))

  return(invisible(NULL))
}

### Helper functions -----------------------------------------------------------

#' @title Import object
#' @description
#' Helper function that imports the object.
#'
#'
#' @param data_asset_name Character. Name of the data_asset (objects/other) that you want to import object for.
#' @param p_e Object: package_environment, internal - do not use
#' @param call Object: the parent environment from return_env, internal - do not use
#'
#' @returns NULL
#' @keywords internal
#'
import_object <- function(data_asset_name, p_e, call = parent.frame()) {

  check_data_asset(data_asset_name, c("data", "other", "object"), p_e, call = call)
  object_params <- p_e$object_param_list[[data_asset_name]]


  if (!is.null(object_params$sheet_arg)) {
    cmd_xlsx <- ".GlobalEnv[['{data_asset_name}']] <-  readxl::read_excel('{file_import}',
    sheet = '{object_params$sheet_arg}')"
  } else {
    cmd_xlsx <-  ".GlobalEnv[['{data_asset_name}']] <- readxl::excel_sheets('{file_import}') |>
    set_names() |> map(~readxl::read_excel('{file_import}', .x))"
  }

  import_commands <- list(
    csv = list(
      lib = "vroom",
      cmd = ".GlobalEnv[['{data_asset_name}']] <- vroom::vroom('{file_import}',
    show_col_types = getOption('readr.show_col_types'))"
    ),
    rds = list(
      lib = "vroom",
      cmd = ".GlobalEnv[['{data_asset_name}']] <- readr::read_rds('{file_import}')"
    ),
    fst = list(
      lib = "vroom",
      cmd = ".GlobalEnv[['{data_asset_name}']] <- fst::read_fst('{file_import}')"
    ),
    parquet = list(
      lib = "vroom",
      cmd = ".GlobalEnv[['{data_asset_name}']] <- arrow::open_dataset('{file_import}')"
    ),
    xls = list(
      lib = "vroom",
      cmd = cmd_xlsx
    ),
    xlsx = list(
      lib = "vroom",
      cmd = cmd_xlsx
    )
  )

  if (!is.null(p_e$refresh) && (data_asset_name %in% p_e$refresh)) {
    log_info("{.val {data_asset_name}} was marked for refresh by {.code DARApipeline::mark_for_refresh()}")
  } else if (data_asset_name %in% names(.GlobalEnv)) {
    log_info("{.val {data_asset_name}} already imported")
    return(invisible(NULL))
  }

  # check_data_asset(data_asset_name, c("data", "other", "object"), p_e, call = call)
  # object_params <- p_e$object_param_list[[data_asset_name]]

  # check valid type
  object_type <- object_params$type

  # get path to file
  if (object_type == "data") {
    # additional message in case of error in retrieval
    withCallingHandlers(
      {
        file_import <- most_recent_file(
          object_params$dir_input,
          pattern = data_asset_name,
          ext = names(import_commands),
          show_found_files = FALSE
        )
      },
      error = function(x) {
        log_error("Can't find file for import for {.val {data_asset_name}} in {.file {object_params$source_path}}!")
      }
    )
  } else if (object_type == "object") {
    file_import <- object_params$cache_file
  } else if (object_type == "other") {
    file_import <- object_params$dir_input
  }

  # check valid extension
  file_import_ext <- path_ext(file_import)
  if (!(file_import_ext %in% names(import_commands))) {
    cli_abort(
      c(
        "!" = "File extension in {.file {file_import}} for data/object {.val {data_asset_name}}
              must be one of {.val {names(import_commands)}}, not {.val {file_import_ext}}",
        "i" = "Adjust the config file {.file config/base/object_definitions.yaml} and
              rerun {.run DARApipeline::pipeline_init()}."
      ),
      call = call
    )
  }

  # import file
  check_installed(import_commands[[file_import_ext]]$lib)
  import_cmd <- str_glue(import_commands[[file_import_ext]]$cmd)
  log_info("IMPORT: ", import_cmd)
  eval(parse(text = import_cmd))

  # only remove refresh status if import was succesful
  if (!is.null(p_e$refresh) && (data_asset_name %in% p_e$refresh)) {
    p_e$refresh <- p_e$refresh[p_e$refresh != data_asset_name]
  }
  return(invisible(NULL))
}
