#' Code Country Names
#'
#' Standardize country names from other languages, abbreviations, or codes.
#' @param name A character vector of country name
#' @return A character vector of country name
#' @examples
#' name <- c("argentine", "albanie", "Bélarus")
#' code_countryname(name)
#' @export
code_countryname <- function(name) {
  # Tranlates string to ASCII
  name <- iconv(name, to="ASCII//TRANSLIT")
  name <- data.frame(name = as.character(name))
  coment <- sapply(countryregex[, 3], function(x) grepl(x, name,
                                                        ignore.case = TRUE,
                                                        perl = TRUE) * 1)
  colnames(coment) <- countryregex[, 2]
  rownames(coment) <- name
  out <- apply(coment, 1, function(x) paste(names(x[x == 1])))
  out[out == ""] <- NA
  country <- unname(out)
  country
}
