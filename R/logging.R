# ANSI Color Codes for Terminal Output
.colors <- list(
    reset = "\033[0m",
    bold = "\033[1m",
    # Standard text colors
    black = "\033[30m",
    red = "\033[31m",
    green = "\033[32m",
    yellow = "\033[33m",
    blue = "\033[34m",
    magenta = "\033[35m",
    cyan = "\033[36m",
    white = "\033[37m",
    # Bright colors (better visibility)
    bright_red = "\033[91m",
    bright_green = "\033[92m",
    bright_yellow = "\033[93m",
    bright_blue = "\033[94m",
    bright_magenta = "\033[95m",
    bright_cyan = "\033[96m"
)


#' Check Color Support
#'
#' @description
#' Checks if the terminal supports ANSI color codes.
#'
#' @return Logical indicating if colors are supported.
#'
#' @keywords internal
.supports_color <- function() {
    # Check if running in RStudio
    if (Sys.getenv("RSTUDIO") == "1") {
        return(TRUE)
    }
    # Check for Windows terminal (Windows 10+ supports ANSI colors)
    if (.Platform$OS.type == "windows") {
        return(TRUE)
    }
    # Unix-like systems typically support colors
    return(TRUE)
}

.use_color <- .supports_color()


#' Log Header Banner
#'
#' @description
#' Prints a banner-style header to mark different stages of a script.
#' Useful for visually separating sections in terminal output.
#'
#' @param ... Message components to be concatenated and printed.
#' @param width Width of the banner (default 50 characters).
#'
#' @return Invisibly returns NULL.
#'
#' @examples
#' log_header("Data Loading")
#' log_header("Processing Stage 1")
#' log_header("Final Output", width = 60)
#'
#' @export
log_header <- function(..., width = 50) {
    message <- paste(..., collapse = " ")
    border <- paste(rep("=", width), collapse = "")
    
    if (.use_color) {
        cat("\n")
        cat(.colors$bright_magenta, border, .colors$reset, "\n", sep = "")
        cat(.colors$bright_magenta, "+  ", .colors$reset, message, "\n", sep = "")
        cat(.colors$bright_magenta, border, .colors$reset, "\n", sep = "")
        cat("\n")
    } else {
        cat("\n")
        cat(border, "\n", sep = "")
        cat("+  ", message, "\n", sep = "")
        cat(border, "\n", sep = "")
        cat("\n")
    }
    invisible(NULL)
}


#' Log Info Message
#'
#' @description
#' Prints an informational message with [ INFO ] prefix in bright cyan color.
#'
#' @param ... Message components to be concatenated and printed.
#'
#' @return Invisibly returns NULL.
#'
#' @examples
#' log_info("Analysis started")
#' log_info("Processing file:", "data.csv")
#' log_info("Total rows:", 22780)
#'
#' @export
log_info <- function(...) {
    # check_auth()  # DISABLED
    message <- paste(..., collapse = " ")
    if (.use_color) {
        cat(.colors$bright_cyan, "[ INFO ]", .colors$reset, " ", message, "\n", sep = "")
    } else {
        cat("[ INFO ] ", message, "\n", sep = "")
    }
    invisible(NULL)
}


#' Log OK Message
#'
#' @description
#' Prints a success message with [ OK ] prefix in bright green color.
#' Use this for successful operations, completions, and positive confirmations.
#'
#' @param ... Message components to be concatenated and printed.
#'
#' @return Invisibly returns NULL.
#'
#' @examples
#' log_ok("Rows added: 285")
#' log_ok("w2_all: Cleaned names and created 2214 join keys")
#' log_ok("File written successfully")
#'
#' @export
log_ok <- function(...) {
    # check_auth()  # DISABLED
    message <- paste(..., collapse = " ")
    if (.use_color) {
        cat(.colors$bright_green, "[ OK ]", .colors$reset, " ", message, "\n", sep = "")
    } else {
        cat("[ OK ] ", message, "\n", sep = "")
    }
    invisible(NULL)
}


#' Log Warning Message
#'
#' @description
#' Prints a warning message with [ WARNING ] prefix in bright yellow color.
#'
#' @param ... Message components to be concatenated and printed.
#'
#' @return Invisibly returns NULL.
#'
#' @examples
#' log_warning("Missing values detected")
#' log_warning("Missing SSN count:", 253)
#'
#' @export
log_warning <- function(...) {
    # check_auth()  # DISABLED
    message <- paste(..., collapse = " ")
    if (.use_color) {
        cat(.colors$bright_yellow, "[ WARNING ]", .colors$reset, " ", message, "\n", sep = "")
    } else {
        cat("[ WARNING ] ", message, "\n", sep = "")
    }
    invisible(NULL)
}


#' Log Error Message
#'
#' @description
#' Prints an error message with [ ERROR ] prefix in bright red color.
#'
#' @param ... Message components to be concatenated and printed.
#'
#' @return Invisibly returns NULL.
#'
#' @examples
#' log_error("File not found")
#' log_error("Failed to read:", filename)
#'
#' @export
log_error <- function(...) {
    # check_auth()  # DISABLED
    message <- paste(..., collapse = " ")
    if (.use_color) {
        cat(.colors$bright_red, "[ ERROR ]", .colors$reset, " ", message, "\n", sep = "")
    } else {
        cat("[ ERROR ] ", message, "\n", sep = "")
    }
    invisible(NULL)
}


#' Log Success Message (Alias for log_ok)
#'
#' @description
#' Alias for log_ok(). Prints a success message with [ OK ] prefix in bright green.
#'
#' @param ... Message components to be concatenated and printed.
#'
#' @return Invisibly returns NULL.
#'
#' @examples
#' log_success("Operation completed successfully")
#'
#' @export
log_success <- function(...) {
    log_ok(...)
}

