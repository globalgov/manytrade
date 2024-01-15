#' references datacube documentation
#'
#' @format The references datacube is a list that contains the
#' following 1 datasets: DESTA_REF.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{DESTA_REF: }{A dataset with 584 observations and the following
#' 3 variables: treatyID1, treatyID2, RefType.}
#' }
#' @source
#' \itemize{
#' \item{DESTA_REF: }{
#' A. Dür, L. Baccini, and M. Elsig. “The Design of International Trade Agreements: Introducing a NewDatabase”. In: _The Review of International Organizations_ 9.3 (2014), pp. 353-375.}
#' }
#' @section URL:
#' \itemize{
#' \item{DESTA_REF: }{
#' \url{https://www.designoftradeagreements.org/downloads/}
#' }
#' }
#' @section Mapping:
#' \itemize{
#' \item{DESTA_REF: }{
#' Variable Mapping
#' 
#' |  *from*  | *to*
#' |:------------:|:------------:|
#' | entry_type | RefType |
#' 
#' }
#' }
#' @md
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(references, messydates::mreport)
#' ```
"references"
