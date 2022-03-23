#' references database documentation
#'
#' @format The references database is a list that contains the
#' following 1 datasets: DESTA_REF.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{DESTA_REF: }{A dataset with 1000 observations and the following
#' 3 variables: manyID1, RefType, manyID2.}
#' }

#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(references, skimr::skim_without_charts)
#' ```
"references"
