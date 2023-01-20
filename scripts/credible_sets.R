#the input here is a merged matrix of all fine-mapping jobs (per method!) for all loci.
#make sure to create beforehand a 'LOCUS' column to denote in which locus the fine-mapped SNP was found within.

library(dplyr)
library(tidyverse)
library(purrr)
library(ggplot2)

##Count the size of CSs from a merged finemapping .csv file. 
dat <- read_csv(snakemake@input[[1]]) %>%
  janitor::clean_names()

`%nin%` = negate(`%in%`)

test <- dat %>% 
  filter(credible_set != 0) %>%
  group_by(locus) %>%
  count(credible_set)

test %>% 
  pivot_wider(names_from = credible_set, values_from = n) %>%
  write_tsv(snakemake@output[[1])
