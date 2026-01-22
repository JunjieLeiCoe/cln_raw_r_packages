# Example 10: Enhanced Logging Showcase
# This script demonstrates all the beautiful colored logging functions

suppressPackageStartupMessages(library(jleiutils))

log_header("Enhanced Logging Functions Showcase")

# 1. INFO - Bright Cyan (for informational messages)
log_info("Payroll data combined. Total rows: 22780")
log_info("Extracted and matched company names from source files")
log_info("Unique company names: 19")
log_info("Reading file 58/66: ./data/2025/Payroll Summaries/file.xlsx")

cat("\n")

# 2. OK/SUCCESS - Bright Green (for successful operations)
log_ok("Rows added: 285")
log_ok("w2_all: Cleaned names and created 2214 join keys")
log_ok("cen_sel: Cleaned names and created 8020 join keys")
log_ok("pay_sel: Cleaned names and created 22132 join keys")

# Alias: log_success() works the same as log_ok()
log_success("File written successfully!")

cat("\n")

# 3. WARNING - Bright Yellow (for warnings and alerts)
log_warning("Missing values detected in dataset")
log_warning("Missing SSN count: 253")
log_warning("Unique names with missing SSN: 8")

cat("\n")

# 4. ERROR - Bright Red (for errors and failures)
log_error("File not found")
log_error("Failed to read: data.csv")
log_error("GitHub repository not accessible")

cat("\n")

# Realistic workflow example
log_header("Realistic Data Processing Workflow")

log_info("Starting data processing pipeline...")

# Simulate reading files
for (i in 1:3) {
    log_info(paste0("Reading file ", i, "/3: data_", i, ".xlsx"))
    Sys.sleep(0.1)  # Simulate processing
    log_ok(paste0("Rows added: ", sample(200:500, 1)))
}

log_info("")
log_info("Creating standardized join keys for all dataframes...")
log_ok("w2_all: Cleaned names and created 2214 join keys")
log_ok("cen_sel: Cleaned names and created 8020 join keys")
log_ok("pay_sel: Cleaned names and created 22132 join keys")

log_info("")
log_info("Join key creation complete!")
log_info("You can now join the dataframes using 'join_key' column")

# Check for issues
if (sample(c(TRUE, FALSE), 1)) {
    log_warning("Some records have missing SSN values")
    log_warning("Missing SSN count: 253")
} else {
    log_ok("All records have valid SSN values")
}

log_info("")
log_success("Data processing pipeline completed successfully!")

cat("\n=== Color Support Status ===\n")
log_ok("ANSI colors are supported in your terminal")

log_header("Available Functions")
cat("  log_header()  - Bright magenta - Section banners\n")
cat("  log_info()    - Bright cyan    - Informational messages\n")
cat("  log_ok()      - Bright green   - Success messages\n")
cat("  log_success() - Bright green   - Alias for log_ok()\n")
cat("  log_warning() - Bright yellow  - Warning messages\n")
cat("  log_error()   - Bright red     - Error messages\n\n")

log_info("Logging showcase complete!")


