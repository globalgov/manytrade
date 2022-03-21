#' memberships database documentation
#'
#' @format The memberships database is a list that contains the
#' following 2 datasets: GPTAD_MEM, DESTA_MEM.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{GPTAD_MEM: }{A dataset with 2201 observations and the following
#' 9 variables: manyID, CountryID, Title, Beg, Signature, Force, CountryName, gptadID, treatyID.}
#' \item{DESTA_MEM: }{A dataset with 7492 observations and the following
#' 9 variables: manyID, CountryID, Title, Beg, Signature, Force, CountryName, destaID, treatyID.}
#' }

#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(memberships, skimr::skim_without_charts)
#' ```
"memberships"
