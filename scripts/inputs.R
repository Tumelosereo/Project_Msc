.args <- if(interactive()){
  c("./data/sars_cov_2_par.xlsx",   # inputs
    "./data/sars_cov_2_baseline.xlsx",  
    "./data/sars_cov_2.RData") # output
}else{
  commandArgs(trailingOnly = TRUE)
}

library(readxl)

# Source the functions script

# source("./scripts/functions.R", local = TRUE)

#read baseline vals
# if(.args[2] == "sars2"){
#   baseline_vals = c(du = , ...)
# }
# if(.args[2] == "sars1"){
# 
# }
# if(.args[2] == "ebola"){
# 
# }
baseline_vals_raw <- read_excel(.args[2])

# Read Parameter values for SARS-Cov-2.

baseline_vals <- c(ps = as.numeric(baseline_vals_raw$ps),
                   du = as.numeric(baseline_vals_raw$du),
                   cc = as.numeric(baseline_vals_raw$cc))

pp <- read_excel(.args[1])

# Extract only values from the Data Frame

parm_values <- pp$Value
names(parm_values) <- pp$Code
parm_values <- parm_values[1:11]

## State variables

N0 <- 150000 # Assumed total population

ss <- read_excel("./data/states.xlsx")

# Extract only values from the Data Frame

state_var <- ss$Value
names(state_var) <- ss$Code

## Time interval

time_seq <- seq(0, 365, 1)

## expand.grid helps to create the data with matching number of length.

new_vals <- expand.grid(
  ps = seq(0, 1, 0.01),
  du = 8:30,
  cc =  seq(20, 300, 20)
)

save(list = ls(), file = tail(.args,1))
