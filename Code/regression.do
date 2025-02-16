/* */
pause off
clear

* Windows
 use "C:\Users\njrich\Downloads\clean_dataframe.dta" 

*install reghdfe
ssc install reghdfe, replace
ssc install ftools, replace
ssc install boottest, replace

*install export
ssc install outreg2, replace
ssc install estout, replace

*add labels
label variable in_samesex "In Same-Sex Relationship"
label variable expost_old_legal "Destination: Legal Before 2015"
label variable exante_old_legal "Origin: Legal Before 2015"
label variable post_2015 "After 2015"
*need more later

///////////////////////// MAIN REGRESSIONS ////////////////////////////

*Models 1 (fixed effects only)
*ex-post model
* neg means less moving to prior old legal states by individuals in same-sex post 2015
reghdfe migrant in_samesex##expost_old_legal##post_2015 [w=perwt], ///
	absorb(expost_state year) ///
	vce(cluster expost_state year) 
	
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\expost_model.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Post Model) ///
	ctitle(Model 1) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.expost_old_legal#1.post_2015) ///
	addnote("See below.")
	
*ex-ante model
* positive means more moving out of prior old legal states by individuals in same-sex post 2015
reghdfe migrant in_samesex##exante_old_legal##post_2015 [w=perwt], absorb(exante_state year) vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\exante_model.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Ante Model) ///
	ctitle(Model 1) ///
	label ///
	dec(3) ///
	se 	///
	keep(1.in_samesex#1.exante_old_legal#1.post_2015)  ///
	addnote("See below.")

*Models 2 (controls for sex, race, educ, age, inctot, has_child)

*add dummy variables (excluding birthstate)
xi i.sex i.race i.educ i.has_child

* ex post regression
reghdfe migrant in_samesex##expost_old_legal##post_2015 _I* age inctot [weight = perwt], ///
	absorb(expost_state year) ///
	vce(cluster expost_state year) 
	
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\expost_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 2) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.expost_old_legal#1.post_2015) 

* ex ante regression
reghdfe migrant in_samesex##exante_old_legal##post_2015 _I* age inctot [weight = perwt], ///
	absorb(exante_state year) ///
	vce(cluster exante_state year) 
	
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\exante_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 2) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.exante_old_legal#1.post_2015) 

*Models 3 (controls for sex, race, educ, age, inctot, has_child, birth state)

*add birthstate dummy
xi i.bpl

*collapse variables for efficiency, serious concerns over expost and exante groupings if that will make any issues (still need to think about ind/occ, weighting)
collapse (mean) _I* age inctot (rawsum) perwt [fweight = perwt], by(year migrant in_samesex expost_old_legal exante_old_legal expost_state exante_state post_2015)

*weight testing still in progress
* ex post regression
reghdfe migrant in_samesex##expost_old_legal##post_2015 _I* age inctot [weight = perwt], ///
	absorb(expost_state year) ///
	vce(cluster expost_state year) 
	
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\expost_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 3) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.expost_old_legal#1.post_2015) 

* ex ante regression
reghdfe migrant in_samesex##exante_old_legal##post_2015 _I* age inctot [weight = perwt], ///
	absorb(exante_state year) ///
	vce(cluster exante_state year) 
	
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\exante_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 3) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.exante_old_legal#1.post_2015) 

	
	
	

///////////////////////// FLOW REGRESSIONS ////////////////////////////
	
clear
use "C:\Users\njrich\Downloads\clean_dataframe.dta" 

*ex-post frame
*local to local
reghdfe localtolocal_migrant in_samesex##expost_old_legal##post_2015 [w=perwt], ///
	absorb(expost_state year) ///
	vce(cluster expost_state year) 

outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\expost_dif_outcomes.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Post Model) ///
	ctitle(Local To Local) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.expost_old_legal#1.post_2015) ///
	addnote("Only has state and year fixed effects.")
	
*local to fed
reghdfe localtofed_migrant in_samesex##expost_old_legal##post_2015 [w=perwt], ///
	absorb(expost_state year) ///
	vce(cluster expost_state year) 

outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\expost_dif_outcomes.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Local To Federal) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.expost_old_legal#1.post_2015) 
	
*fed to local
reghdfe fedtolocal_migrant in_samesex##expost_old_legal##post_2015 [w=perwt], ///
	absorb(expost_state year) ///
	vce(cluster expost_state year) 

outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\expost_dif_outcomes.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Federal To Local) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.expost_old_legal#1.post_2015) 

*fed to fed
reghdfe fedtofed_migrant in_samesex##expost_old_legal##post_2015 [w=perwt], ///
	absorb(expost_state year) ///
	vce(cluster expost_state year) 

outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\expost_dif_outcomes.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Federal To Federal) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.expost_old_legal#1.post_2015) 
	
*ex-ante frame
*local to local
reghdfe localtolocal_migrant in_samesex##exante_old_legal##post_2015 [w=perwt], ///
	absorb(exante_state year) ///
	vce(cluster exante_state year) 

outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\exante_dif_outcomes.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Ante Model) ///
	ctitle(Local To Local) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.exante_old_legal#1.post_2015) ///
	addnote("Only has state and year fixed effects.")
	
*local to fed
reghdfe localtofed_migrant in_samesex##exante_old_legal##post_2015 [w=perwt], ///
	absorb(exante_state year) ///
	vce(cluster exante_state year) 

outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\exante_dif_outcomes.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Local To Federal) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.exante_old_legal#1.post_2015)
	
