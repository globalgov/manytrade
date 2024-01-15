#' memberships datacube documentation
#'
#' @format The memberships datacube is a list that contains the
#' following 3 datasets: GPTAD_MEM, DESTA_MEM, HUGGO_MEM.
#' For more information and references to each of the datasets used,
#' please use the `manydata::call_sources()` and `manydata::compare_dimensions()` functions.
#'\describe{
#' \item{GPTAD_MEM: }{A dataset with 2192 observations and the following
#' 9 variables: manyID, treatyID, Title, Begin, stateID, Signature, Force,
#' StateName, gptadID.}
#' \item{DESTA_MEM: }{A dataset with 7466 observations and the following
#' 9 variables: manyID, treatyID, Title, Begin, stateID, Signature, Force,
#' StateName, destaID.}
#' \item{HUGGO_MEM: }{A dataset with 5608 observations and the following
#' 20 variables: manyID, treatyID, Title, Begin, stateID, Signature, Force, End,
#' StateName, gptadID, destaID, StateSignature, StateRatification, StateForce,
#' StateEnd, Rat=Notif, Coder, Source, Succession, Accession.}
#' }
#' @source
#' \itemize{
#' \item{GPTAD_MEM: }{
#' W. B. Group. _Global Preferential Trade Agreement Database (GPTAD)_.https://wits.worldbank.org/gptad/library.aspx. 2013.}
#' \item{DESTA_MEM: }{
#' A. Dür, L. Baccini, and M. Elsig. _The Design of International Trade Agreements: Introducing a NewDatabase_. Journal The Review of International Organizations, volume 9, number 3, pages 353-375, publisherSpringer. 2013.}
#' \item{HUGGO_MEM: }{
#' NA}
#' }
#' @section URL:
#' \itemize{
#' \item{GPTAD_MEM: }{
#' \url{https://wits.worldbank.org/gptad/library.aspx}
#' }
#' \item{DESTA_MEM: }{
#' \url{https://www.designoftradeagreements.org/downloads/}
#' }
#' \item{HUGGO_MEM: }{Hand-coded data by the GGO team}
#' }
#' @section Mapping:
#' \itemize{
#' \item{GPTAD_MEM: }{
#' Variable Mapping
#' 
#' |  *from*  | *to*
#' |:------------:|:------------:|
#' | Membership | StateName |
#' | Common.Name | Title |
#' | Date.of.Signature | Signature |
#' | Date.of.Entry.into.Force | Force|
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
