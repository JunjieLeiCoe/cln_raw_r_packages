# Example 7: Test GitHub Check Feature
# This script demonstrates the GitHub availability check

# When you load the package, it automatically:
# 1. Checks if https://github.com/JunjieLeiCoe/cln_raw_r_packages is public
# 2. Auto-updates if newer version available
# 3. Uninstalls itself if repo is not available

# Load package (this triggers the check)
suppressPackageStartupMessages(library(jleiutils))

# If you see this message, the GitHub check passed:
log_info("GitHub check passed - repository is accessible")

# Check current version
log_info("Current package version:", as.character(packageVersion("jleiutils")))

# The package will automatically update if a newer version is on GitHub
# and will prompt you to restart R

# Manual check of GitHub availability (if needed)
test_github_access <- function() {
    url <- "https://api.github.com/repos/JunjieLeiCoe/cln_raw_r_packages"
    
    tryCatch({
        if (requireNamespace("curl", quietly = TRUE)) {
            response <- curl::curl_fetch_memory(url)
            
            if (response$status_code == 200) {
                log_info("GitHub repository is PUBLIC and accessible")
                return(TRUE)
            } else {
                log_error("GitHub repository returned status:", response$status_code)
                return(FALSE)
            }
        }
    }, error = function(e) {
        log_error("Failed to check GitHub:", e$message)
        return(FALSE)
    })
}

# Run manual check
test_github_access()



