# $^ is dependencies
# $@ is targets

./functions/functions.RData: ./scripts/functions.R 
	Rscript $^ $@
	
./data/sars_cov_2.RData: ./scripts/inputs.R ./data/sars_cov_2_par.xlsx ./data/sars_cov_2_baseline.xlsx
	Rscript $^ $@