# Example 11: Data Processing Script Template with jleiutils Logging
# This demonstrates how to use jleiutils logging in a real data processing workflow

#Remove Data for new run
rm(list=ls())

## -----------------------------------------------------------------------------------------------------------
## Load Libraries - Suppress loading messages
## -----------------------------------------------------------------------------------------------------------
suppressPackageStartupMessages({
  library(jleiutils)
  library(readxl)
  library(stringr)
  library(dplyr)
  library(openxlsx)
  library(lubridate)
})

## -----------------------------------------------------------------------------------------------------------
## Enhanced Logging Helper Function - Creates beautiful section headers
## -----------------------------------------------------------------------------------------------------------
log_header <- function(msg) {
  cat("\n")
  cat("\033[34m=================================================================\033[0m\n")
  cat("\033[34m", msg, "\033[0m\n")
  cat("\033[34m=================================================================\033[0m\n")
  cat("\n")
}

## -----------------------------------------------------------------------------------------------------------
## Main Processing
## -----------------------------------------------------------------------------------------------------------

log_header("DATA PROCESSING - STARTING")
log_info("Found 66 payroll files")
log_info("Found 19 census files")

log_header("STEP 1: READING PAYROLL FILES")

# Simulate reading files
for(i in 58:66) {
  log_info(paste0("Reading file ", i, "/66: ./data//2025/Payroll Summaries/file_", i, ".xlsx"))
  Sys.sleep(0.1)  # Simulate processing
  log_ok(paste0("Rows added: ", sample(200:600, 1)))
}

log_info("Payroll files processed: 9")
log_info("Payroll files skipped: 0")
log_info("Total payroll records: 22780")

log_header("STEP 2: CALCULATING RATE INFORMATION")
log_ok("Rate information calculated")

log_header("STEP 3: READING CENSUS FILES")

log_info("Reading: census_file_1.csv")
log_info("  Filtered to employees: 150 of 200 rows")
log_info("  Found 11 of 15 required columns")
log_ok("Processed: 150 employee records from census_file_1.csv")

log_info("Census files processed: 1")
log_info("Census files skipped: 0")
log_info("Total census records: 150")

log_header("STEP 4: FORMATTING CENSUS DATA")
log_info("Formatting SSN (adding dashes)")
log_ok("SSN formatted")
log_info("  Selected 11 columns for joining")
log_ok("Census columns prepared for joining")

log_header("STEP 5: ASSIGNING COMPANY NAMES")
log_info("Assigning company names to payroll records")
log_ok("Company names assigned to 22780 of 22780 records")

log_header("STEP 6: JOINING PAYROLL AND CENSUS DATA")
log_info("Removing duplicate Associate IDs from census")
log_info("  Kept 150 unique IDs (removed 0 duplicates)")
log_info("Performing LEFT JOIN: payroll <- census (by Associate ID)")
log_ok("Join completed: 22780 records, 150 matched with census")
log_info("  Columns: from 12 to 23")
log_info("  SSN Status:")
log_info("    Present: 22527 (98.89%)")
log_warning("    Missing: 253 (1.11%)")

log_header("STEP 7: ASSIGNING BENEFIT CLASSES")
log_info("Applying benefit class rules")
log_ok("Benefit classes assigned to 22780 of 22780 records")
log_info("  Unique benefit classes: 18")

log_header("STEP 8: WRITING OUTPUT FILES")
log_info("Writing main output file: CLNRaw_Clasp_Multiple_22780rows_20251219_JLei.xlsx")
log_ok("Main output file created: CLNRaw_Clasp_Multiple_22780rows_20251219_JLei.xlsx")
log_info("  Rows: 22780 | Columns: 24")

log_header("STEP 9: PROCESSING ENROLLMENT & WAIVER DATA")
log_info("Checking for enrollment columns in census data")
log_info("  Found 6 of 6 enrollment columns")
log_info("  Filtered to medical coverage: 120 of 150 records")
log_info("  Removed NA SSN: 115 of 120 records")
log_info("Applying FIORSI classification")
log_info("  FIORSI: FI= 80 , SI= 35")
log_info("Writing enrollment/waiver file: CLNRaw_Clasp_EnrollmentWaiver_115rows_20251219_JLei.xlsx")
log_ok("Enrollment/waiver file created: CLNRaw_Clasp_EnrollmentWaiver_115rows_20251219_JLei.xlsx")
log_info("  Rows: 115 | Columns: 7")

log_header("PROCESSING COMPLETE!")
log_success("All steps completed successfully")
log_info("Final output records: 22780")

cat("\n")

