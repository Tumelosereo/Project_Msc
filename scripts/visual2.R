.args <- if(interactive()){
  c("./output/sars_cov_2_outputs.RData",  # inputs
    "./data/toci_treat.xlsx",
    "./figs/sars_cov_2_model.jpg")  # outputs
}else{
  commandArgs(trailingOnly = TRUE)
}

target <- tail(.args, 1)

library(ggplot2)
library(readxl)
library(dplyr)
library(tidyr) 

load(.args[[1]])

# Plot the simulation output 
# Make the data(out) long and plot according to the states.

new_out <- baseline_output %>%
  pivot_longer(S:CA, values_to = "Count", names_to = "States")

#treat_output <- run_model(
#  t = time_seq,
#  pp = parm_values,
#  vals = treat_vals,
#  statev = state_var, ret_cm = FALSE
#)

plot1 <- (ggplot(new_out)
          +
            geom_line(aes(
              x = time,
              y = Count,
              col = States
            ), size = 1)
          +
            labs(
              x = "Time(days)"
              , y = "Population"
              #, title = "Probability of surviving is 75%, 12 days of hospitalization 
               #     with 20 available beds in population of 150000 individuals."
            )
          +
            facet_wrap(~States, scales = "free") 
          +
            ggeasy::easy_center_title()
          +
            theme_bw()
          
)

if(dir.exists("./figs")){
  ggsave(filename = target,
         plot = plot1,
         width = 8.51,
         height = 5.67,
         units = "in")
  
}else{
  dir.create("./figs")
  ggsave(filename = target,
         plot = plot1,
         width = 8.51,
         height = 5.67,
         units = "in")
}
