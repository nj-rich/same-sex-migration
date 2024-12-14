/* */
pause off
clear
set mem 50m
set matsize 400


* Windows
 use "C:\Users\njrich\Downloads\F24_stata_analysis.dta" 

*Mac
*use "/Users/njrich/Desktop/Econ495/same-sex-migration/st_m.dta"


* regression
xi i.year i.state_name i.sex i. race i.educ i.occ i.ind
reg migrated _I* [w=perwt] 
*watch weighing see IPUMS 
*testparm _IYEAR_*
*testparm _Istate_nam_*
*need to construct output var, interaction terms, think how interaction terms with i var work

xi i.time_leg_chunked i.state_name*time i.YEAR
reg staterate_year _I* if YEAR>2000 & YEAR<2016 [w=state_pop] 
testparm _IYEAR_*
testparm _Istate_nam_*
testparm _IstaXtime_*



xi i.time_leg_chunked i.state_name*time i.state_name*timesq i.YEAR 
reg staterate_year _I*  if YEAR>2000 & YEAR<2016 [w=state_pop] 
testparm _IYEAR_*
testparm _Istate_nam_*
testparm _IstaXtime_*
testparm _IstaXtimea*
