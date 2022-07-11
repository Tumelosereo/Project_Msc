bed_scen <- readRDS("./data/cost_analysis.rds")
load("output/sars_cov_2_outputs.RData")
baseline_output %>% select(Cur_addm, cum_add_days)
# Cost of treatment

delta.B <- bed_scen$cc - 20

Cost_tret <- function(A_t, C_a, cum_add){
  with(parms, {
    
    A_t*C_a + C_t*cum_add 
    
  })
}


## Cost of beds

Cost_beds <- function(A_b, C_a, delta.B){
  with(parms, {
    
    A_b*C_a + delta.B*C_b
    
  })
}

inp <- c(A_b = 20,
         A_t = 20,
         delta.B = 28-20)

# To have a net cost benefit we assume Cost of treatment must be less than cost of beds.
# That is cost_tret > cost_beds

C_t/C_a <- function(C_b/C_a, A_b, A_t, delta.B) {
   with(parms, {
     (A_b + A_t + delta.B * (C_b / C_a)) / (A_t)
   })
 }

