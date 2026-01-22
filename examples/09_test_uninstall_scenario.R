# Example 9: Testing Uninstall Scenarios
# This script shows what happens when GitHub repo is unavailable

# NOTE: This is for DOCUMENTATION purposes only
# The actual checks happen automatically when you load the package

# ===============================================
# SCENARIO 1: Repository Returns 404 (Not Found)
# ===============================================
# What you'll see:
# [ ERROR ] GitHub repository not found (404).
# [ WARNING ] Uninstalling package from your system...
# [ INFO ] Uninstall script created at: /tmp/uninstall_jleiutils.R
# [ INFO ] Package will be removed after you close this session.

# ===============================================
# SCENARIO 2: Repository is PRIVATE
# ===============================================
# What you'll see:
# [ ERROR ] GitHub repository is PRIVATE.
# [ WARNING ] Uninstalling package from your system...
# [ INFO ] Uninstall script created at: /tmp/uninstall_jleiutils.R
# [ INFO ] Package will be removed after you close this session.

# ===============================================
# SCENARIO 3: Normal Load (Repository is PUBLIC)
# ===============================================
# What you'll see:
library(jleiutils)
# [ INFO ] jleiutils package loaded successfully
# [ INFO ] Loaded packages (N):
#   base, compiler, ...

log_info("Package loaded successfully - GitHub repo is public and accessible")

# ===============================================
# HOW THE CHECK WORKS
# ===============================================
# Every time you run: library(jleiutils)
# 
# The package automatically:
# 1. Checks: https://github.com/JunjieLeiCoe/cln_raw_r_packages
# 2. Via API: https://api.github.com/repos/JunjieLeiCoe/cln_raw_r_packages
# 3. Detects status:
#    - 200 + "private": false  → Package loads ✅
#    - 200 + "private": true   → Package uninstalls ❌
#    - 404                     → Package uninstalls ❌
#    - Other errors            → Package uninstalls ❌

# ===============================================
# MANUAL UNINSTALL (if needed)
# ===============================================
manual_uninstall <- function() {
    if ("jleiutils" %in% rownames(installed.packages())) {
        remove.packages("jleiutils")
        cat("\n[ INFO ] jleiutils has been uninstalled manually\n\n")
    } else {
        cat("\n[ INFO ] jleiutils is not installed\n\n")
    }
}

# To uninstall manually, uncomment:
# manual_uninstall()

log_info("Test script complete")



