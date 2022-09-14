.args <- if(interactive()){
  c("./data/bed_scen.rds", 
    "./output/my_data.RData",
    "./figs/toci_cost.jpg") # Outputs
}else{
  commandArgs(trailingOnly = TRUE)
}

library(ggplot2)

target <- tail(.args, 1)

bed_scen <- readRDS(.args[[1]])

load(.args[[2]])

# Cost of treatment

inputs <- c(H = tail(treat_df$CA, 1)
            , A_t = tail(treat_df$cum_add_days, 1)
            , A_b = tail(casual_df$cum_add_days, 1)
            , delta.B = bed_scen$cc - 20
            , C_b = 10306.69
            , C_a = 3179
            )

x_value <- seq(0, 20, 0.1)

# To have a net cost benefit we assume Cost of treatment must be less than cost of beds.
# That is cost_tret > cost_beds. 
# Let C_b/C_a = variable Cba and 

cost_ba <- function(x, inputs) {
   with(as.list(inputs), {
     #((A_b - A_t + delta.B * (C_b/C_a)) / H)*C_a
     (A_b - A_t + delta.B * x) / H
   })
}

print({
  with(as.list(inputs), {
    ((A_b - A_t + delta.B * (C_b/C_a)) / H)*C_a
  })
})

cost_value <-  cost_ba(x = x_value,
                     inputs = inputs)

cost_df <- data.frame(cost_value,
                 x_value)

plot3 <- (ggplot(cost_df) 
  + geom_line(aes(x = x_value, 
                 y = cost_value))
  + labs(x = bquote(C[B]/C[A]),
       y = bquote(C[T]/C[A])) 
  + theme_bw()
  #+ ylim(c(5, 7))
)

if(dir.exists("./figs")){
  ggsave(filename = target,
         plot = plot3,
         width = 8.51,
         height = 5.67,
         units = "in")
  
}else{
  dir.create("./figs")
  ggsave(filename = target,
         plot = plot3,
         width = 8.51,
         height = 5.67,
         units = "in")
}

