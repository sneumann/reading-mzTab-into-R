test_rmzTabM <- function(all_files) {
  renv::activate(profile = "rmzTabM")
  if(!require("rmzTabM")) {
    renv::restore()
    require("rmzTabM")
  }
  
  all_reads <- lapply(all_files, function(ith_file_name) {
    res <- try(readMzTab(ith_file_name), silent = TRUE)
    res
  })
  
  resulting_class <- sapply(all_reads, class)
  
  list(assessment = ifelse(resulting_class == "try-error", "crash", "success"),
       reads = all_reads)
}
