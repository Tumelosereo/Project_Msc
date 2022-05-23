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
	
	






