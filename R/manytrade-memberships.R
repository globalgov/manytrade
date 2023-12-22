#' memberships datacube documentation
#'
#' @format The memberships datacube is a list that contains the
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
#' 18 variables: manyID, treatyID, Title, Begin, stateID, Signature, Force,
#' StateName, gptadID, destaID, StateRatification, StateSignature, StateForce,
#' StateEnd, Rat=Notif, Coder, Source.}
#' }
#' @source
#'\itemize{
#' \item{GPTAD_MEM: }{
#' [1] W. B. Group. _Global Preferential Trade Agreement Database (GPTAD)_.https://wits.worldbank.org/gptad/library.aspx. 2013.}
#' \item{DESTA_MEM: }{
#' [1] A. Dür, L. Baccini, and M. Elsig. _The Design of International Trade Agreements: Introducing a NewDatabase_. Journal The Review of International Organizations, volume 9, number 3, pages 353-375,publisher Springer. 2014.}
#' \item{HUGGO_MEM: }{
#' Hand-coded by the GGO team.
#' }
#' @section URL:
#'\itemize{
#' \item{GPTAD_MEM: }{ \url https://wits.worldbank.org/gptad/library.aspx}
#' \item{DESTA_MEM: }{ \url https://www.designoftradeagreements.org/downloads/}
#' \item{HUGGO_MEM: }{ \url Hand-coded by the GGO team}
#' }
#' @section Mapping:
#'\itemize{
#' \item{GPTAD_MEM: }{
#' Variable Mapping
#'
#' |  *from*  | *to*
#' |:------------:|:------------:|
#' | Membership | StateName |
#' | Common.Name | Title |
#' | Date.of.Signature | Signature |
#' | Date.of.Entry.into.Force | Force
#' 
#' }
#' \item{DESTA_MEM: }{
#' Variable Mapping
#'
#' |  *from*  | *to*
#' |:------------:|:------------:|
#' | base_treaty | destaID |
#' | name | Title |
#' | year | Signature |
#' | entryforceyear | Force |
#' | c1:c91 | stateID |
#' 
#' }
#' }
#' @md
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(memberships, messydates::mreport)
#' ```
"memberships"
