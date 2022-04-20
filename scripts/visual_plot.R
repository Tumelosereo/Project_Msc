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
                    title = "Probability of surviving is 75%, 12 days of hospitalization 
                    with 20 availabe beds in population of 150000 individuals."
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

bed_capacity <- 20

baseline_cm <- function(bed_cap, psb = .75, dub = 15) new_df %>%
  filter(ps == psb, du == dub, cc == bed_cap)

(ggplot()
  +
    aes(x = ps, y = du, z = cm, color = as.character(cc))
  +
    geom_contour(breaks = c(min(new_df$cm), baseline_cm(bed_capacity)$cm, max(new_df$cm)), data = new_df[new_df$cc == bed_capacity, ])
  +
    geom_contour(breaks = c(min(new_df$cm), baseline_cm(180)$cm, max(new_df$cm)), data = new_df[new_df$cc == 180, ])
  +
    geom_point(data = baseline_cm(bed_capacity), size = 3, col = "blue")
  +
    lims(x = c(0, 1))
  +
    geom_vline(aes(xintercept = ps), data = baseline_cm(bed_capacity))
  +
    geom_hline(aes(yintercept = du), data = baseline_cm(bed_capacity))
  +
    labs(title = "Cumulative mortality at given number of beds"
         , x = "Probablilty of surving"
         , y = "Hospital duration (days)"
         , color = "Number of beds")
  #+ 
  #  theme(plot.caption = element_text(hjust = 0.5))
  +
    ggeasy::easy_center_title()
  
)

# plot the 

