# Example 6: Check Authorization Status
# This script shows how to verify your authorization setup

suppressPackageStartupMessages(library(jleiutils))

# Display current user information and authorization status
show_user_info()

# If you're not authorized yet, run this to see setup instructions:
# setup_auth()

# Once authorized, try using a function:
log_info("Authorization check passed!")
log_info("You are authorized to use this package")

