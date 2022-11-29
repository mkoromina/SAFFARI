library(dplyr)
library(readr)
library(purrr)
library(tidyr)

dat <- read_csv(snakemake@input[[1]]) %>%
  janitor::clean_names()

`%nin%` = negate(`%in%`)

##count how many finemapped loci have a SNP for a certain PIP threshold

test2 <- dat %>%
  filter(credible_set != 0) %>%
  group_by(locus) %>%
  summarise(
    pip090=sum(pip >= 0.90),
    pip050_090=sum(pip > 0.50 & pip < 0.90),
    pip010_050=sum(pip <= 0.50 & pip > 0.10),
    pip010=sum(pip <= 0.10)
  )

data <- colSums(test2 !=0) %>%
write_tsv(snakemake@output[[1]])

df_dat2 <- tibble(pip_thres= c(">= 90%", "50-90%", "10-50% ", "<=10%"),
             count_loci = c(data$pip090, data$pip050_090, data$pip010_050, data$pip010))
ggplot(df_dat2, aes(x = "", y = count_loci, fill = pip_thres)) +
  geom_col(width=0.2) +
  geom_text(aes(label = paste0(count_loci)), 
  position = position_stack(vjust = 0.5)) + labs(x="", y= "N of finemapped loci") 

ggsave("binned_loci.png", plot = ggplot() , width = 10, height = 10, units = "in", dpi = 300)
