.args <- if(interactive()){
  c("./output/sars_cov_2_outputs.RData",  # inputs
    "./data/toci_treat.xlsx",
    "./data/bed_scen.rds")  # outputs
}else{
  commandArgs(trailingOnly = TRUE)
}

library(dplyr)
library(readxl)

target <- tail(.args, 1)

load(.args[[1]])
base_toc1 <- read_excel(.args[2])

# Usual care for w/o Toci

baseline_dat <- base_toc1$usual_value
names(baseline_dat) <- base_toc1$parms

base_toc <- cum_mortality_df %>% 
  filter(ps == baseline_dat["ps"], du == baseline_dat["du"], cc == 20)

# Toci treatment


treat_dat <- base_toc1$treat_value
names(treat_dat) <- base_toc1$parms

treat_toc <- cum_mortality_df %>% 
  filter(round(ps, 2) == treat_dat["ps"], du == treat_dat["du"], cc == 20)

treat_cm <- treat_toc %>% select(cm)

bed_scen <- cum_mortality_df %>%
  filter(round(ps, 2) == baseline_dat["ps"], du == baseline_dat["du"]) %>% 
  mutate(tmp = cm - as.numeric(treat_cm)) %>%
  filter(abs(tmp) == min(abs(tmp)))

saveRDS(bed_scen, file = target)
