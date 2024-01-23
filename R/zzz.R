.onAttach <- function(lib, pkg) {
  msg <- c(paste0("manytrade ", utils::packageVersion("manytrade")),
           "\nFor more information about the package please visit https://globalgov.github.io/manytrade/",
           "\nType 'citation(\"manytrade\")' for citing this R package in publications.")
  packageStartupMessage(msg)      
  invisible()
}
