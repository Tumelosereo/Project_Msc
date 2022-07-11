bed_scen <- readRDS("./data/cost_analysis.rds")

load("output/sars_cov_2_outputs.RData")


my_data <- baseline_output %>% select(Cur_addm, cum_add_days) %>% 
  mutate(delta.B = replicate(nrow(baseline_output), delta.B)) %>% 
  mutate(Cab = seq(0, 365, 1))

# Cost of treatment

delta.B <- bed_scen$cc - 20

# To have a net cost benefit we assume Cost of treatment must be less than cost of beds.
# That is cost_tret > cost_beds. 
# Let C_b/C_a = variable Cba and 

Cost_ba <- function(Cab, A_b, A_t, delta.B) {
   with(parms, {
     (A_b - A_t + delta.B * Cab) / H
   })
}

my_data[2, ]

Cost_ba(Cab = my_data[2,1], A_t = 20,  delta.B = my_data$delta.B)
