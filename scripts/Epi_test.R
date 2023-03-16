library(EpiNow2)

reporting_delay <- estimate_delay(
  rlnorm(1000, log(2), 1),
  max_value = 15, bootstraps = 1
)

reporting_delay <- list(
  mean = convert_to_logmean(2, 1), sd = convert_to_logsd(2, 1), max = 10,
  dist = "lognormal"
)

generation_time <- get_generation_time(
  disease = "SARS-CoV-2", source = "ganyani", max = 10, fixed = TRUE
)

incubation_period <- get_incubation_period(
  disease = "SARS-CoV-2", source = "lauer", max = 10, fixed = TRUE
)

reported_cases <- example_confirmed[1:60]

estimates <- epinow(
  reported_cases = reported_cases,
  generation_time = generation_time_opts(generation_time),
  delays = delay_opts(incubation_period, reporting_delay),
  rt = rt_opts(prior = list(mean = 2, sd = 0.2)),
  stan = stan_opts(cores = 4, control = list(adapt_delta = 0.99)),
  verbose = interactive()
)

knitr::kable(summary(estimates))

head(summary(estimates, type = "parameters", params = "R"))
