.args <- if(interactive()){
  c("./data/sars_cov_2.RData",  # inputs
    "./functions/functions.RData",  
    "./output/sarscov2_baseline_outputs.RData")  # outputs
}else{
  commandArgs(trailingOnly = TRUE)
}

library(dplyr)
library(deSolve)

target <- tail(.args, 1)

# Source the inputs

load(.args[[1]])
load(.args[[2]])

# Run the model to produce all rates of a disease at baseline
# base_sar2 <- c(ps=.75, du = 15, cc = 20)

baseline_output <- run_model(
  t = time_seq,
  pp = parm_values,
  vals = baseline_vals,
  statev = state_var, ret_cm = FALSE
)

treat_output <- run_model(
  t = time_seq,
  pp = parm_values,
  vals = treat_vals,
  statev = state_var, ret_cm = FALSE
)


## Add the column of H = Hts + Htd that is currently admitted in hospital

baseline_output <- baseline_output %>% 
  mutate(Cur_addm = rowSums(cbind(baseline_output$Hts, baseline_output$Htd))) %>% 
  mutate(cum_add_days = cumsum(Cur_addm))


treat_output <- treat_output %>% 
  mutate(Cur_addm = rowSums(cbind(treat_output$Hts, treat_output$Htd))) %>% 
  mutate(cum_add_days = cumsum(Cur_addm))

save(baseline_output, treat_output, file = target)
