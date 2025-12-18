# Example 1: Basic Environment Setup
# This script demonstrates the basic usage of jleiutils package

# Load the package (suppress messages)
suppressPackageStartupMessages(library(jleiutils))

# Setup environment: clear workspace and set working directory
setup_environment()

# The above is equivalent to your preferred code:
# rm(list = ls())
# + automatic working directory detection and setting

# Now you can proceed with your analysis
log_info("Environment is ready for analysis")
log_info("Current working directory:", getwd())

