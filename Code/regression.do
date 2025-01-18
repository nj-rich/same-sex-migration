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

*Models 1 (fixed effects only)
*ex-post model
* neg means less moving to prior old legal states by individuals in same-sex post 2015
reghdfe migrant in_samesex##expost_old_legal##post_2015 [w=perwt], ///
	absorb(expost_state year) ///
	vce(cluster expost_state year) 
	
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\expost_model.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Post Model) ///
	ctitle(Model 1) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.expost_old_legal#1.post_2015) ///
	addnote("Model 1 includes interaction terms and fixed effects only. Model 2 includes interaction terms, fixed effects, and controls for sex, race, education, age and income. Model 3 includes interaction terms, fixed effects, and controls for sex, race, education, age, income, and birthstate. Models 1 and 2 use a weighted sample. Model 3 uses a weighted and collapsed sample.")
	
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
	addnote("Model 1 includes interaction terms and fixed effects only. Model 2 includes interaction terms, fixed effects, and controls for sex, race, education, age and income. Model 3 includes interaction terms, fixed effects, and controls for sex, race, education, age, income, and birthstate. Models 1 and 2 use a weighted sample. Model 3 uses a weighted and collapsed sample.")


*Models 2 (controls for sex, race, educ, age, inctot)

*add dummy variables (excluding birthstate)
xi i.sex i.race i.educ

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

*Models 3 (controls for sex, race, educ, age, inctot, birth state)

*add dummy variables (excluding birthstate)
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