

library(dplyr)
library(tidyverse)
library(purrr)
library(ggplot2)
library(vroom)


##Count the size of CSs from a merged finemapping tsv file
dat <- read_csv(snakemake@input[[loci]]) %>%
  janitor::clean_names()

`%nin%` = negate(`%in%`)

test <- dat %>% 
  filter(credible_set != 0) %>%
  group_by(locus) %>%
  count(credible_set)

test %>% 
  pivot_wider(names_from = credible_set, values_from = n) %>%
  write_tsv(snakemake@output[[CS]])


##Count how many finemapped loci have a SNP for a certain PIP threshold
  ##merged dfs are again the input as above

test2 <- dat %>%
  filter(credible_set != 0) %>%
  group_by(locus) %>%
  summarise(
    pip090=sum(pip >= 0.90),
    pip050_090=sum(pip > 0.50 & pip < 0.90),
    pip010_050=sum(pip <= 0.50 & pip > 0.10),
    pip010=sum(pip <= 0.10)
  )

##to test the following part as snakemake@output[[binned_loci]]

data %>%
colSums(test2 !=0) %>%
write_tsv(snakemake@output[[binned_loci]])

df_dat2 <- tibble(pip_thres= c(">= 90%", "50-90%", "10-50% ", "<=10%"),
             count_loci = c(data$pip090, data$pip050_090, data$pip010_050, data$pip010))
ggplot(df_dat2, aes(x = "", y = count_loci, fill = pip_thres)) +
  geom_col(width=0.2) +
  geom_text(aes(label = paste0(count_loci)), 
  position = position_stack(vjust = 0.5)) + labs(x="", y= "N of finemapped loci") 

#ggsave("binned_loci.png", plot = ggplot() , width = 10, height = 10, units = "in", dpi = 300)
