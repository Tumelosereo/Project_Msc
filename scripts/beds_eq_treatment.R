.args <- if(interactive()){
  c("./output/sars_cov_2_outputs.RData",  # inputs
    "./data/cost_analysis.RData")  # outputs
}else{
  commandArgs(trailingOnly = TRUE)
}

library(dplyr)

target <- tail(.args, 1)

load(.args[[1]])

# Usual care for w/o Toci

base_toc <- cum_mortality_df %>% 
  filter(ps == .65, du == 28, cc == 20)

# Toci treatment

treat_toc <- cum_mortality_df %>% 
  filter(round(ps, 2) == round(.69, 2), du == 15, cc == 20)

treat_cm <- treat_toc %>% select(cm)

bed_scen <- cum_mortality_df %>%
  filter(round(ps, 2) == round(.65, 2), du == 28) %>% 
  mutate(tmp = cm - as.numeric(treat_cm)) %>%
  filter(abs(tmp) == min(abs(tmp)))



save(bed_scen, file = target)
