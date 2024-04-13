/* This file uses code originally developed for 
"Did Unilateral Divorce Laws Raise Divorce Rates?  A Reconciliation and New Results"
by Justin Wolfers
and has been repurposed for a replication project of Noah Rich on Marcen and Morales's work on gay marriage legalization
*/
pause off
clear
set mem 50m
set matsize 400

use "C:\Users\njrich\Desktop\same-sex-migration\cleaned_data.dta"

*encode NAs to -99 so STATA processes NAs like Wolfers processes NAs
mvencode time_leg_chunked, mv(-99)

* basic specification (will add other regressions back eventually)
xi i.time_leg_chunked i.state_name i.YEAR
reg staterate_year _I* if YEAR>2000 & YEAR<2016 [w=state_pop] 
testparm _IYEAR_*
testparm _Istate_nam_*

***issue: my results not lining up with Marcen and Morales's perfectly, check gay coding right, negative coefficients?
