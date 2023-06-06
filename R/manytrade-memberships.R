#' memberships database documentation
#'
#' @format The memberships database is a list that contains the
#' following 3 datasets: GPTAD_MEM, DESTA_MEM, HUGGO_MEM.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{GPTAD_MEM: }{A dataset with 2192 observations and the following
#' 9 variables: manyID, treatyID, Title, Begin, stateID, Signature, Force,
#' StateName, gptadID.}
#' \item{DESTA_MEM: }{A dataset with 7466 observations and the following
#' 9 variables: manyID, stateID, Title, Begin, Signature, Force, StateName,
#' destaID, treatyID.}
#' \item{HUGGO_MEM: }{A dataset with 9078 observations and the following
#' 11 variables: manyID, treatyID, Title, Begin, stateID, Signature, Force,
#' StateName, gptadID, destaID, changes.}
#' }
#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(memberships, messydates::mreport)
#' ```
"memberships"
