.args <- if(interactive()){
  c("./data/ebola_ebanga.rds", 
    "./output/ebola_ebanga_data.RData",
    "./output/ebanga_costD.rds") # Outputs
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
            #, C_b = 10306.69
            #, C_a = 3179
)

x_value <- seq(0, 20, 0.1)

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

saveRDS(cost_df, file = target)


##########################################################

remde <- readRDS("./output/remde_costD.rds")
toci <- readRDS("./output/toci_costD.rds")

color1 <- c("remdesivir" = "red", "Tocilizimab" = "blue")

p1 <- (ggplot(remde) 
  + geom_line(aes(x = x_value, 
                y = cost_value,
                color = "remdesivir"),
              size = 1)
  
  + geom_line(data = toci,
            aes(x = x_value,
                y = cost_value,
                color = "Tocilizimab"),
            size = 1)
  
  + labs(x = bquote(C[B]/C[A]),
         y = bquote(C[T]/C[A]),
         color = "Treatments") 
  
  + scale_color_manual(values = color1)
  + theme_bw()
)

##############################################################

zmapp <- readRDS("./output/zmapp_costD.rds")
ebanga <- readRDS("./output/ebanga_costD.rds")

color2 <- c("ZMapp" = "brown", "Ebanga" = "orange")

p1 <- (ggplot(zmapp) 
       + geom_line(aes(x = x_value, 
                       y = cost_value,
                       color = "ZMapp"),
                   size = 1)
       
       + geom_line(data = ebanga,
                   aes(x = x_value,
                       y = cost_value,
                       color = "Ebanga"),
                   size = 1)
       
       + labs(x = bquote(C[B]/C[A]),
              y = bquote(C[T]/C[A]),
              color = "Treatments") 
       
       + scale_color_manual(values = color2)
       + theme_bw()
)








