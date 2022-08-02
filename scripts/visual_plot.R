.args <- if(interactive()){
  c("./output/sars_cov_2_outputs.RData",  # inputs
    "./data/toci_treat.xlsx",
    "./figs/sars_cov_2_plot.jpg")  # outputs
}else{
  commandArgs(trailingOnly = TRUE)
}

target <- tail(.args, 1)

library(ggplot2)
library(dplyr)
library(tidyr)
library(patchwork)

load(.args[[1]])
#source("./scripts/run_model.R", local = TRUE)


# Plot the simulation output 
# Make the data(out) long and plot according to the states.

new_out <- baseline_output %>%
  pivot_longer(S:CA, values_to = "Count", names_to = "States")

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
                    , title = "Probability of surviving is 75%, 12 days of hospitalization 
                    with 20 availabe beds in population of 150000 individuals."
                  )
                +
                  facet_wrap(~States, scales = "free") 
              +
                ggeasy::easy_center_title()
              +
                theme_bw()
              
)



########################################################
# Hypothetical drugs

bed_capacity <- 20

readRDS(.args[[2]])

baseline_cm <- function(bed_cap, psb = .71, dub = 19) cum_mortality_df %>%
  filter(ps == psb, du == dub, cc == bed_cap)

plot2 <- (ggplot()
  +
    aes(x = ps, y = du, z = cm, color = as.character(cc)
        )
  +
    geom_contour(breaks = c(min(cum_mortality_df$cm), 
                            baseline_cm(bed_capacity)$cm, 
                            max(cum_mortality_df$cm)), 
                 data = cum_mortality_df[cum_mortality_df$cc == bed_capacity, ])
  +
    geom_contour(breaks = c(min(cum_mortality_df$cm), 
                            baseline_cm(180)$cm, 
                            max(cum_mortality_df$cm)), 
                 data = cum_mortality_df[cum_mortality_df$cc == 180, ])
  +
    geom_point(data = baseline_cm(bed_capacity), size = 3, col = "blue")
  +
    lims(x = c(0, 1))
  +
    geom_vline(aes(xintercept = ps), data = baseline_cm(bed_capacity))
  +
    geom_hline(aes(yintercept = du), data = baseline_cm(bed_capacity))
  +
    labs(#title = "Cumulative mortality at given number of beds",
          x = "Probablilty of surving"
         , y = "Hospital duration (days)"
         , color = "Number of beds")
  + 
    theme_bw()
  +
    ggeasy::easy_center_title()
  
)



if(dir.exists("./figs")){
  ggsave(filename = target,
         plot = plot2,
         width = 8.51,
         height = 5.67,
         units = "in")

}else{
  dir.create("./figs")
  ggsave(filename = target,
         plot = plot2,
         width = 8.51,
         height = 5.67,
         units = "in")
}


# From the above figure we observed that, there is a substantial region that shows
# that it is always beneficial to use the hypothetical treatment that increases 
# probability surviving and hospital stay in a population level, which improves
# mortality outcomes at the baseline. Furthermore, the synergy between bed  
# capacity and treatment have great impact in the mortality outcomes. The next step 
# is to consider the cost of resource in the instance of synergy observed.  

#- increasing bed capacity decreases cumulative mortality
#- increasing duration of stay may increase cumulative mortality at the population level, 
# even if the individual survival is improved by the drug
# - The negative impact of increasing duration of stay is bigger if bed capacity is constrained
# Next steps:
# - eplore potential synergy between medications and increasing bed capacity (define synergy)
# - consider cost / benefit for investment in either therapeutics or beds

# Filter according to the know drug base line
# We have duration of stay and probability of surviving

####################################################################################

# toc_control <- cum_mortality_df %>%
#   filter(ps == .65, du == 28)
# 
# hypo_treat<- cum_mortality_df %>%
#   filter(ps == .8, du == 15)
# 
# the_comb <- rbind(toc_control, hypo_treat)
# 
# 
# (ggplot(the_comb)
#   + aes(x = cc, y = cm, color = as.character(du))
#   + geom_line()
#   #+ ylim(0, 1500)
#   + geom_line(aes(), size = 1)
#   + labs(x = "Number of beds"
#          , y = "Cumulative mortatlity"
#          , color = "Hospital duration (days)")
# )

