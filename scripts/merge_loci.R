##this code is still in demo version as part of the snakemake pipeline; needs further parallelization and beta testing.

library(tidyverse)

concatenate_results <- function(fldr, method) {
  files = list.files(fldr)
  new_results = data.frame()
  for (f in files) {
    setwd(fldr)
    file = read_tsv(f)
    file$LOCUS = gsub(".*\\.(.*)\\..*", "\\1", f)
    print(gsub(".*\\.(.*)\\..*", "\\1", f))
    new_results = rbind(new_results, file)
  }
  return(new_results)
}

##make sure to move the files with different fine-mapping ranges in different subfolders if need be (if you run the whole pipeline)

finemap_results = concatenate_results(snakemake@params[[param2]], finemap)
polyfun_susie_results = concatenate_results(snakemake@params[[param3]], polyfun_susie)
polyfun_finemap_results = concatenate_results(snakemake@params[[param4]], polyfun_finemap)
susie_results = concatenate_results(snakemake@params[[param1]])


write_csv(finemap_results, snakemake@output[[output2]])
write_csv(polyfun_susie_results, snakemake@output[[output3]])
write_csv(polyfun_finemap, snakemake@output[[output4]])
write_csv(susie_results, snakemake@output[[output1]])
