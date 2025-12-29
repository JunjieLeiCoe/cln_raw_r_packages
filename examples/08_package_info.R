# Example 8: Package Information and Loaded Packages
# This script demonstrates how to view loaded packages and session info

suppressPackageStartupMessages(library(jleiutils))

# Note: When you loaded jleiutils above, it automatically showed all loaded packages!

cat("\n=== Package Information Functions ===\n\n")

# 1. Show all currently loaded packages (simple view)
cat("1. Simple list of loaded packages:\n")
show_loaded_packages()

# 2. Show loaded packages with version details
cat("2. Detailed view with versions:\n")
show_loaded_packages(detailed = TRUE)

# 3. Show comprehensive session information
cat("3. Full session information:\n")
show_session_info()

# 4. Check current package version
cat("4. Check package version:\n")
check_package_version()

# 5. Check package version against GitHub
cat("5. Check package version vs GitHub:\n")
check_package_version(check_github = TRUE)

# These functions are useful for:
# - Debugging package conflicts
# - Documenting your environment
# - Including in reports for reproducibility
# - Troubleshooting issues

log_info("Package information check complete!")



