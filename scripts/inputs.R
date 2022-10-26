.args <- if(interactive()){
  c("./data/sars_cov_2_par.xlsx",   # inputs
    "./data/toci_treat.xlsx",
    "./data/sars_cov_2_baseline.xlsx",  
    "./data/sars_cov_2.RData") # output
}else{
  commandArgs(trailingOnly = TRUE)
}

library(readxl)

# Read the excel file with parameters

baseline_vals_raw <- read_excel(.args[2]) 

# Read raw values at baseline

baseline_vals <- baseline_vals_raw$usual_value
names(baseline_vals) <- baseline_vals_raw$parms

# Read raw values at at treatment

treat_vals <- baseline_vals_raw$treat_value
names(treat_vals) <- baseline_vals_raw$parms

# Read Parameter values for SARS-Cov-2 at baseline.

baseline_vals <- c(baseline_vals,
                   cc = 23)

# Paramter with treatment.

treat_vals <- c(treat_vals,
                cc = 23)

pp <- read_excel(.args[1])

# Extract only values from the Data Frame

parm_values <- pp$Value
names(parm_values) <- pp$Code
parm_values <- parm_values[1:11]

## State variables

N0 <- 100000 # Assumed total population

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
  cc =  c(seq(20, 40, 1), seq(60, 300, 20))
)

save(list = ls(), file = tail(.args,1))
