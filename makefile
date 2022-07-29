#R = Rscript $^ $@
#${R}
# $^ is dependencies
# $@ is targets


# Creating the funtions and saving as RData to be used.

./functions/functions.RData: ./scripts/functions.R 
	Rscript $^ $@

#### Creat the time series and the model outputs #####

# SARS_Cov_2

./data/sars_cov_2.RData: ./scripts/inputs.R ./data/sars_cov_2_par.xlsx ./data/sars_cov_2_baseline.xlsx
	Rscript $^ $@
	
./output/sars_cov_2_outputs.RData: ./scripts/run_model.R ./data/sars_cov_2.RData ./functions/functions.RData
	Rscript $^ $@
	
# Ebola

./data/ebola.RData: ./scripts/inputs.R ./data/ebola_par.xlsx ./data/ebola_baseline.xlsx
	Rscript $^ $@
	
./output/ebola_outputs.RData: ./scripts/run_model.R ./data/ebola.RData ./functions/functions.RData
	Rscript $^ $@
	
# SARS-Cov-2 figures 

./figs/sars_cov_2_plot.jpg: ./scripts/visual_plot.R ./output/sars_cov_2_outputs.RData
	Rscript $^ $@
	
# Ebola figures

./figs/ebola_plot.jpg: ./scripts/visual_plot.R ./output/ebola_outputs.RData
	Rscript $^ $@


###########################################################################################

# Cost analysis

# SARS-Cov-2 treatment

./data/cost_analysis.RData: ./scripts/beds_eq_treatment.R ./functions/functions.RData ./output/sars_cov_2_outputs.RData
	Rscript $^ $@
	
./output/my_data.RData: ./scripts/count.R ./data/cost_analysis.RData ./data/toci_treat.xlsx ./data/sars_cov_2.RData
	Rscript $^ $@
	
./figs/toci_cost.jpg: ./scripts/cost_benefit.R ./data/cost_analysis.RData ./output/my_data.RData
	Rscript $^ $@

# Ebola treatmet

./data/ebola_cost_analysis.RData: ./scripts/beds_eq_treatment.R ./functions/functions.RData ./output/ebola_outputs.RData
	Rscript $^ $@
	
./output/ebola_data_cost.RData: ./data/ebola_cost_analysis.RData ./data/zmapp.xlsx ./data/ebola.RData
	Rscript $^ $@




