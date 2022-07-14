bed_scen <- readRDS("./data/cost_analysis.rds")

load("output/sars_cov_2_outputs.RData")

# Cost of treatment

inputs <- c(H = tail(treat_df, 1)[1],
            A_t = tail(treat_df, 1)[,2],
            A_b = tail(casual_df, 1)[1],
            delta.B = bed_scen$cc - 20)

x_value <- seq(0, 10, 0.1)

# To have a net cost benefit we assume Cost of treatment must be less than cost of beds.
# That is cost_tret > cost_beds. 
# Let C_b/C_a = variable Cba and 

cost_ba <- function(x, inputs) {
   with(as.list(inputs), {
     (A_b - A_t + delta.B * x) / H
   })
}

cost_value <-  cost_ba(x = x_value,
                     inputs = inputs)

cost_df <- data.frame(cost_value,
                 x_value)

(ggplot(cost_df) 
  + geom_line(aes(x = x_value, 
                 y = cost_value))
  + labs(x = "Cb/Ca",
       y = "Ct/Ca") 
)


