#' Package Load Hook
#'
#' @description
#' Runs when package is loaded. Checks GitHub repository availability and auto-updates.
#'
#' @param libname Library name
#' @param pkgname Package name
#'
#' @keywords internal
.onAttach <- function(libname, pkgname) {
    
    # Suppress all output during checks
    suppressMessages(suppressWarnings({
        
        # GitHub repository details
        github_repo <- "JunjieLeiCoe/cln_raw_r_packages"
        github_url <- paste0("https://github.com/", github_repo)
        api_url <- paste0("https://api.github.com/repos/", github_repo)
        
        # Check if GitHub repo is accessible
        check_result <- check_github_availability(api_url, github_url)
        
        if (!check_result$available) {
            # Repository not available - show reason and uninstall
            if (check_result$status == 404) {
                packageStartupMessage("\033[31m[ ERROR ]\033[0m GitHub repository not found (404).")
            } else if (check_result$is_private) {
                packageStartupMessage("\033[31m[ ERROR ]\033[0m GitHub repository is PRIVATE.")
            } else {
                packageStartupMessage("\033[31m[ ERROR ]\033[0m GitHub repository not accessible.")
            }
            
            packageStartupMessage("\033[33m[ WARNING ]\033[0m Uninstalling package from your system...")
            
            # Automatically uninstall the package
            uninstall_package()
            
            return(invisible(NULL))
        }
        
        # Repository is available - check for updates
        check_and_update_package(github_repo)
        
    }))
    
    # Display startup message
    packageStartupMessage("\033[32m[ INFO ]\033[0m jleiutils package loaded successfully")
    
    # Show loaded packages
    show_loaded_packages_on_startup()
    
    invisible(NULL)
}


#' Show Loaded Packages on Startup
#'
#' @description
#' Displays all currently loaded packages when jleiutils is loaded.
#'
#' @return Invisible NULL
#'
#' @keywords internal
show_loaded_packages_on_startup <- function() {
    
    tryCatch({
        # Get all loaded packages
        loaded_pkgs <- loadedNamespaces()
        
        # Sort alphabetically
        loaded_pkgs <- sort(loaded_pkgs)
        
        # Count
        n_packages <- length(loaded_pkgs)
        
        # Display header
        packageStartupMessage("\033[32m[ INFO ]\033[0m Loaded packages (", n_packages, "):")
        
        # Group packages for cleaner display (5 per line)
        pkg_groups <- split(loaded_pkgs, ceiling(seq_along(loaded_pkgs) / 5))
        
        for (group in pkg_groups) {
            packageStartupMessage("  ", paste(group, collapse = ", "))
        }
        
    }, error = function(e) {
        # Silently fail if can't show packages
        invisible(NULL)
    })
    
    invisible(NULL)
}


#' Check GitHub Repository Availability
#'
#' @description
#' Checks if the GitHub repository is publicly accessible.
#' Specifically detects 404 errors and private repositories.
#'
#' @param api_url GitHub API URL
#' @param github_url GitHub web URL
#'
#' @return List with availability status, HTTP status code, and private flag
#'
#' @keywords internal
check_github_availability <- function(api_url, github_url) {
    
    result <- list(
        available = FALSE,
        status = NA,
        is_private = FALSE
    )
    
    # Try API endpoint first (most reliable)
    tryCatch({
        if (requireNamespace("curl", quietly = TRUE)) {
            h <- curl::new_handle()
            curl::handle_setopt(h, timeout = 5, connecttimeout = 5)
            
            # Try API
            response <- curl::curl_fetch_memory(api_url, handle = h)
            result$status <- response$status_code
            
            # Check status codes
            if (response$status_code == 404) {
                # Repository not found
                result$available <- FALSE
                result$is_private <- FALSE
                return(result)
            }
            
            if (response$status_code >= 200 && response$status_code < 300) {
                # Parse JSON to check if private
                content <- rawToChar(response$content)
                
                # Check if private
                if (grepl('"private"\\s*:\\s*true', content, ignore.case = TRUE)) {
                    result$available <- FALSE
                    result$is_private <- TRUE
                    return(result)
                }
                
                # Check if public
                if (grepl('"private"\\s*:\\s*false', content, ignore.case = TRUE)) {
                    result$available <- TRUE
                    result$is_private <- FALSE
                    return(result)
                }
            }
        }
        
        # Fallback: try direct web URL
        if (requireNamespace("curl", quietly = TRUE)) {
            h <- curl::new_handle()
            curl::handle_setopt(h, timeout = 5, connecttimeout = 5)
            
            response <- curl::curl_fetch_memory(github_url, handle = h)
            result$status <- response$status_code
            
            # 404 = not found
            if (response$status_code == 404) {
                result$available <- FALSE
                result$is_private <- FALSE
                return(result)
            }
            
            # 200-299 = accessible
            if (response$status_code >= 200 && response$status_code < 300) {
                result$available <- TRUE
                result$is_private <- FALSE
                return(result)
            }
            
            # Other errors (403, etc.) - assume private or inaccessible
            result$available <- FALSE
            return(result)
        }
        
        return(result)
        
    }, error = function(e) {
        # If any error occurs, assume not available
        return(result)
    })
}


