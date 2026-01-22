# Example 4: Generate Standardized Filenames
# This script demonstrates automatic filename generation with your preferred format

suppressPackageStartupMessages(library(jleiutils))

setup_environment()

# Create sample data
sales_data <- data.frame(
    date = seq.Date(as.Date("2025-01-01"), as.Date("2025-12-31"), by = "day"),
    sales = runif(365, 1000, 5000),
    region = sample(c("North", "South", "East", "West"), 365, replace = TRUE)
)

log_info("Sample data created with", nrow(sales_data), "rows")

# Generate filename following your preferred format:
# basename_companyname_NNNNrows_YYYY-MM-DD_JLei.xlsx
filename <- generate_filename(
    base_name = "sales_report",
    company_name = "ACME",
    nrows = nrow(sales_data)
)

log_info("Output filename:", filename)
# Example output: sales_report_ACME_365rows_2025-12-18_JLei.xlsx

# You can now save the file
# writexl::write_xlsx(sales_data, filename)
log_info("Ready to export to:", filename)



