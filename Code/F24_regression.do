/* */
pause off
clear

* Windows
 use "C:\Users\njrich\Downloads\F24_stata_analysis.dta" 

*Mac
*use "/Users/njrich/Desktop/Econ495/same-sex-migration/st_m.dta"


* regression
xi i.sex i.race i.educ i.occ i.ind i.bpl

reghdfe migrant in_samesex##old_legal##post_2015 _I* age inctot [w=perwt], absorb(state_name year) 
*add in cluster later, make clear what variables are continuous need?
