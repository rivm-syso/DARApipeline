logger::log_info("=== Prepare step 'datasource-caesar' ===")

source(test_path("fixtures", "scripts", "00_prepare", "load_packages.R"))
source(test_path("fixtures", "scripts", "00_prepare", "set_log.R"))

source(test_path("fixtures", "scripts", "00_prepare", "load_functions.R"))
source(test_path("fixtures", "scripts", "00_prepare", "set_options.R"))
pipeline_init()

source(test_path("fixtures", "scripts", "00_prepare", "make_variables.R"))

logger::log_info("=== Prepare step done! ===")
