/* */
pause off
clear

* Windows
 use "C:\Users\njrich\Downloads\F24_stata_analysis.dta" 

*Mac
*use "/Users/njrich/Desktop/Econ495/same-sex-migration/st_m.dta"

*install reghdfe
ssc install reghdfe, replace
ssc install ftools, replace
ssc install boottest, replace

*install export
ssc install outreg2, replace

* make dummies
xi i.sex


*base regressions
* ex post regression
reghdfe migrant in_samesex##expost_old_legal##post_2015 [w=perwt], absorb(expost_state year) vce(cluster expost_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\expost_base_model.tex", replace tex
* neg means less moving to prior old legal states by individuals in same-sex post 2015



* ex ante regression
reghdfe migrant in_samesex##exante_old_legal##post_2015 [w=perwt], absorb(exante_state year) vce(cluster exante_state year)
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\exante_base_model.tex", replace tex
* positive means more moving out of prior old legal states by individuals in same-sex post 2015

* q: F-tests? other tests?
* need intercept or ok dropped?
* hmm summary stats
* OI NEED FIGURE OUT CONNECT TO OVERLEAF IN NICE WAY AND MAKE PRETTY

*regressions with some controls
* ex post
reghdfe migrant in_samesex##expost_old_legal##post_2015 _I* [w=perwt], absorb(expost_state year) vce(cluster expost_state year)