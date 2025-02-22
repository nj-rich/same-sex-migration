/* */
pause off

*install export
ssc install outreg2, replace



///////////////////////// FLOW REGRESSIONS ////////////////////////////

*rip functions

////Models 1 and 2 inputs
clear
use "C:\Users\njrich\Downloads\clean_dataframe.dta"

gen post_treatment = in_samesex * expost_old_legal * post_2015
gen ante_treatment = in_samesex * exante_old_legal * post_2015
gen stay = 1 - migrant

xi i.sex i.race i.educ i.has_child
collapse (mean) _I* age inctot (rawsum) perwt [fweight = perwt], by(year stay tofed_migrant fromfed_migrant tolocal_migrant fromlocal_migrant in_samesex expost_old_legal exante_old_legal expost_state exante_state post_2015 post_treatment ante_treatment)

///Model 1
//Post
*from fed (of interest)
reg fromfed_migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex [w=perwt], vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_expost_model.tex", replace tex(fragment) ctitle(M1: From Fed/Not) label dec(3) se keep(post_treatment) addnote("See below.")

*from local
reg fromlocal_migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex [w=perwt], vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_expost_model.tex", append tex(fragment) ctitle(M1: From Local) label dec(3) se keep(post_treatment)
*from stay
reg stay post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex [w=perwt], vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_expost_model.tex", append tex(fragment) ctitle(M1: Stay) label dec(3) se keep(post_treatment)
//Ante
*to fed (of interest)
reg tofed_migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex [w=perwt], vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_exante_model.tex", replace tex(fragment) ctitle(M1: To Fed/Not) label dec(3) se keep(ante_treatment) addnote("See below.")
*to local
reg tolocal_migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex [w=perwt], vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_exante_model.tex", append tex(fragment) ctitle(M1: To Local) label dec(3) se keep(ante_treatment)
*to stay
reg stay ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex [w=perwt], vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_exante_model.tex", append tex(fragment) ctitle(M1: Stay) label dec(3) se keep(ante_treatment)

///Model 2
//Post
*from fed (of interest)
reg fromfed_migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [w=perwt], vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_expost_model.tex", append tex(fragment) ctitle(M2: From Fed/Not) label dec(3) se keep(post_treatment)

*from local
reg fromlocal_migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [w=perwt], vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_expost_model.tex", append tex(fragment) ctitle(M2: From Local) label dec(3) se keep(post_treatment)
*from stay
reg stay post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [w=perwt], vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_expost_model.tex", append tex(fragment) ctitle(M2: Stay) label dec(3) se keep(post_treatment)
//Ante
*to fed (of interest)
reg tofed_migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex _I* age inctot [w=perwt], vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_exante_model.tex", append tex(fragment) ctitle(M2: To Fed/Not) label dec(3) se keep(ante_treatment)
*to local
reg tolocal_migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex _I* age inctot [w=perwt], vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_exante_model.tex", append tex(fragment) ctitle(M2: To Local) label dec(3) se keep(ante_treatment)
*to stay
reg stay ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex _I* age inctot [w=perwt], vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_exante_model.tex", append tex(fragment) ctitle(M2: Stay) label dec(3) se keep(ante_treatment)

////Models 3 inputs
clear
use "C:\Users\njrich\Downloads\clean_dataframe.dta"

gen post_treatment = in_samesex * expost_old_legal * post_2015
gen ante_treatment = in_samesex * exante_old_legal * post_2015
gen stay = 1 - migrant

xi i.sex i.race i.educ i.has_child i.bpl
collapse (mean) _I* age inctot (rawsum) perwt [fweight = perwt], by(year stay tofed_migrant fromfed_migrant tolocal_migrant fromlocal_migrant in_samesex expost_old_legal exante_old_legal expost_state exante_state post_2015 post_treatment ante_treatment)

///Model 2
//Post
*from fed (of interest)
reg fromfed_migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [w=perwt], vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_expost_model.tex", append tex(fragment) ctitle(M3: From Fed/Not) label dec(3) se keep(post_treatment)

*from local
reg fromlocal_migrant post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [w=perwt], vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_expost_model.tex", append tex(fragment) ctitle(M3: From Local) label dec(3) se keep(post_treatment)
*from stay
reg stay post_treatment i.expost_state##i.year expost_state##in_samesex i.year##in_samesex _I* age inctot [w=perwt], vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_expost_model.tex", append tex(fragment) ctitle(M3: Stay) label dec(3) se keep(post_treatment)
//Ante
*to fed (of interest)
reg tofed_migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex _I* age inctot [w=perwt], vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_exante_model.tex", append tex(fragment) ctitle(M3: To Fed/Not) label dec(3) se keep(ante_treatment)
*to local
reg tolocal_migrant ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex _I* age inctot [w=perwt], vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_exante_model.tex", append tex(fragment) ctitle(M3: To Local) label dec(3) se keep(ante_treatment)
*to stay
reg stay ante_treatment i.exante_state##i.year exante_state##in_samesex i.year##in_samesex _I* age inctot [w=perwt], vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\regressions\flow_exante_model.tex", append tex(fragment) ctitle(M3: Stay) label dec(3) se keep(ante_treatment)
	
	
*WATCH CODE FOR ERRORS