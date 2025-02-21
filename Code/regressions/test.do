/* */
pause off
clear

* Windows
 use "C:\Users\njrich\Downloads\clean_dataframe.dta" 

*install reghdfe *maybe no need anymore
ssc install reghdfe, replace
ssc install ftools, replace
ssc install boottest, replace

*install export
ssc install outreg2, replace
ssc install estout, replace

*add labels (maybe can delete)
*label variable in_samesex "In Same-Sex Relationship"
*label variable expost_old_legal "Destination: Legal Before 2015"
*label variable exante_old_legal "Origin: Legal Before 2015"
*label variable post_2015 "After 2015"
*need more later

gen post_treatment = in_samesex*expost_old_legal*post_2015
gen ante_treatment = in_samesex*exante_old_legal*post_2015
xi i.sex i.race i.educ i.has_child i.bpl
collapse (mean) _I* age inctot (rawsum) perwt [fweight = perwt], by(year migrant in_samesex expost_old_legal exante_old_legal expost_state exante_state post_2015 post_treatment ante_treatment) // watch this is getting a bit long

///////////////////////// MAIN REGRESSIONS ////////////////////////////
*test regressions... drop specification 2?
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex [w=perwt], ///
	vce(cluster expost_state year)

reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _Isex _Irace _Ieduc _has_child age inctot [w=perwt], ///
	vce(cluster expost_state year)
	
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [w=perwt], ///
	vce(cluster expost_state year)
	
*end test regressions


*Models 1 (fixed effects only)
*ex-post model
* neg means less moving to prior old legal states by individuals in same-sex post 2015
reg migrant treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex [w=perwt], ///
	vce(cluster expost_state year) 

*need to update this now, can maybe avoid having to recollapse and just update regressions (even if have to update outregs)
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

///Mueller-Smith see
gen treatment = in_samesex*exante_old_legal*post_2015
reg migrant treatment  i.in_samesex##i.exante_state i.in_samesex##i.year i.exante_state##i.year [w=perwt], vce(cluster exante_state year)

///
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

*UM WHERE DID 2011 GO? DROPPED?
*why do my P values change so m