/* This file uses code originally developed for 
"Did Unilateral Divorce Laws Raise Divorce Rates?  A Reconciliation and New Results"
by Justin Wolfers
and has been repurposed for a replication project of Noah Rich on Marcen and Morales's work on gay marriage legalization
*/
pause off
clear
set mem 50m
set matsize 400


* Windows
* use "C:\Users\njrich\Desktop\same-sex-migration\mm_gen.dta" 

*Mac
*use "/Users/njrich/Desktop/Econ495/same-sex-migration/st_m.dta"

*encode NAs to -99 so STATA processes NAs like Wolfers processes NAs
mvencode time_leg_chunked, mv(-99)

* basic specification (REGRESSION SPECIFIED) - WATCH YEAR CHANGE AS NEEDED
xi i.time_leg_chunked i.state_name i.YEAR
reg staterate_year _I* if YEAR>2000 & YEAR<2020 [w=state_pop] 
testparm _IYEAR_*
testparm _Istate_nam_*


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
