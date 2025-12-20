#' Validate User Authorization
#'
#' @description
#' Internal function to check if the current user is authorized to use the package.
#' Uses multiple validation methods: username, computer name, and environment variable.
#'
#' @return Logical indicating if user is authorized.
#'
#' @keywords internal
validate_user <- function() {
    # Method 1: Check system username
    authorized_users <- c("jlei", "JLei", "JLEI")
    current_user <- Sys.info()["user"]
    
    # Method 2: Check computer name
    authorized_computers <- c(
        Sys.info()["nodename"]  # Add your current computer name
    )
    current_computer <- Sys.info()["nodename"]
    
    # Method 3: Check for environment variable (most secure)
    # Set this in your .Renviron: JLEI_AUTH_KEY="your_secret_key_here"
    env_key <- Sys.getenv("JLEI_AUTH_KEY", unset = "")
    authorized_key <- "jlei_authorized_2025"  # Change this to your secret
    
    # User is authorized if ANY method passes
    is_authorized <- (
        tolower(current_user) %in% tolower(authorized_users) ||
        current_computer %in% authorized_computers ||
        (nzchar(env_key) && env_key == authorized_key)
    )
    
    return(is_authorized)
}


#' Check Authorization and Stop if Unauthorized
#'
#' @description
#' Internal function that checks authorization and stops execution if unauthorized.
#'
#' @return Invisibly returns TRUE if authorized, stops with error if not.
#'
#' @keywords internal
check_auth <- function() {
    if (!validate_user()) {
        stop(
            "\n[ ERROR ] Unauthorized access detected.\n",
            "This package is for authorized use only.\n",
            "Contact the package maintainer for access.\n",
            call. = FALSE
        )
    }
    invisible(TRUE)
}


#' Display Current User Information
#'
#' @description
#' Shows current system user information for debugging authorization issues.
#'
#' @return Invisibly returns a list with user information.
#'
#' @examples
#' \dontrun{
#' show_user_info()
#' }
#'
#' @export
show_user_info <- function() {
    user_info <- Sys.info()
    
    cat("\n")
    log_info("=== System User Information ===")
    cat("Username:     ", user_info["user"], "\n")
    cat("Computer Name:", user_info["nodename"], "\n")
    cat("System:       ", user_info["sysname"], "\n")
    cat("Release:      ", user_info["release"], "\n")
    
    # Check environment variable
    env_key <- Sys.getenv("JLEI_AUTH_KEY", unset = "")
    if (nzchar(env_key)) {
        cat("Auth Key:      Set (", nchar(env_key), " characters)\n", sep = "")
    } else {
        cat("Auth Key:      Not set\n")
    }
    
    # Check authorization status
    if (validate_user()) {
        log_info("Status: AUTHORIZED")
    } else {
        log_error("Status: NOT AUTHORIZED")
    }
    cat("\n")
    
    invisible(list(
        username = user_info["user"],
        computer = user_info["nodename"],
        system = user_info["sysname"],
        has_env_key = nzchar(env_key),
        is_authorized = validate_user()
    ))
}


#' Setup Authorization Environment Variable
#'
#' @description
#' Helper function to set up the authorization environment variable in .Renviron file.
#'
#' @param secret_key Your secret authorization key. If NULL, uses default.
#'
#' @return Message with setup instructions.
#'
#' @examples
#' \dontrun{
#' setup_auth()
#' }
#'
#' @export
setup_auth <- function(secret_key = NULL) {
    if (is.null(secret_key)) {
        secret_key <- "jlei_authorized_2025"
    }
    
    renviron_path <- file.path(Sys.getenv("HOME"), ".Renviron")
    
    cat("\n")
    log_info("=== Authorization Setup ===")
    cat("\nTo enable authorization, add this line to your .Renviron file:\n\n")
    cat("  JLEI_AUTH_KEY=\"", secret_key, "\"\n\n", sep = "")
    cat("Location: ", renviron_path, "\n\n")
    
    if (file.exists(renviron_path)) {
        log_info(".Renviron file exists")
    } else {
        log_warning(".Renviron file does not exist - you'll need to create it")
    }
    
    cat("\nAfter adding the line:\n")
    cat("1. Save the .Renviron file\n")
    cat("2. Restart R session\n")
    cat("3. Run show_user_info() to verify\n\n")
    
    invisible(secret_key)
}


