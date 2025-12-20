# Example 2: Using Logging Functions
# This script demonstrates the logging utilities

suppressPackageStartupMessages(library(jleiutils))

# Different log levels with colored output
log_info("This is an informational message")
log_warning("This is a warning message")
log_error("This is an error message")

# Use in actual workflow
log_info("Starting data processing...")

# Simulate some work
data <- data.frame(
    x = 1:100,
    y = rnorm(100)
)

log_info("Data loaded successfully - Rows:", nrow(data), "Cols:", ncol(data))

# Check for issues
if (any(is.na(data))) {
    log_warning("Missing values detected in the dataset")
} else {
    log_info("No missing values found")
}

log_info("Processing complete!")


