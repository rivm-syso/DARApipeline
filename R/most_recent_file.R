#' Return path to most recent file in a directory with given pattern and
#' extension
#'
#' @description
#' Return path to most recent file in a directory with given pattern and
#' extension.
#'
#' @param dir Character. Path to directory.
#' @param pattern Character.
#' @param ext Character. Extension of the file.
#' @param show_found_files Logical.
#' @param ignore_tmp Logical. If TRUE, temporary owner files (~$) are ignored.
#' @param call Context of the parent interpreted function: environments
#' ('frames' in S terminology) associated with functions further up the calling stack.
#'
#' @examples
#' \dontrun{
#' most_recent_data(dir = "./example")
#' }
#'
#' @export
most_recent_file <- function(dir,
                             pattern = ".",
                             ext = "",
                             show_found_files = FALSE,
                             ignore_tmp = FALSE,
                             call = parent.frame()) {
  # If more directories/patterns are given, map2 over directories/patterns
  if (length(dir) > 1 && length(pattern) > 1) {
    if (length(dir) != length(pattern)) {
      cli_abort(
        c(
          "!" = "{.arg dir} and {.arg pattern} must have consistent lengths!",
          i = "{.code length(dir)} = {length(dir)}, {.code length(pattern)} = ({length(pattern)})"
        ),
        call = call
      )
    }
    return(
      map2_chr(
        dir, pattern,
        ~ most_recent_file(.x, .y, ext, show_found_files)
      )
    )
  }

  # make {} variables possible in file directories
  dir <- str_glue(dir)

  # List files in directory
  files <- list.files(dir, full.names = TRUE, recursive = TRUE) |>
    str_subset(pattern = pattern) |>
    str_subset(str_c(str_c(ext, "$"), collapse = "|"))
  # If there are no files in the directory, stop
  if (length(files) == 0) {
    # case: file found but wrong ext
    files_wrongext <- list.files(dir, full.names = TRUE, recursive = TRUE) |>
      str_subset(pattern = pattern) |>
      sprintf(fmt = "{.file %s}") |>
      set_names("*")
    if (length(files_wrongext) > 0 && any(nchar(ext) > 0)) {
      cli_abort(c(
        "!" = "No files found with {.arg ext} {.val {ext}} in {.arg dir} {.file {dir}}.",
        "The following file(s) with wrong {.arg ext} were found:",
        files_wrongext
      ))
    }

    # case: folder doesn't exist
    if (!dir.exists(dir)) {
      cli_abort(c(
        "!" = "{.arg dir} {.file {dir}} does not exist.",
        "i" = "Perhaps a previous step failed and the directory was never created?"
      ))
    }

    # case: file found but wrong pattern
    files_wrongname <- list.files(dir, full.names = TRUE, recursive = TRUE) |>
      str_subset(str_c(str_c(ext, "$"), collapse = "|")) |>
      sprintf(fmt = "{.file %s}") |>
      set_names("*")
    if (length(files_wrongname) > 0) {
      cli_abort(c(
        "!" = "No files found with {.arg pattern} {.val {pattern}} in {.arg dir} {.file {dir}}.",
        "The following file(s) with wrong {.arg pattern} were found:",
        files_wrongname,
        "i" = "By design the pattern has to match the files exactly!"
      ))
    }

    # other reason
    cli_abort(c("No files found in {.arg dir} {.file {dir}} with  {.arg ext} {.val {ext}}
                and {.arg pattern} {.val {pattern}} in {.arg dir} {.file {dir}}."))
  }
  if (show_found_files) {
    log_info("File{?s} found: {.file {files}}")
  }

  # Ignore temporary owner files (office)
  if (ignore_tmp) {
    files <- files |>
      str_subset("~\\$", negate = TRUE)
  }
  # Load files based on timestamp
  timestamps <- str_extract(files, "[0-9]{8}_[0-9]{4}") |>
    ymd_hm() |>
    discard(.p = is.na)
  if (length(timestamps) == 0) {
    file_mtimes <- file.info(files)$mtime
    most_recent_file <- files[file_mtimes == max(file_mtimes)]
    cli_warn(c(
      "Not one file found with a timestamp in {.arg dir} {.file {dir}}.",
      "The following most recent file based on last modification time is returned instead.",
      most_recent_file[[1]]
    ))
  } else {
    most_recent_file <- files[max(timestamps) == timestamps]
  }

  most_recent_file[[1]]
}
