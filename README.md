# jleiutils - Personal R Utility Package

A collection of utility functions for personal data science work in R. This package streamlines common tasks like environment setup, logging, and file naming conventions.

## Installation

```r
# Install from GitHub
devtools::install_github("JunjieLeiCoe/cln_raw_r_packages")

# Or install locally
devtools::install()
```

## Features

### 1. Environment Setup (`setup_environment`)

Automatically clears workspace and sets working directory to script location. Works in both RStudio and command line environments.

```r
library(jleiutils)

# Full setup: clear environment + set working directory
setup_environment()

# Only clear environment
setup_environment(set_wd = FALSE)

# Only set working directory
setup_environment(clear_env = FALSE)
```

**Replaces this common pattern:**
```r
rm(list = ls())
if (rstudioapi::isAvailable()) {
    setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
} else {
    script_path <- commandArgs(trailingOnly = FALSE)
    script_path <- script_path[grep("--file=", script_path)]
    if (length(script_path) > 0) {
        script_path <- sub("--file=", "", script_path)
        setwd(dirname(script_path))
    }
}
```

### 2. Clean Logging (`log_info`, `log_ok`, `log_warning`, `log_error`)

Formatted logging with beautiful color-coded output and standardized prefixes.

```r
log_info("Payroll data combined. Total rows: 22780")
# [ INFO ] Payroll data combined. Total rows: 22780 (bright cyan)

log_ok("Rows added: 285")
# [ OK ] Rows added: 285 (bright green)

log_ok("w2_all: Cleaned names and created 2214 join keys")
# [ OK ] w2_all: Cleaned names and created 2214 join keys (bright green)

log_warning("Missing SSN count: 253")
# [ WARNING ] Missing SSN count: 253 (bright yellow)

log_error("File not found")
# [ ERROR ] File not found (bright red)

# Alias for log_ok
log_success("Operation completed!")
# [ OK ] Operation completed! (bright green)
```

### 3. Suppress Package Messages (`suppress_package_messages`)

Load packages without startup messages for cleaner script output.

```r
# Instead of multiple library() calls with messages
suppress_package_messages("dplyr", "ggplot2", "readr")
```

### 4. Standardized Filename Generation (`generate_filename`)

Creates filenames following the convention: `basename_company_NNNNrows_YYYY-MM-DD_JLei.xlsx`

```r
# Generate filename with metadata
filename <- generate_filename(
    base_name = "sales_report",
    company_name = "ACME",
    nrows = 1500
)
# Returns: "sales_report_ACME_1500rows_2025-12-18_JLei.xlsx"
```

### 5. Package Information Functions

View loaded packages and session information:

```r
# Show all loaded packages (displayed automatically on load)
show_loaded_packages()

# Show with version details
show_loaded_packages(detailed = TRUE)

# Full session information
show_session_info()

# Check package version
check_package_version()

# Check against GitHub for updates
check_package_version(check_github = TRUE)
```

## GitHub Auto-Check & Update

This package automatically checks GitHub availability and updates itself every time you load it:

- ✅ **Auto-verifies** the GitHub repo is public and accessible
- 🔄 **Auto-updates** when newer versions are available
- ❌ **Auto-uninstalls** if repository returns 404 (not found)
- 🔒 **Auto-uninstalls** if repository becomes PRIVATE
- ⚠️ **Auto-uninstalls** if repository is inaccessible

**Protection:** Ensures the package only works when https://github.com/JunjieLeiCoe/cln_raw_r_packages is publicly available.

See **GITHUB_CHECK.md** for details.

## Authorization (Currently Disabled)

Authorization functions are included but disabled. See **AUTHORIZATION_SETUP.md** if you want to enable them.

## Quick Start

```r
# Load package
suppressPackageStartupMessages(library(jleiutils))

# Setup environment
setup_environment()

# Load dependencies silently
suppress_package_messages("dplyr", "ggplot2")

# Your analysis here
log_info("Starting analysis...")
data <- mtcars

# Generate output filename
output_file <- generate_filename("analysis", "MyCompany", nrow(data))
log_info("Output:", output_file)
```

## Examples

See the `examples/` folder for detailed usage examples:

- `01_basic_setup.R` - Basic environment setup
- `02_logging_examples.R` - Logging functions
- `03_package_loading.R` - Silent package loading
- `04_filename_generation.R` - Filename generation
- `05_complete_workflow.R` - Complete workflow example
- `06_check_authorization.R` - Check authorization status
- `07_test_github_check.R` - Test GitHub availability check
- `08_package_info.R` - View loaded packages and session info
- `09_test_uninstall_scenario.R` - Understand auto-uninstall behavior
- `10_logging_showcase.R` - Beautiful colored logging demonstration

## Package Structure

```
cln_raw_r_packages/
├── R/
│   ├── environment.R    # Environment setup functions
│   ├── logging.R        # Logging utilities
│   └── utils.R          # Helper functions
├── examples/            # Usage examples
├── DESCRIPTION          # Package metadata
├── NAMESPACE            # Exported functions
└── README.md           # This file
```

## Functions

| Function | Description |
|----------|-------------|
| `setup_environment()` | Clear workspace and set working directory |
| `log_info()` | Print informational message with [ INFO ] prefix (bright cyan) |
| `log_ok()` | Print success message with [ OK ] prefix (bright green) |
| `log_success()` | Alias for log_ok() - success messages (bright green) |
| `log_warning()` | Print warning message with [ WARNING ] prefix (bright yellow) |
| `log_error()` | Print error message with [ ERROR ] prefix (bright red) |
| `suppress_package_messages()` | Load packages without startup messages |
| `generate_filename()` | Create standardized filename with metadata |
| `show_user_info()` | Display current user and authorization status |
| `setup_auth()` | Show instructions for setting up authorization |
| `show_loaded_packages()` | Display all currently loaded packages |
| `show_session_info()` | Display comprehensive session information |
| `check_package_version()` | Check current package version (optionally vs GitHub) |

## Requirements

- R >= 3.5.0
- rstudioapi package (for RStudio integration)
- curl package (for GitHub checks)
- devtools package (for auto-updates, optional)

## License

MIT License - See LICENSE file for details

## Author

JLei - 2025

