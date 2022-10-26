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
	
./data/sarscov2_remde.RData: ./scripts/inputs.R ./data/sars_cov_2_par.xlsx ./data/remde_treat.xlsx
	Rscript $^ $@
	
./output/sars_cov_2_outputs.RData: ./scripts/run_model.R ./data/sars_cov_2.RData ./functions/functions.RData
	Rscript $^ $@
	
./output/sarscov2_baseline_outputs.RData: ./scripts/baseline_output.R ./data/sars_cov_2.RData ./functions/functions.RData
	Rscript $^ $@

./output/sarscov2_remde_base_out.RData: ./scripts/baseline_output.R ./data/sarscov2_remde.RData ./functions/functions.RData 
	Rscript $^ $@
	
# Ebola

./data/ebola.RData: ./scripts/inputs.R ./data/ebola_par.xlsx ./data/zmapp_treat.xlsx
	Rscript $^ $@

./data/eboal_ebanga.RData: ./scripts/inputs.R ./data/ebola_par.xlsx ./data/ebanga_treat.xlsx
	Rscript $^ $@
	
./output/ebola_outputs.RData: ./scripts/run_model.R ./data/ebola.RData ./functions/functions.RData
	Rscript $^ $@
	
./output/ebola_baseline_outputs.RData: ./scripts/baseline_output.R ./data/ebola.RData ./functions/functions.RData
	Rscript $^ $@

./output/ebola_ebanga_base_out.RData: ./scripts/baseline_output.R ./data/eboal_ebanga.RData ./functions/functions.RData 
	Rscript $^ $@
	
# SARS-Cov-2 figures 

./figs/sars_cov_2_model.jpg: ./scripts/visual2.R ./output/sarscov2_baseline_outputs.RData
	Rscript $^ $@
	
./figs/sarscov2_remde_model.jpg: ./scripts/visual2.R ./output/sarscov2_remde_base_out.RData
	Rscript $^ $@

./figs/sars2_tocicm.jpg: ./scripts/visual_plot.R ./output/sars_cov_2_outputs.RData ./data/toci_treat.xlsx
	Rscript $^ $@
	
./figs/sars2_remdecm.jpg: ./scripts/visual_plot.R ./output/sars_cov_2_outputs.RData ./data/remde_treat.xlsx
	Rscript $^ $@	

	
# Ebola figures

./figs/ebola_model.jpg: ./scripts/visual2.R ./output/ebola_baseline_outputs.RData
	Rscript $^ $@

./figs/ebola_ebanga_model.jpg: ./scripts/visual2.R ./output/ebola_ebanga_base_out.RData
	Rscript $^ $@

./figs/ebola_zmappcm.jpg: ./scripts/visual_plot.R ./output/ebola_outputs.RData ./data/zmapp_treat.xlsx
	Rscript $^ $@

./figs/ebola_ebangacm.jpg: ./scripts/visual_plot.R ./output/ebola_outputs.RData ./data/ebanga_treat.xlsx
	Rscript $^ $@

###########################################################################################

# Cost analysis

##################### SARS-Cov-2 treatments ##################

# Tocilizimab treatment

./data/bed_scen.rds: ./scripts/beds_eq_treatment.R ./output/sars_cov_2_outputs.RData ./data/toci_treat.xlsx
	Rscript $^ $@
	
./output/my_data.RData: ./scripts/count.R ./functions/functions.RData ./data/sars_cov_2.RData ./data/bed_scen.rds ./data/toci_treat.xlsx 
	Rscript $^ $@
	
./figs/toci_cost.jpg: ./scripts/cost_benefit.R ./data/bed_scen.rds ./output/my_data.RData
	Rscript $^ $@

# Remdisivir treament

./data/sars2_remd.rds: ./scripts/beds_eq_treatment.R ./output/sars_cov_2_outputs.RData ./data/remde_treat.xlsx
	Rscript $^ $@
	
./output/sars2_remd_data.RData: ./scripts/count.R ./functions/functions.RData ./data/sars_cov_2.RData ./data/sars2_remd.rds ./data/remde_treat.xlsx
	Rscript $^ $@

./figs/remde_cost.jpg: ./scripts/cost_benefit.R ./data/sars2_remd.rds ./output/sars2_remd_data.RData
	Rscript $^ $@

##################### Ebola treatmets ########################

# Zmapp treatment

./data/ebola_cost_analysis.rds: ./scripts/beds_eq_treatment.R ./output/ebola_outputs.RData ./data/zmapp_treat.xlsx 
	Rscript $^ $@
	
./output/ebola_data_cost.RData: ./scripts/count.R ./functions/functions.RData ./data/ebola.RData ./data/ebola_cost_analysis.rds ./data/zmapp_treat.xlsx 
	Rscript $^ $@
	
./figs/zmapp.jpg: ./scripts/cost_benefit.R ./data/ebola_cost_analysis.rds ./output/ebola_data_cost.RData
	Rscript $^ $@

# Ebanga treatment 

./data/ebola_ebanga.rds: ./scripts/beds_eq_treatment.R ./output/ebola_outputs.RData ./data/ebanga_treat.xlsx
	Rscript $^ $@
	
./output/ebola_ebanga_data.RData: ./scripts/count.R ./functions/functions.RData ./data/ebola.RData ./data/ebola_ebanga.rds ./data/ebanga_treat.xlsx
	Rscript $^ $@
	
./figs/ebanga_cost.jpg: ./scripts/cost_benefit.R ./data/ebola_ebanga.rds ./output/ebola_ebanga_data.RData
	Rscript $^ $@

