## init storage for all pipelines parameters
pipeline_env <- new.env()

.onLoad <- function(libname, pkgname) {
  # Overwrite the formatter to a custom formatter (for global namespace, i.e.
  # anytime logger functions get used)
  log_formatter(formatter = formatter_cli, index = 1)

  # set default folder options. Only an option so it can be changed in tests.
  # not intended for users to change
  options(DARApipeline.cachedir = "cache")

  # whether to clear previously loaded objects from the environment
  options(DARApipeline.clearobjects = TRUE)
  # If interactive, above setting will be asked. store whether to ask the question again.
  options(DARApipeline.clearobjects_asked = FALSE)

  options(DARApipeline.configdir = "config")
  options(DARApipeline.logsdir = "logs")
  options(DARApipeline.skiplogging = FALSE)

}
