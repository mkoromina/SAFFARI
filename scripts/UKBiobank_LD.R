#!/usr/bin/env Rscript

library(readr)
library(purrr)
library(dplyr)
library(readxl)
library(tools)
library(yaml)

######################################################################################################
#### Functions from echolocatoR ####
######################################################################################################


LD.UKB_find_ld_prefix <- function(chrom, min_pos) {
   bp_starts <- seq(1,252000001, by = 1000000)
   bp_ends <- bp_starts+3000000
   i <- max(which(bp_starts<=as.numeric(min_pos)))
   list(chrom = paste0("chr", chrom), beginning = bp_starts[i], end = bp_ends[i])
 }

# wget <- function(input_url,
#                  output_path,
#                  background=F,
#                  force_overwrite=T,
#                  quiet=T,
#                  show_progress=F,
#                  continue=F,
#                  check_certificates=F){
#   # https://stackoverflow.com/questions/21365251/how-to-run-wget-in-background-for-an-unattended-download-of-files
#   ## -bqc makes wget run in the background quietly
#   #dir.create(output_path, showWarnings = F, recursive = T)
#   out_file <- file.path(output_path,basename(input_url))
#   cmd <- paste("wget",
#                input_url,
#                "-np",
#                ## Checking certificates can sometimes cause issues
#                if(check_certificates) "" else "--no-check-certificate",
#                if(background) "-b" else "",
#                if(continue) "-c" else "",
#                if(quiet) "-q" else "",
#                if(show_progress) "--show-progress" else "",
#                "-P",output_path,
#                if(force_overwrite) "" else "--no-clobber"
#   )
#   # print(cmd)
#   #system(paste(cmd,"&& echo '+ wget download complete.'"), ignore.stdout = T)
#   #cmd <- paste("wget","-c",input_url,"-P",output_path)
#   #system(cmd, ignore.stdout = T, ignore.stderr = T)
#   return(out_file)
# }

# LD.download_UKB_LD <- function(LD.prefixes,
#                                locus_dir = "~/",
#                                alkes_url="https://data.broadinstitute.org/alkesgroup/UKBB_LD",
#                                background=T,
#                                force_overwrite=F,
#                                download_method="wget",
#                                nThread=4){
#   for(f in LD.prefixes){
#     gz.url <- file.path(alkes_url,paste0(f,".gz"))
#     npz.url <- file.path(alkes_url,paste0(f,".npz"))
    
#     for(furl in c(gz.url, npz.url)){
#       if(tolower(download_method)=="axel"){
#         out.file <- axel(input_url = furl,
#                          output_path = file.path(locus_dir),
#                          background = background,
#                          nThread = nThread,
#                          force_overwrite = force_overwrite)
#       }
#       if(tolower(download_method)=="wget"){
#         out.file <- wget(input_url = furl,
#                          output_path = file.path(locus_dir),
#                          background = background,
#                          force_overwrite = force_overwrite)
#       }
#     }
#   }
#   return(gsub("*.npz$","",out.file))
# }

######################################################################################################
######################################################################################################

config = yaml.load_file("config.yaml")
gwas <- config$summary_stats_prefix
print(config)

if (file_ext(snakemake@input[[1]]) != 'xlsx') {
  loci <- read_csv(snakemake@input[[1]])

} else {
  excel_sheet <- readxl::read_excel("/sc/arion/projects/ad-omics/data/references//GWAS/GWAS-QTL_data_dictionary.xlsx", sheet = 3)
  gwas_row <- excel_sheet[excel_sheet$dataset == gwas,]
  if (file_ext(gwas_row) == 'xlsx') {
    top_loci_file <- readxl::read_excel(gwas_row$top_path)
  } else {
    top_loci_file <- read_tsv(gwas_row$top_path)
    position <- gwas_row$top_pos
    top_loci_file <- top_loci_file %>% select(c(gwas_row$top_chrom, gwas_row$top_pos, gwas_row$top_snp, gwas_row$top_locus))
    colnames(top_loci_file) <- c('chrom', 'BP', 'SNP', 'locus')
    top_loci_file$loci_start <- top_loci_file$BP - 1000000
    top_loci_file$loci_end <- top_loci_file$BP + 1000000
    loci = top_loci_file
    colnames(loci) <- c('CHR', 'BP', 'SNP', 'locus', 'loci_start', 'loci_end')

  } 
}



mapped <- map2_dfr(loci$CHR, loci$BP, LD.UKB_find_ld_prefix)


# print(head(mapped))

if (file_ext(snakemake@input[[1]]) != 'xlsx') {
  loci %>%
    select(-starts_with("..")) %>%
    bind_cols(mapped) %>%
    tidyr::unite(chrom, beginning, end, col = "file", remove = F) %>%
    select(chrom_orig = CHR, chrom, BP, beginning, end, file, everything()) %>%
    write_tsv(snakemake@output[[1]])
} else {
  loci <- cbind(loci, mapped)
  colnames(loci) = c('CHR', 'BP', 'RSID', 'locus', 'locus_start', 'locus_end', 'chrom', 'beginning', 'end')
  # loci <- loci[, -c(5,6)]
  print(head(loci))
  # loci <- select(loci, -c(loc_begin, loc_end))  
  loci$beginning <- as.numeric(loci$beginning)
  loci$end <- as.numeric(loci$end)
  
  write_tsv(loci, snakemake@output[[1]])
}
