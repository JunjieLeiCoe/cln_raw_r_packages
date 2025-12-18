#' Log Info Message
#'
#' @description
#' Prints an informational message with [ INFO ] prefix in green color.
#'
#' @param ... Message components to be concatenated and printed.
#'
#' @return Invisibly returns NULL.
#'
#' @examples
#' log_info("Analysis started")
#' log_info("Processing file:", "data.csv")
#'
#' @export
log_info <- function(...) {
    # check_auth()  # DISABLED
    message <- paste(..., collapse = " ")
    cat("\033[32m[ INFO ]\033[0m", message, "\n")
    invisible(NULL)
}


#' Log Warning Message
#'
#' @description
#' Prints a warning message with [ WARNING ] prefix in yellow color.
#'
#' @param ... Message components to be concatenated and printed.
#'
#' @return Invisibly returns NULL.
#'
#' @examples
#' log_warning("Missing values detected")
#'
#' @export
log_warning <- function(...) {
    # check_auth()  # DISABLED
    message <- paste(..., collapse = " ")
    cat("\033[33m[ WARNING ]\033[0m", message, "\n")
    invisible(NULL)
}


#' Log Error Message
#'
#' @description
#' Prints an error message with [ ERROR ] prefix in red color.
#'
#' @param ... Message components to be concatenated and printed.
#'
#' @return Invisibly returns NULL.
#'
#' @examples
#' log_error("File not found")
#'
#' @export
log_error <- function(...) {
    # check_auth()  # DISABLED
    message <- paste(..., collapse = " ")
    cat("\033[31m[ ERROR ]\033[0m", message, "\n")
    invisible(NULL)
}

