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
#' 9 variables: manyID, treatyID, Title, Begin, stateID, Signature, Force,
#' StateName, destaID.}
#' \item{HUGGO_MEM: }{A dataset with 7202 observations and the following
#' 15 variables: manyID, treatyID, Title, Begin, stateID, Signature, Force,
#' StateName, gptadID, destaID, StateRatification, StateSignature, StateForce,
#' StateEnd, DataCollection.}
#' }
#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(memberships, messydates::mreport)
#' ```
"memberships"