*fed to local
reghdfe fedtolocal_migrant in_samesex##exante_old_legal##post_2015 [w=perwt], ///
	absorb(exante_state year) ///
	vce(cluster exante_state year) 

outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\exante_dif_outcomes.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Federal To Local) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.exante_old_legal#1.post_2015)

*fed to fed
reghdfe fedtofed_migrant in_samesex##exante_old_legal##post_2015 [w=perwt], ///
	absorb(exante_state year) ///
	vce(cluster exante_state year) 

outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\exante_dif_outcomes.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Federal To Federal) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.exante_old_legal#1.post_2015)

	
	
///////////////////////// HET/SPLIT SAMPLE REGRESSIONS //////////////////////////// *ifs seem to work!
*gender
clear
use "C:\Users\njrich\Downloads\clean_dataframe.dta" 

*Models 1 (fixed effects only)
*ex-post model
*Men
reghdfe migrant in_samesex##expost_old_legal##post_2015 [w=perwt] if sex == 2, ///
	absorb(expost_state year) ///
	vce(cluster expost_state year) 
	
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\sex_expost_model.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Post Model) ///
	ctitle(Model 1: Men) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.expost_old_legal#1.post_2015) ///
	addstat(Adjusted R^2, e(r2_a), F-statistic, e(F)) ///
	addnote("See below.")
*Women
reghdfe migrant in_samesex##expost_old_legal##post_2015 [w=perwt] if sex == 1, ///
	absorb(expost_state year) ///
	vce(cluster expost_state year) 
	
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\sex_expost_model.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Post Model) ///
	ctitle(Model 1: Women) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.expost_old_legal#1.post_2015) ///
	addstat(Adjusted R^2, e(r2_a), F-statistic, e(F))

*ex-ante model
* positive means more moving out of prior old legal states by individuals in same-sex post 2015
reghdfe migrant in_samesex##exante_old_legal##post_2015 [w=perwt], absorb(exante_state year) vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\exante_model.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Ante Model) ///
	ctitle(Model 1) ///
	label ///
	dec(3) ///
	se 	///
	keep(1.in_samesex#1.exante_old_legal#1.post_2015)  ///
	addnote("See below.")

*Models 2 (controls for sex, race, educ, age, inctot, has_child)

*add dummy variables (excluding birthstate)
xi i.sex i.race i.educ i.has_child

* ex post regression
reghdfe migrant in_samesex##expost_old_legal##post_2015 _I* age inctot [weight = perwt], ///
	absorb(expost_state year) ///
	vce(cluster expost_state year) 
	
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\expost_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 2) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.expost_old_legal#1.post_2015) 

* ex ante regression
reghdfe migrant in_samesex##exante_old_legal##post_2015 _I* age inctot [weight = perwt], ///
	absorb(exante_state year) ///
	vce(cluster exante_state year) 
	
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\exante_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 2) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.exante_old_legal#1.post_2015) 

*Models 3 (controls for sex, race, educ, age, inctot, has_child, birth state)

*add birthstate dummy
xi i.bpl

*collapse variables for efficiency, serious concerns over expost and exante groupings if that will make any issues (still need to think about ind/occ, weighting)
collapse (mean) _I* age inctot (rawsum) perwt [fweight = perwt], by(year migrant in_samesex expost_old_legal exante_old_legal expost_state exante_state post_2015)

*weight testing still in progress
* ex post regression
reghdfe migrant in_samesex##expost_old_legal##post_2015 _I* age inctot [weight = perwt], ///
	absorb(expost_state year) ///
	vce(cluster expost_state year) 
	
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\expost_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 3) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.expost_old_legal#1.post_2015) 

* ex ante regression
reghdfe migrant in_samesex##exante_old_legal##post_2015 _I* age inctot [weight = perwt], ///
	absorb(exante_state year) ///
	vce(cluster exante_state year) 
	
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\exante_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 3) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.exante_old_legal#1.post_2015) 	

* q: F-tests? other tests?
* need intercept or ok dropped?
* hmm summary stats
* OI NEED FIGURE OUT CONNECT TO OVERLEAF IN NICE WAY AND MAKE PRETTY
*functionalize?
*oi really need to figure out how to automate pushes and pulls
*watch best protocol on commenting in STATA
*other variations of the model: census data, with household/children, segmented
* likely have to do some manual relabeling yay having access to files woop woop more automation would be great think about how many more terms to include/report
*functionalize?
* keep thinking distance how to include
*watch how I organize code to run most efficiently and accurately
*other tests to include?
*think about best way to convey information what is/is not in each model, how much can do in STATA v manual/categories maybe
*watch tell STATA what type of weights to use- check IPUMS documentation
*watch many large rooms for error due to duplication and lack of functionalization
* OH MY GOD COLLAPSE HAS SERIOUS WEIGHTING ISSUES- HAVE TO THINK ABOUT NEW WEIGHTS POST COLLAPSING NOT QUITE SURE HOW TO PROCEED- sum perwt and then use that as a weight in the regression maybe
*keep function keeps break, very frustrated

*need have children control, occupation control, etc etc
*think how to make notes prettier
*watch updated formatting issues

**OK: in good spot, notes need some work works comes to worst can edit manually but feel half decent about things, MAYBE ADD CTITLES BACK OTHERWISE VARIABLES ANNOYING
*output adjusted R^2
*output adjusted R^2
*oi run all 3 models always