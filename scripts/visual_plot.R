library(ggplot2)
library(dplyr)
library(tidyr)
library(patchwork)

load("./output/new_df.RData")
source("./scripts/inputs.R", local = TRUE)


# Plot the simulation output 
# Make the data(out) long and plot according to the states.

new_out <- out %>%
  pivot_longer(S:CA, values_to = "Count", names_to = "States")

model_out <- (ggplot(new_out)
                +
                  geom_line(aes(
                    x = time,
                    y = Count,
                    col = States
                  ), size = 1)
                +
                  labs(
                    x = "Time(days)",
                    y = "Population",
                    title = "Probability of surviving is 0%, 12 days of hospitalization 
                    with 5 availabe beds in population of 150000 individuals."
                  )
                +
                  facet_wrap(~States, scales = "free") +
                  theme(plot.title = element_text(hjust = 0.5))
                
)

print(model_out)

# save the model output 

if(dir.exists("./figs")){
  ggsave(filename = "./figs/model_out.jpg",
         plot = model_out,
         width = 8.51,
         height = 5.67,
         units = "in")
  
}else{
  dir.create("./figs")
  ggsave(filename = "./figs/model_out.jpg",
         plot = model_dynmc,
         width = 8.51,
         height = 5.67,
         units = "in")
}


########################################################
# Hypothetical drugs


bed_cap <- 80

baseline_cm <- new_df %>%
  filter(ps == .8, du == 15, cc == bed_cap)

(ggplot(new_df[new_df$cc == bed_cap, ])
  + aes(x = ps, y = du, z = cm)
  + geom_contour(breaks = c(min(new_df$cm),baseline_cm$cm, max(new_df$cm)))
  + lims(x = c(0,1))
  #+ geom_point(aes(x = baseline_cm$ps, y = baseline_cm$du), size = 5, col = "red")
  #+ geom_hline(aes(yintercept = du), data = baseline_cm)
  #+ geom_vline(aes(xintercept = ps), data = baseline_cm)
)

