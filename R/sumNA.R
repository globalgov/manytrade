#' Sum NAs
#' 
#' Sums the number of NAs across the columns for each row in the dataset
#' @param data name of dataset
#' @importFrom purrr map
#' @return A vector with the sum of 'NA's for each row
#' @examples
#' data <- data.frame(a = c("a", NA),
#' b = c(NA, NA))
#' data$missing <- sumNA(data)
#' @export
sumNA <- function(data) {

  if (missing(data)) {
    stop("Please declare a dataset")
  }

  purrr::map(data, ~sum(is.na(.)))
}
