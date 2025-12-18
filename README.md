# jleiutils - Personal R Utility Package

A collection of utility functions for personal data science work in R. This package streamlines common tasks like environment setup, logging, and file naming conventions.

## Installation

```r
# Install from GitHub
devtools::install_github("yourusername/cln_raw_r_packages")

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

### 2. Clean Logging (`log_info`, `log_warning`, `log_error`)

Formatted logging with color-coded output and standardized prefixes.

```r
log_info("Analysis started")
# [ INFO ] Analysis started

log_warning("Missing values detected")
# [ WARNING ] Missing values detected

log_error("File not found")
# [ ERROR ] File not found
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

## Authorization

This package includes authorization protection for personal use only. After installation, verify your access:

```r
library(jleiutils)
show_user_info()  # Check if you're authorized
```

If not authorized, see **AUTHORIZATION_SETUP.md** for setup instructions.

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
| `log_info()` | Print informational message with [ INFO ] prefix |
| `log_warning()` | Print warning message with [ WARNING ] prefix |
| `log_error()` | Print error message with [ ERROR ] prefix |
| `suppress_package_messages()` | Load packages without startup messages |
| `generate_filename()` | Create standardized filename with metadata |
| `show_user_info()` | Display current user and authorization status |
| `setup_auth()` | Show instructions for setting up authorization |

## Requirements

- R >= 3.5.0
- rstudioapi package (for RStudio integration)

## License

MIT License - See LICENSE file for details

## Author

JLei - 2025

