#R = Rscript $^ $@
#${R}
# $^ is dependencies
# $@ is targets


# Creating the funtions and saving as RData that to be used.

./functions/functions.RData: ./scripts/functions.R 
	Rscript $^ $@

# Creat the time series and the model outputs	

./data/sars_cov_2.RData: ./scripts/inputs.R ./data/sars_cov_2_par.xlsx ./data/sars_cov_2_baseline.xlsx
	Rscript $^ $@
	
./output/sars_cov_2_outputs.rds: ./scripts/run_model.R ./data/sars_cov_2.RData ./functions/functions.RData
	Rscript $^ $@
	
# Plots

./figs/sars_cov_2_out.png: ./scripts/visual_plot.R ./output/sars_cov_2_cm_outputs.RData
	Rscript $^ $@
	
	






