/* */
pause off

*install export
ssc install outreg2, replace


*NOTE: MODIFIED OLD_LEGAL FRAME BASED ON MS FEEDBACK/POP SUPPORT SPEC. NEEDS- think if want to go back through any other regressions to update treatment var
///////////////////////// POP SUPPORT REGRESSIONS ////////////////////////////
*normalize + take opposite of pop. support (anti support) for effects to line up to aggravate expected results (be careful naming conventions) (ADJUSTED)
///Models 1 and 2 inputs
clear
use "C:\Users\njrich\Downloads\clean_dataframe.dta" 
gen post_treatment = (.01*expost_support)*in_samesex*(1-expost_old_legal)*post_2015 
gen ante_treatment = (.01*exante_support)*in_samesex*(1-exante_old_legal)*post_2015
xi i.sex i.race i.educ i.has_child
collapse (mean) _I* age inctot (rawsum) perwt [pweight = perwt], by(year migrant in_samesex expost_old_legal exante_old_legal expost_state exante_state post_2015 post_treatment ante_treatment)

//Model 1
*ex-post
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex [pw=perwt], ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\popsupport_expost_model.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Post Model - Anti Popular Support) ///
	ctitle(Model 1) ///
	label ///
	dec(3) ///
	se ///
	keep(post_treatment) ///
	addnote("See below.")
*ex-ante
reg migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex [pw=perwt], ///
	vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\popsupport_exante_model.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Ante Model - Anti Popular Support) ///
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
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\popsupport_expost_model.tex", ///
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
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\popsupport_exante_model.tex", ///
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
gen post_treatment = (.01*expost_support)*in_samesex*(1-expost_old_legal)*post_2015 
gen ante_treatment = (.01*exante_support)*in_samesex*(1-exante_old_legal)*post_2015
xi i.sex i.race i.educ i.has_child i.bpl
collapse (mean) _I* age inctot (rawsum) perwt [pweight = perwt], by(year migrant in_samesex expost_old_legal exante_old_legal expost_state exante_state post_2015 post_treatment ante_treatment)

//Model 3
*ex-post
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt], ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\popsupport_expost_model.tex", ///
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
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\popsupport_exante_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 3) ///
	label ///
	dec(3) ///
	se ///
	keep(ante_treatment) 
	
*WATCH WEIGHTS
