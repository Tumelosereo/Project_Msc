.args <- if(interactive()){
  c("./data/sars_cov_2.RData",   # inputs
    "./data/cost_analysis.rds",
    "./data/toci_treat.xlsx",
    "./output/my_data.RData") # output
}else{
  commandArgs(trailingOnly = TRUE)
}

target <- tail(.args, 1)

library(readxl)

# Load data to be used

load(.args[[1]])
load(.args[[2]])
treat <- read_excel(.args[3])

# Read the values for usual care

usual_care <- treat$usual_value
names(usual_care) <- treat$parms

# Read the values for treatment care

treat_care <- treat$treat_value
names(treat_care) <- treat$parms

cout_usual <- c(usual_care, cc = bed_scen$cc)

treat_df <- run_covid(
  t = time_seq,
  pp = parm_values,
  vals = c(treat_care,cc = 20),
  statev = state_var,
  ret_cm = FALSE )

treat_df <- treat_df %>% 
  mutate(Cur_addm = rowSums(cbind(treat_df$Hts, treat_df$Htd))) %>% 
  mutate(cum_add_days = cumsum(Cur_addm)) %>% 
  select(CA, cum_add_days)

casual_df <- run_covid(
  t = time_seq,
  pp = parm_values,
  vals = cout_usual,
  statev = state_var,
  ret_cm = FALSE )

casual_df <- casual_df %>% 
  mutate(Cur_addm = rowSums(cbind(casual_df$Hts, casual_df$Htd))) %>% 
  mutate(cum_add_days = cumsum(Cur_addm)) %>% 
  select(CA, cum_add_days)

save(treat_df, casual_df, file = target)
