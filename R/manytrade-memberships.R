#' memberships database documentation
#'
#' @format The memberships database is a list that contains the
#' following 2 datasets: GPTAD_MEM, DESTA_MEM.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{GPTAD_MEM: }{A dataset with 2198 observations and the following
#' 9 variables: manyID, stateID, Title, Beg, Signature, Force, StateName,
#'  gptadID, treatyID.}
#' \item{DESTA_MEM: }{A dataset with 7492 observations and the following
#' 9 variables: manyID, stateID, Title, Beg, Signature, Force, StateName,
#'  destaID, treatyID.}
#' }
#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(memberships, messydates::mreport)
#' ```
"memberships"
