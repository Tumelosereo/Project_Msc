.args <- if(interactive()){
  c("./data/sars_cov_2.RData",  # inputs
    "./functions/functions.RData",  
    "./output/sars_cov_2_outputs.RData")  # outputs
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
baseline_output <- run_covid(
  t = time_seq,
  pp = parm_values,
  vals = baseline_vals,
  statev = state_var, ret_cm = FALSE
)

## Add the column of H = Hts + Htd

baseline_output <- baseline_output %>% 
  mutate(Cur_addm = rowSums(cbind(baseline_output$Hts, baseline_output$Htd))) %>% 
  mutate(cum_add_days = cumsum(Cur_addm))


## Here we only run with 1 rows from data frame new_vals.

run_covid(
  t = time_seq,
  pp = parm_values,
  vals = new_vals[3, ],
  statev = state_var
)

## Calculating Cumulative Mortality for all values of (new_vals)


if(file.exists(target)){
  load(target)
} else{
  
  cm_res <- sapply(1:nrow(new_vals), function(ii) {
    run_covid(
      t = time_seq,
      pp = parm_values,
      vals = new_vals[ii, ],
      statev = state_var
    )
  })
  
  ## Combine used parameters with corresponding cm value and save it
  
  cum_mortality_df <- cbind(new_vals, cm = cm_res)
  
  save(cum_mortality_df, baseline_output, file = target)
  
}
 
