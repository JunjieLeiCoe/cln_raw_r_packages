# Example 5: Complete Data Analysis Workflow
# This script shows a complete workflow using all jleiutils functions

# Load package silently
suppressPackageStartupMessages(library(jleiutils))

# 1. Setup environment
log_info("=== Starting Analysis Workflow ===")
setup_environment()

# 2. Load required packages
log_info("Loading dependencies...")
suppress_package_messages("dplyr", "tidyr")

# 3. Load data (example with mtcars)
log_info("Loading dataset...")
data <- mtcars
log_info("Dataset loaded -", nrow(data), "rows,", ncol(data), "columns")

# 4. Data processing
log_info("Processing data...")
processed_data <- data %>%
    mutate(efficiency = mpg / wt)

if (any(is.na(processed_data))) {
    log_warning("Missing values detected after processing")
} else {
    log_info("Data processing completed successfully")
}

# 5. Generate output filename
company <- "MotorCo"
output_file <- generate_filename(
    base_name = "vehicle_analysis",
    company_name = company,
    nrows = nrow(processed_data)
)

log_info("Output file:", output_file)

# 6. Save results (commented out - uncomment when ready to save)
# library(writexl)
# write_xlsx(processed_data, output_file)
# log_info("Data exported successfully to", output_file)

log_info("=== Workflow Complete ===")



