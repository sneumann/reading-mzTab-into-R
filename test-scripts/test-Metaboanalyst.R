test_MetaboanalystR <- function(all_files) {
  renv::activate(profile = "MetaboAnalystR")
  if(!require("MetaboAnalystR")) {
    renv::restore()
    require("MetaboAnalystR")
  }
  
  all_reads <- lapply(all_files, function(ith_file_name) {
    # there are many global assignments in metaboanalystR 
    # so we initiate and remove objects every loop and we clean the global
    rm(list = setdiff(ls(), c("all_files", "ith_file_name")))
    
    # we use a non-standard anal.type to avoid Rserve initialization 
    mSet <- InitDataObjects("mztab", "anything", FALSE, default.dpi = 150)
    res <- try(Read.mzTab(mSet, ith_file_name, identifier = "name"), 
               silent = TRUE)
    res
  })
  
  resulting_class <- sapply(all_reads, class)
  
  list(assessment = ifelse(resulting_class == "list", "success", 
                           ifelse(resulting_class == "try-error", 
                                  "crash", "silent failure")),
       reads = all_reads)
}


