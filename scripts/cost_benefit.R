
# Cost of treatment

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

# To have a net cost benefit we assume Cost of treatment must be less than cost of beds.
# That is cost_tret > cost_beds

