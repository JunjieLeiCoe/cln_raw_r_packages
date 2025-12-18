#' Setup Environment
#'
#' @description
#' Sets up the R environment by clearing workspace and setting working directory
#' to the current script location. Handles both RStudio and command line environments.
#'
#' @param clear_env Logical. If TRUE, clears all objects from workspace using rm(list = ls()).
#'        Default is TRUE.
#' @param set_wd Logical. If TRUE, sets working directory to script location.
#'        Default is TRUE.
#' @param verbose Logical. If TRUE, prints informational messages. Default is TRUE.
#'
#' @return Invisibly returns the working directory path.
#'
#' @examples
#' \dontrun{
#' # Clear environment and set working directory
#' setup_environment()
#'
#' # Only clear environment, don't change working directory
#' setup_environment(set_wd = FALSE)
#'
#' # Set working directory without clearing environment
#' setup_environment(clear_env = FALSE)
#' }
#'
#' @export
setup_environment <- function(clear_env = TRUE, set_wd = TRUE, verbose = TRUE) {
    
    # Clear environment
    if (clear_env) {
        rm(list = ls(envir = parent.frame()), envir = parent.frame())
        if (verbose) {
            log_info("Workspace cleared")
        }
    }
    
    # Set working directory to current script location
    if (set_wd) {
        wd_set <- FALSE
        
        # Try RStudio API first
        if (rstudioapi::isAvailable()) {
            tryCatch({
                script_path <- rstudioapi::getActiveDocumentContext()$path
                if (nzchar(script_path)) {
                    setwd(dirname(script_path))
                    wd_set <- TRUE
                }
            }, error = function(e) {
                if (verbose) {
                    log_warning("Could not get RStudio document path")
                }
            })
        }
        
        # If RStudio method failed, try command line method
        if (!wd_set) {
            script_path <- commandArgs(trailingOnly = FALSE)
            script_path <- script_path[grep("--file=", script_path)]
            if (length(script_path) > 0) {
                script_path <- sub("--file=", "", script_path)
                setwd(dirname(script_path))
                wd_set <- TRUE
            }
        }
        
        if (verbose) {
            if (wd_set) {
                log_info(paste("Working directory set to:", getwd()))
            } else {
                log_warning(paste("Could not detect script location. Current working directory:", getwd()))
            }
        }
    }
    
    invisible(getwd())
}

