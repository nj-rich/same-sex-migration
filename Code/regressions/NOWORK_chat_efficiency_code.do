* Install outreg2 if not already installed
ssc install outreg2, replace

* Define paths to avoid repetition
local output_path "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\"

* Function for running the regression and saving results
macro define run_model(model_type, treatment_var, state_var, model_num) {
    reg migrant `treatment_var' i.`state_var'##i.year `state_var'##in_samesex i.year##in_samesex _I* age inctot [w=perwt], vce(cluster `state_var' year)
    outreg2 using "`output_path'`model_type'_model.tex", append tex(fragment) ctitle(Model `model_num') label dec(3) se keep(`treatment_var') addnote("See below.")
}

* Main Regression Loop
clear
use "C:\Users\njrich\Downloads\clean_dataframe.dta"

* Generate treatment variables
gen post_treatment = in_samesex * expost_old_legal * post_2015
gen ante_treatment = in_samesex * exante_old_legal * post_2015

* Collapse data by necessary variables
collapse (mean) _I* age inctot (rawsum) perwt [fweight = perwt], ///
    by(year migrant in_samesex expost_old_legal exante_old_legal expost_state exante_state post_2015 post_treatment ante_treatment

* Run models 1 and 2 (Ex-Post and Ex-Ante)
foreach model_num in 1 2 {
    * Ex-Post Model
    run_model("expost", post_treatment, expost_state, `model_num')
    * Ex-Ante Model
    run_model("exante", ante_treatment, exante_state, `model_num')
}

* Models 3 Inputs (Repeat the process for Model 3)
clear
use "C:\Users\njrich\Downloads\clean_dataframe.dta"

* Generate treatment variables for Model 3
gen post_treatment = in_samesex * expost_old_legal * post_2015
gen ante_treatment = in_samesex * exante_old_legal * post_2015

* Collapse data by additional variables for Model 3
collapse (mean) _I* age inctot (rawsum) perwt [fweight = perwt], ///
    by(year migrant in_samesex expost_old_legal exante_old_legal expost_state exante_state post_2015 post_treatment ante_treatment

* Run models 3 and 4 (Ex-Post and Ex-Ante)
foreach model_num in 3 4 {
    * Ex-Post Model
    run_model("expost", post_treatment, expost_state, `model_num')
    * Ex-Ante Model
    run_model("exante", ante_treatment, exante_state, `model_num')
}

*not perfect- ie still need to generate dummy variables and be careful with them, but very useful