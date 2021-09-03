#' Sums the number of NAs across the columns for each row in the dataset
#'
#' @param data name of dataset
#'
#' @return creates a new column with the sum of 'NA's for each row
#' @export
sumNA <- function(data) {
  data <- mutate(sum.na = rowwise(is.na(.)))
}

#' @examples