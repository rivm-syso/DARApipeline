#' Idle
#'
#' @description Waits for a file to be available in a given directory.
#'
#' @param dir Character. Directory path.
#' @param file_pattern Character. Pattern of file that will be waited on.
#' @param max_mins Integer. Maximum number of minutes to be idle.
#' @param sleep_mins Double. Refresh time to check for file.
#' @param file_modification_buffer_mins Integer. Time since last update time of file.
#'
#' @examples
#' \dontrun{
#' idle(".", "\.", max_mins = 1, sleep_mins = .2, file_modification_buffer_mins = 1)
#' }
#'
#' @export
idle <-
  function(dir,
           file_pattern,
           max_mins = 15,
           sleep_mins = .2,
           file_modification_buffer_mins = 1) {
    end_time <- now() + seconds(max_mins * 60)

    idletrings <-
      str_c("\b", c("\\", "|", "/", "-")) |>
      rep(length.out = round(sleep_mins * 60))

    while (TRUE) {
      f <- list.files(dir, pattern = file_pattern, full.names = TRUE)
      msg <-
        str_glue(
          "\rPress [ESC] to stop. Searching for file_pattern=[{file_pattern}] in
          dir=[{dir}] this has been checked at  [{format(now(), '%H:%M:%S')}], "
        )
      cat(msg)
      if (length(f) > 0) {
        cat("\n")
        if (now() <= (file.mtime(f) + seconds(file_modification_buffer_mins * 60))) {
          # File should not be actively saved by another process when reading
          # because file can still be incomplete.
          # note: during active saving of file the modification time changes continuously
          message("File found, but we wait until modification time is not too recent")
          while (now() <= (file.mtime(f) + seconds(file_modification_buffer_mins * 60))) {
            Sys.sleep(5) # check every 5 seconds
          }
        }
        message(sprintf(
          "File(s) found! [%s] continuing...",
          str_c(f, collapse = ";")
        ))
        return(invisible(NULL))
      } else if (now() > end_time) {
        cat("\n")
        cli_abort(
          c(
            "{.arg file_pattern}=[{file_pattern}] in dir=[{dir}] is not yet found but ",
            "the {.arg max_mins} of {max_mins} minutate have passed!"
          )
        )
      } else {
        if (interactive()) {
          cat("... -")
          for (s in idletrings){
            cat(s)
            Sys.sleep(1) # 1s is refresh time of the idle string
          }
        } else {
          Sys.sleep(sleep_mins * 60)
        }
      }
    }
  }
