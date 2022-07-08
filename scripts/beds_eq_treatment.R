load("./output/sars_cov_2_outputs.RData")

base_ps <- .70
base_du <- 15
base_cc <- 20

# Remdesiver treatment

treat_ps <- .93
treat_du <- 15
treat_cc <- base_cc 


treat_cm <- cum_mortality_df %>% 
  filter(ps == treat_ps, du == treat_du, cc == treat_cc) %>% 
  select(cm)

cum_mortality_df %>% 
  filter(round(ps, 2) == round(base_ps, 2), du == base_du) %>% 
  mutate(tmp = cm - as.numeric(treat_cm)) %>%
  filter(abs(tmp) < 5)

 bed_scen <- cum_mortality_df %>% 
  filter(round(ps, 2) == round(base_ps, 2), du == base_du) %>% 
  mutate(tmp = cm - as.numeric(treat_cm)) %>%
  filter(abs(tmp) == min(abs(tmp)))
  
