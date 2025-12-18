# Example 3: Clean Package Loading
# This script shows how to load packages without startup messages

suppressPackageStartupMessages(library(jleiutils))

# Setup environment first
setup_environment()

# Load required packages silently
log_info("Loading required packages...")
suppress_package_messages("dplyr", "ggplot2", "readr")

# Alternative: you can also use unquoted package names
# suppress_package_messages(dplyr, ggplot2, readr)

log_info("All packages loaded successfully")

# Now your script runs clean without package startup messages

