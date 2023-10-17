#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(purrr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(readxl))
suppressPackageStartupMessages(library(tools))
suppressPackageStartupMessages(library(yaml))

######################################################################################################
#### Functions from echolocatoR ####
######################################################################################################

LD.UKB_find_ld_prefix <- function(chrom, min_pos) {
   bp_starts <- seq(1,252000001, by = 1000000)
   bp_ends <- bp_starts+3000000
   i <- max(which(bp_starts<=as.numeric(min_pos)))
   list(chrom = paste0("chr", chrom), beginning = bp_starts[i], end = bp_ends[i])
 }

gwas = snakemake@wildcards[[2]]

if (file_ext(snakemake@input[[1]]) != 'tsv') {
  loci <- read_csv(snakemake@input[[1]])
} else if (file.exists("/sc/arion/projects/ad-omics/data/references//GWAS/GWAS-QTL_data_dictionary_GWAS.tsv")) {
  excel_sheet <- read_tsv("/sc/arion/projects/ad-omics/data/references//GWAS/GWAS-QTL_data_dictionary_GWAS.tsv")
  gwas_row <- excel_sheet[excel_sheet$dataset == gwas,]
  print(gwas_row)
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
} else {
    print("ERROR: Top Loci File cannot be found.")
}
print("hello?")
mapped <- map2_dfr(loci$CHR, loci$BP, LD.UKB_find_ld_prefix)

if (file_ext(snakemake@input[[1]]) != 'tsv') {
  loci %>%
    select(-starts_with("..")) %>%
    bind_cols(mapped) %>%
    tidyr::unite(chrom, beginning, end, col = "file", remove = F) %>%
    select(chrom_orig = CHR, chrom, BP, beginning, end, file, everything()) %>%
    write_tsv(snakemake@output[[1]])
} else {
  m <- mapped %>% tidyr::unite(chrom, beginning, end, col = "file", remove = F)

  loci <- cbind(loci, m)
  colnames(loci) = c('chrom_orig', 'BP', 'SNP', 'locus', 'range.left', 'range.right', 'file', 'chrom', 'beginning', 'end')
  print(loci)
  # loci <- loci[, -c(5,6)]
  # loci <- select(loci, -c(loc_begin, loc_end))  
  loci$beginning <- as.numeric(loci$beginning)
  loci$end <- as.numeric(loci$end)
  
  write_tsv(loci, snakemake@output[[1]])
}
