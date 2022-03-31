library(readxl)

# Read Parameter values for SARS Cov 2.

pp <- read_excel("./data/sars_cov2_par.xlsx", sheet = "sars_cov2_par")

# Extract only values from the Data Frame

parm_values <- pp$Value
names(parm_values) <- pp$Code

## State variables

N0 <- 150000 # Assumed total population

ss <- read_excel("./data/states.xlsx", sheet = "states")

# Extract only values from the Data Frame

state_var <- ss$Value
names(state_var) <- ss$Code

## Time interval

time_seq <- seq(0, 365, 1)
