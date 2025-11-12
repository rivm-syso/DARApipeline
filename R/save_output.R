#' Save an object as output
#'
#' @description save_output saves an object as output with the DARA naming
#'   convention. Some standard formats can be used, or, alternatively, a custom
#'   function that is found in the global environment. All files get
#'   timestamped. Note that only 1 file for of each extension is saved, with the
#'   custom formats having priority.
#'
#' @param object R object. The object that needs to be saved.
#' @param object_name Character. Name of the object Will be used in the
#'   output name.
#' @param output_dir character. Directory of the output file. Will be created if
#'   it doesn't exist yet.
#' @param run_timestamp character. The run_timestamp of the run. will be added to the
#'   filename.
#' @param output_formats character. Can be 'csv', 'png', 'svg' or 'xlsx'. Common saving
#'   formats.
#' @param output_formats_custom List. List in the form list(extension =
#'   name_of_function) e.g. list(tsv = 'write_tsv'). The function has to be
#'   loaded into the session an findable with \link[base]{get}.
#' @param output_arguments List. Extra arguments for output_formats(_custom) functions.
#'
#' @examples
#' \dontrun{
#' dir_temp <- tempdir()
#' save_output(
#'   object = tab_example,
#'   object_name = "tab_example",
#'   output_dir = "output/2023-W01/osiris/tab_example/",
#'   run_timestamp = "20230109_1201",
#'   output_formats = "csv"
#' )
#' }
#'
#' @export
save_output <- function(
    object,
    object_name,
    output_dir,
    run_timestamp = run_timestamp,
    output_formats,
    output_formats_custom = list(),
    output_arguments = list()) {
  if (!missing(output_formats)) {
    # default list of save functions
    default_save_funcs <- list(
      csv = write_csv2,
      png = function(object, bestand, ...) {
        save_image(object, bestand, device = png, ...) # Here, the device *function* 'png'
      },
      svg = function(object, bestand, ...) {
        save_image(object, bestand, device = "svg", ...) # Here, the *string* 'svg'
      },
      xlsx = write_xlsx
    )
    # filter save_funcs for selected output_formats
    save_funcs <- default_save_funcs[names(default_save_funcs) %in% output_formats]
    if (any(!output_formats %in% names(default_save_funcs)) && !length(output_formats_custom)) {
      unknown_format <- output_formats[!output_formats %in% names(default_save_funcs)]
      cli_abort(c(
        "!" = "Object can't be saved with the {.arg output_format} {.val {unknown_format}}.",
        "i1" = "{.arg output_format} must be one of {.val {names(default_save_funcs)}}.",
        "i2" =
          "See {.help DARApipeline::save_output} for explanation on how to use custom formats with custom functions"
      ))
    }
  } else {
    save_funcs <- list()
  }

  # add custom funcs if not in save_funcs
  for (ext in names(output_formats_custom)) {
    func_name <- output_formats_custom[[ext]]
    if (length(find(func_name)) == 0) {
      cli_abort(c(
        "!" = "Object can't be saved because the custom saving function {.val {func_name}} can't be found.",
        "i" = "Load {.val {func_name}} into R before running {.code save_output()}."
      ))
    }
    if (ext %in% names(save_funcs)) {
      log_warn("Using custom function for ext='{ext}'")
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
    output_file_ext <- str_glue("{output_dir}/{object_name}_{run_timestamp}.{ext}")
    log_info("Saving with {.arg ext} {.val {ext}} to {.file {output_file_ext}}")
    dir.create(output_dir, FALSE, TRUE)
    do.call(
      save_f,
      c(list(object), c(output_file_ext), save_p)
    )
  }
  invisible(NULL)
}
