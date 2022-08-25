# R = Rscript $^ $@
# ${R}
# $^ is dependencies
# $@ is targets


# Creating the funtions and saving as RData to be used.

./functions/functions.RData: ./scripts/functions.R 
	Rscript $^ $@

#### Creat the time series and the model outputs #####

# SARS_Cov_2

./data/sars_cov_2.RData: ./scripts/inputs.R ./data/sars_cov_2_par.xlsx ./data/toci_treat.xlsx
	Rscript $^ $@
	
./output/sars_cov_2_outputs.RData: ./scripts/run_model.R ./data/sars_cov_2.RData ./functions/functions.RData
	Rscript $^ $@
	
# Ebola

./data/ebola.RData: ./scripts/inputs.R ./data/ebola_par.xlsx ./data/zmapp_treat.xlsx
	Rscript $^ $@
	
./output/ebola_outputs.RData: ./scripts/run_model.R ./data/ebola.RData ./functions/functions.RData
	Rscript $^ $@
	
# SARS_Cov_1

./data/sars_cov_1.RData: ./scripts/inputs.R ./data/sars_cov_1_par.xlsx ./data/sars_cov1_wt.xlsx
	Rscript $^ $@
	
./output/sars_cov_1_outputs.RData: ./scripts/run_model.R ./data/sars_cov_1.RData ./functions/functions.RData
	Rscript $^ $@

	
# SARS-Cov-2 figures 

./figs/sars_cov_2_model.jpg: ./scripts/visual2.R ./output/sars_cov_2_outputs.RData
	Rscript $^ $@

./figs/sars_cov_2_plot.jpg: ./scripts/visual_plot.R ./output/sars_cov_2_outputs.RData
	Rscript $^ $@
	
# SARS-CoV-1 figures

./figs/sars_cov_1_model.jpg: ./scripts/visual2.R ./output/sars_cov_1_outputs.RData
	Rscript $^ $@
	
# Ebola figures

./figs/ebola_model.jpg: ./scripts/visual2.R ./output/ebola_outputs.RData
	Rscript $^ $@

./figs/ebola_plot.jpg: ./scripts/visual_plot.R ./output/ebola_outputs.RData
	Rscript $^ $@


###########################################################################################

# Cost analysis

##################### SARS-Cov-2 treatment ##################

# Tocilizimab treatment

./data/bed_scen.rds: ./scripts/beds_eq_treatment.R ./output/sars_cov_2_outputs.RData ./data/toci_treat.xlsx
	Rscript $^ $@
	
./output/my_data.RData: ./scripts/count.R ./functions/functions.RData ./data/sars_cov_2.RData ./data/bed_scen.rds ./data/toci_treat.xlsx 
	Rscript $^ $@
	
./figs/toci_cost.jpg: ./scripts/cost_benefit.R ./data/bed_scen.rds ./output/my_data.RData
	Rscript $^ $@

# Remdisivir treament


##################### Ebola treatmet ########################

# Zmapp treatment

./data/ebola_cost_analysis.rds: ./scripts/beds_eq_treatment.R ./output/ebola_outputs.RData ./data/zmapp_treat.xlsx 
	Rscript $^ $@
	
./output/ebola_data_cost.RData: ./scripts/count.R ./functions/functions.RData ./data/ebola.RData ./data/ebola_cost_analysis.rds ./data/zmapp_treat.xlsx 
	Rscript $^ $@
	
./figs/zmapp.jpg: ./scripts/cost_benefit.R ./data/ebola_cost_analysis.rds ./output/ebola_data_cost.RData
	Rscript $^ $@



