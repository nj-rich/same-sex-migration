/* */
pause off

*install export
ssc install outreg2, replace



///////////////////////// REGION REGRESSIONS ////////////////////////////
*Midwest/South of interest (West/Northeast all legal before 2015)
////Models 1 and 2 inputs
clear
use "C:\Users\njrich\Downloads\clean_dataframe.dta" 
gen post_treatment = in_samesex*(1-expost_old_legal)*post_2015
gen ante_treatment = in_samesex*(1-exante_old_legal)*post_2015
xi i.race i.educ i.has_child i.sex
collapse (mean) _I* age inctot (rawsum) perwt [pweight = perwt], by(year migrant in_samesex expost_old_legal exante_old_legal expost_state exante_state post_2015 post_treatment ante_treatment expost_region exante_region)

///Model 1
//ex-post
*South
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex [pw=perwt] if expost_region == 1, ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\south_expost_model.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Post Model: South) ///
	ctitle(Model 1) ///
	label ///
	dec(3) ///
	se ///
	keep(post_treatment) ///
	addnote("See below.")
*West
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex [pw=perwt] if expost_region == 2, ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\west_expost_model.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Post Model: West) ///
	ctitle(Model 1) ///
	label ///
	dec(3) ///
	se ///
	keep(post_treatment)
*Northeast
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex [pw=perwt] if expost_region == 3, ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\northeast_expost_model.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Post Model: Northeast) ///
	ctitle(Model 1) ///
	label ///
	dec(3) ///
	se ///
	keep(post_treatment)
*Midwest
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex [pw=perwt] if expost_region == 4, ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\midwest_expost_model.tex", ///
	replace ///
	title(Ex-Post Model: Midwest) ///
	tex(fragment) ///
	ctitle(Model 1) ///
	label ///
	dec(3) ///
	se ///
	keep(post_treatment)
//ex-ante
*South
reg migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex [pw=perwt] if exante_region == 1, ///
	vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\south_exante_model.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Ante Model: South) ///
	ctitle(Model 1) ///
	label ///
	dec(3) ///
	se ///
	keep(ante_treatment) ///
	addnote("See below.")
*Midwest
reg migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex [pw=perwt] if exante_region == 2, ///
	vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\midwest_exante_model.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Ante Model: Midwest) ///
	ctitle(Model 1) ///
	label ///
	dec(3) ///
	se ///
	keep(ante_treatment) 
*West
reg migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex [pw=perwt] if exante_region == 3, ///
	vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\west_exante_model.tex", ///
	replace ///
	tex(fragment) ///
	title(Ex-Ante Model: West) ///
	ctitle(Model 1) ///
	label ///
	dec(3) ///
	se ///
	keep(ante_treatment) 
*Northeast
reg migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex [pw=perwt] if exante_region == 4, ///
	vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\northeast_exante_model.tex", ///
	replace ///
	tex(fragment) ///
	ctitle(Model 1) ///
	label ///
	dec(3) ///
	se ///
	keep(ante_treatment) 
///Model 2
//ex-post
*South
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt] if expost_region == 1, ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\south_expost_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 2) ///
	label ///
	dec(3) ///
	se ///
	keep(post_treatment) 
*West
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt] if expost_region == 2, ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\west_expost_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 2) ///
	label ///
	dec(3) ///
	se ///
	keep(post_treatment) 
*Northeast
	reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt] if expost_region == 3, ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\northeast_expost_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 2) ///
	label ///
	dec(3) ///
	se ///
	keep(post_treatment) 
*Midwest
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt] if expost_region == 4, ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\midwest_expost_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 2) ///
	label ///
	dec(3) ///
	se ///
	keep(post_treatment) 
//ex-ante
*South
reg migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt] if exante_region == 1, ///
	vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\south_exante_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 2) ///
	label ///
	dec(3) ///
	se ///
	keep(ante_treatment) 
*Midwest
reg migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt] if exante_region == 2, ///
	vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\midwest_exante_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 2) ///
	label ///
	dec(3) ///
	se ///
	keep(ante_treatment) 
*West
reg migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt] if exante_region == 1, ///
	vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\west_exante_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 2) ///
	label ///
	dec(3) ///
	se ///
	keep(ante_treatment) 
*Northeast
reg migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt] if exante_region == 2, ///
	vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\northeast_exante_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 2) ///
	label ///
	dec(3) ///
	se ///
	keep(ante_treatment) 
	
////Models 3 inputs
clear
use "C:\Users\njrich\Downloads\clean_dataframe.dta" 
gen post_treatment = in_samesex*(1-expost_old_legal)*post_2015
gen ante_treatment = in_samesex*(1-exante_old_legal)*post_2015
xi i.race i.educ i.has_child i.sex i.bpl
collapse (mean) _I* age inctot (rawsum) perwt [pweight = perwt], by(year migrant in_samesex expost_old_legal exante_old_legal expost_state exante_state post_2015 post_treatment ante_treatment exante_region expost_region)

///Model 3
//ex-post
*South
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt] if expost_region == 1, ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\south_expost_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 3) ///
	label ///
	dec(3) ///
	se ///
	keep(post_treatment) 
*West
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt] if expost_region == 2, ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\west_expost_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 3) ///
	label ///
	dec(3) ///
	se ///
	keep(post_treatment) 
*Northeast
	reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt] if expost_region == 3, ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\northeast_expost_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 3) ///
	label ///
	dec(3) ///
	se ///
	keep(post_treatment) 
*Midwest
reg migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt] if expost_region == 4, ///
	vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\midwest_expost_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 3) ///
	label ///
	dec(3) ///
	se ///
	keep(post_treatment) 
//ex-ante
*South
reg migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt] if exante_region == 1, ///
	vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\south_exante_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 3) ///
	label ///
	dec(3) ///
	se ///
	keep(ante_treatment) 
*Midwest
reg migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt] if exante_region == 2, ///
	vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\midwest_exante_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 3) ///
	label ///
	dec(3) ///
	se ///
	keep(ante_treatment) 
*West
reg migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt] if exante_region == 1, ///
	vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\west_exante_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 3) ///
	label ///
	dec(3) ///
	se ///
	keep(ante_treatment) 
*Northeast
reg migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex _I* age inctot [pw=perwt] if exante_region == 2, ///
	vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\northeast_exante_model.tex", ///
	append ///
	tex(fragment) ///
	ctitle(Model 3) ///
	label ///
	dec(3) ///
	se ///
	keep(ante_treatment) 
*use label list var to generate which labels go with what factors