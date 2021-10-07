#' Code Country Names
#'
#' Standardize spellings for country names,
#' as well as country names in other languages.
#' @param name A character vector of country name
#' @param abbrev Do you want 3 letter country
#' abbreviations to be returned?
#' False by default.
#' @importFrom stringi stri_trans_general
#' @return A character vector of country name
#' @examples
#' name <- c("argentine", "albanie", "Bélarus")
#' code_countryname(name)
#' code_countryname(name, abbrev = TRUE)
#' @export
code_countryname <- function(name, abbrev = FALSE) {
  # Translates string to ASCII
  name <- stringi::stri_trans_general(name, "Latin-ASCII")
  if (abbrev == TRUE) {
    for (k in seq_len(nrow(countryregex))) {
      name <- gsub(paste0(countryregex$Regex[[k]]),
                   paste0(countryregex$StatID[[k]]),
                   name, ignore.case = TRUE,
                   perl = T)
      }
  } else {
      for (k in seq_len(nrow(countryregex))) {
        name <- gsub(paste0(countryregex$Regex[[k]]),
                     paste0(countryregex$Label[[k]]),
                     name, ignore.case = TRUE,
                     perl = T)
        }
  }
  name
}
