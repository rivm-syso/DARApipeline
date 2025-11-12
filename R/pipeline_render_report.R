#' DARA function that renders markdown files
#'
#' @description
#'
#' Runs rmarkdown::render() with extra functionality.
#' Default markdown filepath is inside the EPI /scripts/02_report folder
#' Default output filepath is `dir_html`, which is stated in the config file:
#' grab_object_table() %>% filter(tag == "html") %>% pull(dir_html)
#'
#' Custom paths overide the default paths
#'
#' @param markdown_file name of .Rmd file inside EPI 02_report folder to be rendered
#' @param output_file name of he .html output file. save location is dir_html
#' @param add_timestamp boolean to add timestamp to output file. default = TRUE
#' @param custom_markdown_path advanced use only. If not empty, this path overwrites the default markdown filepath
#' @param custom_output_path advanced use only. If not empty, this path overwrites the default save location for reports
#' @param quiet boolean used by rmarkdown::render to determine verbose usage.
#' @param ... For internal use. Leave empty.
#'
#' @returns None, renders markdown file
#'
#' @examples
#' \dontrun{
#' # Note that the different examples could be used interchangeably!
#'
#' # Render report with standard EPI pipeline locations
#' pipeline_render_report(markdown_file = "dummy_report.Rmd",
#'                        output_file = "dummy_report.html")
#'
#' # Render report with extra parameters (e.g. port script variables to markdown)
#' pipeline_render_report(markdown_file = "dummy_report.Rmd,
#'                        output_file = "dummy_report.html",
#'                        params = list(cur_hosp = current_hospital))
#'
#' # Render report with custom location without timestamp
#' pipeline_render_report(markdown_file = "dummy_report.Rmd",
#'                        ouput_file = "my_custom_report.html"
#'                        add_timestamp = FALSE,
#'                        custom_output_path = "output/extra_output")
#'
#' # Render markdown file from custom location
#' pipeline_render_report(markdown_file = "my_custom_markdown_file.Rmd,
#'                       output = "dummy_report.html",
#'                       custom_markdown_path = "extra_reports/")
#' }
#'
#' @export
pipeline_render_report <- function(markdown_file,
                                   output_file,
                                   add_timestamp = TRUE,
                                   custom_markdown_path = "",
                                   custom_output_path = "",
                                   quiet = TRUE,
                                   ...) {

  WD <- getwd()

  check_bool(add_timestamp)
  check_string(markdown_file, allow_empty = FALSE)
  check_string(output_file, allow_empty = FALSE)
  check_string(custom_markdown_path, allow_empty = TRUE)
  check_string(custom_output_path, allow_empty = TRUE)
  check_bool(quiet)

  log_info("Starting generation of markdown report...")

  # Check if the user added file extensions to filename
  markdown_file <- check_extension_helper(filename = markdown_file,
                                          ext = ".Rmd")
  output_file <- check_extension_helper(filename = output_file,
                                        ext = ".html")

  if (add_timestamp) {
    log_info("Adding timestamp to {.arg output_file} {.val {output_file}}...")
    output_file <- str_replace(output_file, ".html", str_c("_", grab_run_timestamp(), ".html"))
  }

  # Try to make output dir
  tryCatch({
    if (custom_output_path == "") {
      html_path <- file.path(WD,
        grab_object_table() |>
          filter(tag == "html") |>
          pull(dir_html)
      )
    } else {
      # Check if the user provided a relative or absolute custom output path
      check_installed("R.utils")
      if (R.utils::isAbsolutePath(custom_output_path)) {
        html_path <- custom_output_path
      } else {
        html_path <- file.path(WD, custom_output_path)
      }
    }
    dir.create(path = html_path,
               recursive = TRUE,
               showWarnings = FALSE)
  },
  error = function(e) {
    cli_abort(c(
      "i" = "Failed to create output directory, please check writing location!",
      "*" = "Original error:\t {e}"
    ), call = rlang::caller_env(4))
  })

  # This actually checks if the dir is created.
  if (!dir.exists(html_path)) {
    cli_abort(c(
      "*" = "Unable to create output directory {.val {html_path}}, please check writing location!"
    ), call = rlang::caller_env(4))
  }

  # Note: return 0 has writeable acces, -1 is not writeable.
  if (file.access(html_path, mode = 2) == -1) {
    cli_abort(c(
      "*" = "You have no write acces to {.val {html_path}}, please check writing location!"
    ), call = rlang::caller_env(4))
  }

  # Checks for markdown paths
  if (custom_markdown_path == "") {
    markdown_path <- check_path_helper(path = file.path(WD, "scripts/02_report"),
                                       file = markdown_file)
  } else {
    markdown_path <- check_path_helper(path = custom_markdown_path,
                                       file = markdown_file)
  }

  # Running the render function after logger sink
  local_logger_sink()
  render(input = markdown_path,
         output_file = file.path(html_path, output_file),
         ...)
}

#' Check extension (helper)
#'
#' @description
#' This function checks if the desired extension is present or not.
#' If the extension is not present, it concatenated it to the filenmae
#'
#' @param filename string, the filename
#' @param ext, string, the extension to check for
#'
#' @keywords internal
#' @return filename with extension
check_extension_helper <- function(filename, ext) {
  if (!grepl(ext, filename)) {
    if (grepl("\\..+$", filename)) {
      cli_abort(c(
                  "*" = "A different extension has been supplied to {.val {filename}}, then expected: {.val {ext}},
                  please change extension!"),
      call = rlang::caller_env(4)
      )
    }
    cli_inform("Can't find extension in {.val {filename}}, adding {.val {ext}}...")
    filename <- str_c(filename, ext)
  }
  return(filename)
}

#' Check path (helper)
#'
#' @param path string, the path to the file
#' @param file string, the name of the file
#'
#' @keywords internal
#' @return string, absolute, checked filepath of file
check_path_helper <- function(path, file) {
  if (!file.exists(file.path(path, file))) {
    cli_abort(c("Can't find {.val {file.path(path, file)}},
                  please specify an existing path to the file."),
              call = caller_env(4))
  }
  return(file.path(path, file))
}
