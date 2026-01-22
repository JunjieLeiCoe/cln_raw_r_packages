#' Show Loaded Packages
#'
#' @description
#' Displays all currently loaded packages in a clean, organized format.
#'
#' @param detailed Logical. If TRUE, shows additional details like versions.
#'        Default is FALSE.
#'
#' @return Invisibly returns a character vector of loaded package names.
#'
#' @examples
#' \dontrun{
#' # Show all loaded packages
#' show_loaded_packages()
#'
#' # Show with version details
#' show_loaded_packages(detailed = TRUE)
#' }
#'
#' @export
show_loaded_packages <- function(detailed = FALSE) {
    
    # Get all loaded packages
    loaded_pkgs <- loadedNamespaces()
    
    # Sort alphabetically
    loaded_pkgs <- sort(loaded_pkgs)
    
    # Count
    n_packages <- length(loaded_pkgs)
    
    cat("\n")
    log_info(paste("=== Loaded Packages (", n_packages, ") ===", sep = ""))
    cat("\n")
    
    if (detailed) {
        # Show with versions
        for (pkg in loaded_pkgs) {
            tryCatch({
                version <- as.character(packageVersion(pkg))
                cat(sprintf("  %-25s %s\n", pkg, version))
            }, error = function(e) {
                cat(sprintf("  %-25s %s\n", pkg, "version unknown"))
            })
        }
    } else {
        # Simple list, 5 per line
        pkg_groups <- split(loaded_pkgs, ceiling(seq_along(loaded_pkgs) / 5))
        
        for (group in pkg_groups) {
            cat("  ", paste(group, collapse = ", "), "\n")
        }
    }
    
    cat("\n")
    
    invisible(loaded_pkgs)
}


#' Show Package Session Info
#'
#' @description
#' Displays comprehensive session information including R version,
#' platform, loaded packages with versions, and system details.
#'
#' @return Invisibly returns the sessionInfo() object.
#'
#' @examples
#' \dontrun{
#' show_session_info()
#' }
#'
#' @export
show_session_info <- function() {
    
    cat("\n")
    log_info("=== Session Information ===")
    cat("\n")
    
    # Get session info
    si <- sessionInfo()
    
    # R version
    cat("R version:    ", si$R.version$version.string, "\n")
    cat("Platform:     ", si$platform, "\n")
    cat("Running under:", si$running, "\n")
    cat("\n")
    
    # Base packages
    if (length(si$basePkgs) > 0) {
        log_info(paste("Base packages (", length(si$basePkgs), "):", sep = ""))
        base_groups <- split(si$basePkgs, ceiling(seq_along(si$basePkgs) / 5))
        for (group in base_groups) {
            cat("  ", paste(group, collapse = ", "), "\n")
        }
        cat("\n")
    }
    
    # Attached packages
    if (length(si$otherPkgs) > 0) {
        log_info(paste("Attached packages (", length(si$otherPkgs), "):", sep = ""))
        for (pkg_name in names(si$otherPkgs)) {
            pkg_info <- si$otherPkgs[[pkg_name]]
            cat(sprintf("  %-20s %s\n", pkg_name, pkg_info$Version))
        }
        cat("\n")
    }
    
    # Loaded via namespace
    if (length(si$loadedOnly) > 0) {
        log_info(paste("Loaded via namespace (", length(si$loadedOnly), "):", sep = ""))
        loaded_names <- names(si$loadedOnly)
        loaded_groups <- split(loaded_names, ceiling(seq_along(loaded_names) / 5))
        for (group in loaded_groups) {
            cat("  ", paste(group, collapse = ", "), "\n")
        }
        cat("\n")
    }
    
    invisible(si)
}


#' Check Package Version
#'
#' @description
#' Checks and displays the current version of jleiutils package.
#'
#' @param check_github Logical. If TRUE, also checks GitHub for latest version.
#'        Default is FALSE.
#'
#' @return Invisibly returns the current version as a package_version object.
#'
#' @examples
#' \dontrun{
#' # Show current version
#' check_package_version()
#'
#' # Check against GitHub
#' check_package_version(check_github = TRUE)
#' }
#'
#' @export
check_package_version <- function(check_github = FALSE) {
    
    current_version <- packageVersion("jleiutils")
    
    cat("\n")
    log_info(paste("Current jleiutils version:", as.character(current_version)))
    
    if (check_github) {
        log_info("Checking GitHub for latest version...")
        
        tryCatch({
            if (requireNamespace("curl", quietly = TRUE)) {
                desc_url <- "https://raw.githubusercontent.com/JunjieLeiCoe/cln_raw_r_packages/master/DESCRIPTION"
                
                h <- curl::new_handle()
                curl::handle_setopt(h, timeout = 5, connecttimeout = 5)
                
                response <- curl::curl_fetch_memory(desc_url, handle = h)
                
                if (response$status_code == 200) {
                    desc_content <- rawToChar(response$content)
                    version_match <- regmatches(desc_content, 
                                              regexpr("Version:\\s*[0-9.]+", desc_content))
                    
                    if (length(version_match) > 0) {
                        remote_version <- sub("Version:\\s*", "", version_match[1])
                        remote_version <- package_version(remote_version)
                        
                        log_info(paste("GitHub version:", as.character(remote_version)))
                        
                        if (remote_version > current_version) {
                            log_warning("A newer version is available on GitHub!")
                            log_info("Run: devtools::install_github('JunjieLeiCoe/cln_raw_r_packages')")
                        } else if (remote_version == current_version) {
                            log_info("You have the latest version")
                        } else {
                            log_info("You have a development version")
                        }
                    }
                }
            } else {
                log_warning("curl package not available - cannot check GitHub")
            }
        }, error = function(e) {
            log_error("Failed to check GitHub version:", e$message)
        })
    }
    
    cat("\n")
    
    invisible(current_version)
}



