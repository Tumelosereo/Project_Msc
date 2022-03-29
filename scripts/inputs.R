
## Parameter values.

parm_values <- c(
  alpha = 1 / 6, # 1/duration of pre-symptomatic = 1/6 days
  eta = 1 / 7, # 1/duration of asymptomatic to recover = 1/7 days
  sigma = 1 / 5, # NB: for now (NCEM)
  epsilon = 1 / 3, # 1/duration of infection to hospitalized = 1/3 days
  # mu = 1/12,       # progression rate from H_T(d): 1/12 days
  nu = 1 / 12, # 1/duration from not hospital to death = 1/15 days
  gamma = 1 / 9, # 1/9 days=1/duration from hospital to recovered
  pa = 0.85, # prob of remaining asymptomatic 85% (PHIRST-C)
  pm = 0.95, # prob of being mild or moderate given symptomatic 90% (NCEM)
  # ps = 0.25,       # prob of survival given hospitalization (DATCOV)
  # a = 10,          # Hospital capacity constrain:-(cc)
  b = 1,
  pmax = 0.4, # Maximum probability of being hospitalized in cc
  # 40% proportion of severe ILI cases.
  R0 = 2, # Reproduction number
  D = 5
) # Duration of infection in days


## State variables

N0 <- 150000 # Assumed total population

state_var <- c(
  S = N0 - 1,
  Ia = 1,
  Is = 0,
  M = 0,
  V = 0,
  Nt = 0,
  Hts = 0,
  Htd = 0,
  R = 0,
  CM = 0,
  CA = 0
)

## Time interval

time_seq <- seq(0, 365, 1)
