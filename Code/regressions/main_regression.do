/* */
pause off

*install export
ssc install outreg2, replace



///////////////////////// MAIN REGRESSIONS ////////////////////////////
///Models 1 and 2 inputs
clear
use "C:\Users\njrich\Downloads\clean_dataframe.dta" 
gen post_treatment = in_samesex*(1-expost_old_legal)*post_2015
gen ante_treatment = in_samesex*(1-exante_old_legal)*post_2015
xi i.sex i.race i.educ i.has_child
collapse (mean) _I* age inctot (rawsum) perwt [pweight = perwt], by(year migrant in_samesex expost_old_legal exante_old_legal expost_state exante_state post_2015 post_treatment ante_treatment)

//Model 1
*ex-post
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex [pw=perwt], ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\expost_model.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Post Model) ///
	ctitle(Model 1) ///
	label ///
	dec(3) ///
	se ///
	keep(post_treatment) ///
	addnote("See below.")
*ex-ante
reg migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex [pw=perwt], ///
	vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\exante_model.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Ante Model) ///
	ctitle(Model 1) ///
	label ///
	dec(3) ///
	se ///
	keep(ante_treatment) ///
	addnote("See below.")

//Model 2
*ex-post
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt], ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\expost_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 2) ///
	label ///
	dec(3) ///
	se ///
	keep(post_treatment) 
*ex-ante
reg migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt], ///
	vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\exante_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 2) ///
	label ///
	dec(3) ///
	se ///
	keep(ante_treatment) 

///Models 3 inputs
clear
use "C:\Users\njrich\Downloads\clean_dataframe.dta" 
gen post_treatment = in_samesex*(1-expost_old_legal)*post_2015
gen ante_treatment = in_samesex*(1-exante_old_legal)*post_2015
xi i.sex i.race i.educ i.has_child i.bpl
collapse (mean) _I* age inctot (rawsum) perwt [pweight = perwt], by(year migrant in_samesex expost_old_legal exante_old_legal expost_state exante_state post_2015 post_treatment ante_treatment)

//Model 3
*ex-post
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt], ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\expost_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 3) ///
	label ///
	dec(3) ///
	se ///
	keep(post_treatment) 
*ex-ante
reg migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt], ///
	vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\exante_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 3) ///
	label ///
	dec(3) ///
	se ///
	keep(ante_treatment) 
	
*end test regressions


*UM WHERE DID 2011 GO? DROPPED?
*why do my P values change so m
*doing things the ugly way time
*WATCH WEIGHTS
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
*watch square terms

*need have children control, occupation control, etc etc
*think how to make notes prettier
*watch updated formatting issues

**OK: in good spot, notes need some work works comes to worst can edit manually but feel half decent about things, MAYBE ADD CTITLES BACK OTHERWISE VARIABLES ANNOYING
*output adjusted R^2
*output adjusted R^2
*oi run all 3 models always
*oop how to use loops
*watch sex v gender
*watch typos
*add stat code: addstat(Adjusted R^2, e(r2_a), F-statistic, e(F)) /// 
*maybe get rid of dec(3) and se command see if it balances out, maybe it has to do with certain statistics not existing
*outreg 2 documentation disappeared lovely
*some errors seen frequently: note: 1bn.post_2015 is probably collinear with the fixed effects (all partialled-out values are close to zero; tol = 1.0e-09)
*Warning: VCV matrix was non-positive semi-definite; adjustment from Cameron, Gelbach & Miller applied.
*warning: missing F statistic; dropped variables due to collinearity or too few clusters
*WATCH WEIGHTS
