# Test log_header function
suppressPackageStartupMessages(library(jleiutils))

log_header("Data Loading Stage")
log_info("Loading file 1...")
log_ok("File loaded successfully")

log_header("Processing Stage")
log_info("Cleaning data...")
log_warning("Found 5 missing values")
log_ok("Processing complete")

log_header("Final Output")
log_info("Writing results...")
log_ok("Done!")
