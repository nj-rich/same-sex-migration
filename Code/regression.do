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

*base regressions
* ex post regression
reghdfe migrant in_samesex##expost_old_legal##post_2015 [w=perwt], ///
	absorb(expost_state year) ///
	vce(cluster expost_state year) 
	
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\expost_base_model.tex", ///
	replace ///
	tex(pretty) ///
	title(Ex-Post Model) ///
	ctitle(Ex-Post Model) ///
	label ///
	dec(3) ///
	se ///
	keep(1.in_samesex#1.expost_old_legal#1.post_2015) ///
	seeout

* 	rename(1.in_samesex#1.expost_old_legal#1.post_2015 "Same-Sex * Legal Before 2015 * Post 2015") ///
* worst comes to worst can relabel manually yay having access to files woop woop more automation would be great think about how many more terms to include/report
* neg means less moving to prior old legal states by individuals in same-sex post 2015



* ex ante regression
reghdfe migrant in_samesex##exante_old_legal##post_2015 [w=perwt], absorb(exante_state year) vce(cluster exante_state year)
*outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\exante_base_model.tex", replace tex 
* positive means more moving out of prior old legal states by individuals in same-sex post 2015

*test output
outreg2 using "C:\Users\njrich\Desktop\same-sex-migration\outputs\test.tex", replace tex title("Regression")




* q: F-tests? other tests?
* need intercept or ok dropped?
* hmm summary stats
* OI NEED FIGURE OUT CONNECT TO OVERLEAF IN NICE WAY AND MAKE PRETTY
*functionalize?
*oi really need to figure out how to automate pushes and pulls

* make dummies
xi i.sex

*regressions with some controls
* ex post
reghdfe migrant in_samesex##expost_old_legal##post_2015 _I* [w=perwt], absorb(expost_state year) vce(cluster expost_state year)