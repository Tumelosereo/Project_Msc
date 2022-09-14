.args <- if(interactive()){
  c("./functions/functions.RData", # inputs
    "./data/sars_cov_2.RData",   
    "./data/bed_scen.rds",
    "./data/toci_treat.xlsx",
    "./output/my_data.RData") # output
}else{
  commandArgs(trailingOnly = TRUE)
}

target <- tail(.args, 1)

library(readxl)
library(dplyr)
library(deSolve)

# Load data to be used

load(.args[[1]])
load(.args[[2]])
bed_scen <- readRDS(.args[[3]])

treat <- read_excel(.args[4])

# Read the values for usual care

usual_care <- treat$usual_value
names(usual_care) <- treat$parms

# Read the values for treatment care

treat_care <- treat$treat_value
names(treat_care) <- treat$parms

count_usual <- c(usual_care, cc = bed_scen$cc)

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
  vals = count_usual,
  statev = state_var,
  ret_cm = FALSE )

casual_df <- casual_df %>% 
  mutate(Cur_addm = rowSums(cbind(casual_df$Hts, casual_df$Htd))) %>% 
  mutate(cum_add_days = cumsum(Cur_addm)) %>% 
  select(CA, cum_add_days)

save(treat_df, casual_df, file = target)
