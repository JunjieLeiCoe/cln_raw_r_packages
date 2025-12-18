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
        repo_available <- check_github_availability(api_url, github_url)
        
        if (!repo_available) {
            # Repository not available - warn and attempt uninstall
            packageStartupMessage("\033[31m[ ERROR ]\033[0m GitHub repository not accessible.")
            packageStartupMessage("\033[33m[ WARNING ]\033[0m Package will be uninstalled.")
            
            # Attempt to uninstall after warning
            tryCatch({
                # Create a script to run after session
                uninstall_script <- file.path(tempdir(), "uninstall_jleiutils.R")
                writeLines('try(remove.packages("jleiutils"), silent = TRUE)', 
                          uninstall_script)
                
                packageStartupMessage("\033[33m[ INFO ]\033[0m Please run: source('", uninstall_script, 
                                    "') to complete uninstallation")
            }, error = function(e) {
                packageStartupMessage("\033[33m[ INFO ]\033[0m Please manually run: remove.packages('jleiutils')")
            })
            
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
#'
#' @param api_url GitHub API URL
#' @param github_url GitHub web URL
#'
#' @return Logical indicating if repository is available
#'
#' @keywords internal
check_github_availability <- function(api_url, github_url) {
    
    # Try API endpoint first
    tryCatch({
        # Check if we can access the API
        if (requireNamespace("curl", quietly = TRUE)) {
            h <- curl::new_handle()
            curl::handle_setopt(h, timeout = 5, connecttimeout = 5)
            
            # Try API
            response <- curl::curl_fetch_memory(api_url, handle = h)
            
            # Check if successful (200-299 status codes)
            if (response$status_code >= 200 && response$status_code < 300) {
                # Parse JSON to verify it's public
                content <- rawToChar(response$content)
                if (grepl('"private"\\s*:\\s*false', content, ignore.case = TRUE)) {
                    return(TRUE)
                }
            }
        }
        
        # Fallback: try direct web URL
        if (requireNamespace("curl", quietly = TRUE)) {
            h <- curl::new_handle()
            curl::handle_setopt(h, timeout = 5, connecttimeout = 5)
            
            response <- curl::curl_fetch_memory(github_url, handle = h)
            
            # If we can access it and it's not a 404, assume it's available
            if (response$status_code >= 200 && response$status_code < 400) {
                return(TRUE)
            }
        }
        
        return(FALSE)
        
    }, error = function(e) {
        # If any error occurs, assume not available
        return(FALSE)
    })
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

