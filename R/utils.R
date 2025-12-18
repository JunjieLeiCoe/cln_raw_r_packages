#' Suppress Package Loading Messages
#'
#' @description
#' A wrapper function that loads packages while suppressing startup messages
#' and warnings. Useful for cleaner script output.
#'
#' @param ... Package names as character strings or unquoted names.
#'
#' @return Invisibly returns a logical vector indicating success for each package.
#'
#' @examples
#' \dontrun{
#' # Load packages silently
#' suppress_package_messages("dplyr", "ggplot2")
#'
#' # Alternative syntax
#' suppress_package_messages(dplyr, ggplot2)
#' }
#'
#' @export
suppress_package_messages <- function(...) {
    # check_auth()  # DISABLED
    packages <- as.character(substitute(list(...)))[-1]
    
    results <- sapply(packages, function(pkg) {
        suppressPackageStartupMessages(
            suppressWarnings(
                suppressMessages(
                    require(pkg, character.only = TRUE, quietly = TRUE)
                )
            )
        )
    })
    
    # Log any failed package loads
    failed <- names(results)[!results]
    if (length(failed) > 0) {
        log_warning(paste("Failed to load package(s):", paste(failed, collapse = ", ")))
    }
    
    invisible(results)
}


#' Generate Output Filename
#'
#' @description
#' Generates a standardized filename with company name, row count, date, and JLei suffix.
#'
#' @param base_name Base name for the file (without extension).
#' @param company_name Company name to include in filename.
#' @param nrows Number of rows in the dataframe.
#' @param extension File extension (default is "xlsx").
#' @param date Date to include (default is today's date in YYYY-MM-DD format).
#'
#' @return Character string with formatted filename.
#'
#' @examples
#' generate_filename("sales_report", "ACME", 1500)
#' # Returns: "sales_report_ACME_1500rows_2025-12-18_JLei.xlsx"
#'
#' @export
generate_filename <- function(base_name, company_name, nrows, 
                              extension = "xlsx", 
                              date = format(Sys.Date(), "%Y-%m-%d")) {
    # check_auth()  # DISABLED
    filename <- paste0(base_name, "_", company_name, "_", 
                      nrows, "rows_", date, "_JLei.", extension)
    return(filename)
}

