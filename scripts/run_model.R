library(dplyr)

# Source the inputs
source("./scripts/functions.R", local = TRUE)
source("./scripts/inputs.R", local = TRUE)

## Run the model to calculate cumulative

# CM1 <- run_covid(
#   t = time_seq,
#   pp = parm_values,
#   vals = c(
#     ps = 0.25,
#     du = 12,
#     cc = 20
#   ),
#   statev = state_var
# )

## We define new parameters with different values of
## ps, a and du.



# Run the model to produce all rates of a diseas at baseline
# base_sar2 <- c(ps=.75, du = 15, cc = 20)
out <- run_covid(
  t = time_seq,
  pp = parm_values,
  vals = baseline_vals,
  statev = state_var, ret_cm = FALSE
)

# Save simulation output



## Here we only run with 1 rows from data frame new_vals.

run_covid(
  t = time_seq,
  pp = parm_values,
  vals = new_vals[3, ],
  statev = state_var
)

## Calculating Cumulative Mortality for all values of (new_vals)

if (file.exists("./output/cm_res.RData")) {
  load("./output/cm_res.RData")
} else {
  cm_res <- sapply(1:nrow(new_vals), function(ii) {
    run_covid(
      t = time_seq,
      pp = parm_values,
      vals = new_vals[ii, ],
      statev = state_var
    )
  })
  save(cm_res, file = "./output/cm_res.RData")
}



## Combine used parameters with corresponding cm value and save it

new_df <- cbind(new_vals, cm = cm_res)

save(new_df, file = "./output/new_df.RData")