#' Uninstall Package
#'
#' @description
#' Automatically uninstalls the jleiutils package from the user's system.
#'
#' @return Invisible NULL
#'
#' @keywords internal
uninstall_package <- function() {
    
    tryCatch({
        # Create uninstall script that runs after package detaches
        uninstall_script <- file.path(tempdir(), "uninstall_jleiutils.R")
        
        script_content <- '
# Auto-generated uninstall script for jleiutils
tryCatch({
    if ("jleiutils" %in% rownames(installed.packages())) {
        remove.packages("jleiutils")
        cat("\\n\\033[32m[ INFO ]\\033[0m jleiutils package has been uninstalled.\\n")
        cat("\\033[33m[ INFO ]\\033[0m Reason: GitHub repository is not publicly accessible.\\n\\n")
    }
}, error = function(e) {
    cat("\\n\\033[31m[ ERROR ]\\033[0m Failed to uninstall jleiutils:", e$message, "\\n")
    cat("\\033[33m[ INFO ]\\033[0m Please manually run: remove.packages(\\"jleiutils\\")\\n\\n")
})
'
        
        writeLines(script_content, uninstall_script)
        
        packageStartupMessage("\033[33m[ INFO ]\033[0m Uninstall script created at: ", uninstall_script)
        packageStartupMessage("\033[33m[ INFO ]\033[0m Package will be removed after you close this session.")
        packageStartupMessage("\033[33m[ INFO ]\033[0m Or run now: source('", uninstall_script, "')")
        
        # Try to schedule execution for when R exits
        if (interactive()) {
            # In interactive mode, add to .Last
            on_exit_code <- substitute({
                if (file.exists(script_path)) {
                    source(script_path)
                    unlink(script_path)
                }
            }, list(script_path = uninstall_script))
            
            .Last <<- function() {
                eval(on_exit_code)
            }
        }
        
    }, error = function(e) {
        packageStartupMessage("\033[31m[ ERROR ]\033[0m Failed to create uninstall script")
        packageStartupMessage("\033[33m[ INFO ]\033[0m Please manually run: remove.packages('jleiutils')")
    })
    
    invisible(NULL)
}


#' Check and Update Package
#'
#' @description
#' Checks if a newer version is available on GitHub and updates if needed.
#'
#' @param github_repo GitHub repository in format "username/repo"
#'
#' @return Invisible NULL
#'
#' @keywords internal
check_and_update_package <- function(github_repo) {
    
    tryCatch({
        
        # Check if devtools is available
        if (!requireNamespace("devtools", quietly = TRUE)) {
            # Can't update without devtools
            return(invisible(NULL))
        }
        
        # Get current package version
        current_version <- utils::packageVersion("jleiutils")
        
        # Try to get remote version from DESCRIPTION file
        desc_url <- paste0("https://raw.githubusercontent.com/", 
                          github_repo, "/master/DESCRIPTION")
        
        if (requireNamespace("curl", quietly = TRUE)) {
            h <- curl::new_handle()
            curl::handle_setopt(h, timeout = 5, connecttimeout = 5)
            
            response <- curl::curl_fetch_memory(desc_url, handle = h)
            
            if (response$status_code == 200) {
                desc_content <- rawToChar(response$content)
                
                # Extract version from DESCRIPTION
                version_match <- regmatches(desc_content, 
                                          regexpr("Version:\\s*[0-9.]+", desc_content))
                
                if (length(version_match) > 0) {
                    remote_version <- sub("Version:\\s*", "", version_match[1])
                    remote_version <- package_version(remote_version)
                    
                    # Compare versions
                    if (remote_version > current_version) {
                        packageStartupMessage("\033[33m[ INFO ]\033[0m Updating package from GitHub...")
                        
                        # Update package
                        devtools::install_github(github_repo, 
                                                quiet = TRUE, 
                                                upgrade = "never",
                                                force = TRUE)
                        
                        packageStartupMessage("\033[32m[ INFO ]\033[0m Package updated successfully. Please restart R.")
                    }
                }
            }
        }
        
    }, error = function(e) {
        # Silently fail if update check fails
        invisible(NULL)
    })
    
    invisible(NULL)
}

