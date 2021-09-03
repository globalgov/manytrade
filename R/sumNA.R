#' Sums the number of NAs across the columns for each row in the dataset
#'
#' @param data name of dataset
#' @param row compute sums on the data frame by row
#' @param sumcol creates a new column with the sum of 'NA's for each row
#'
#' @return creates a new column with the sum of 'NA's for each row
#' @export
sumNA <- function(row,sumcol) {
  data <- get()
  #count by rows
  row <- rowwise()
  #sum across columns
  sumcol <- mutate(NA_per_row = sum(is.na(.)))
}

#' @examples