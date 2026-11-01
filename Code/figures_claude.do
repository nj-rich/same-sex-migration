* figures.do
* Summary tables and figures for the Obergefell migration paper.
*
* Input: the analysis file built by build_base.do (plus the state support
* variable expost_support, if you merge it in). Variables are expected in their
* raw IPUMS codes: sex 1 = male, 2 = female; educ 10 = 4 years of college;
* race 1 = white; regions 1 = Northeast, 2 = Midwest, 3 = South, 4 = West.
*
* Requires Stata 17 or later (for table / collect export).

clear all
set more off
set scheme stcolor


* ---------------------------------------------------------------
* Step 1: Paths
* ---------------------------------------------------------------
global data_path "/home/rcenjr01/same-sex-migration/data/"


global data    "$data_path/database_df.dta"
global ma_data "$data_path/MA_base_df.dta"
global tables  "/home/rcenjr01/same-sex-migration/outputs/summary_stats"
global figs    "/home/rcenjr01/same-sex-migration/outputs/summary_stats"


* ---------------------------------------------------------------
* Step 2: Load data and make the variables used below
* ---------------------------------------------------------------
use "$data", clear

* 1 = state got marriage equality from Obergefell (or had none yet, before 2015)
gen oberg_now  = 1 - expost_old_legal     // current state
gen oberg_past = 1 - exante_old_legal     // state lived in last year

* Percent versions (0/100) for the summary tables
gen pct_samesex = 100 * in_samesex
gen pct_oberg   = 100 * oberg_now
gen pct_migrate = 100 * migrant
gen pct_female  = 100 * (sex == 2)
gen pct_child   = 100 * has_child
gen pct_college = 100 * (educ >= 10)
gen pct_white   = 100 * (race == 1)

gen pct_northeast = 100 * (expost_region == 1)
gen pct_midwest   = 100 * (expost_region == 2)
gen pct_south     = 100 * (expost_region == 3)
gen pct_west      = 100 * (expost_region == 4)

* Groups for the heterogeneity charts
gen female = (sex == 2)
label define female_lbl 0 "Men" 1 "Women"
label values female female_lbl

gen college = (educ >= 10)
label define college_lbl 0 "Less than 4 years college" 1 "4+ years college"
label values college college_lbl

label define child_lbl 0 "No children" 1 "Children present"
label values has_child child_lbl

gen age_group = 1 if age < 23
replace age_group = 2 if age >= 23 & age < 33
replace age_group = 3 if age >= 33 & age < 63
replace age_group = 4 if age >= 63
label define age_lbl 1 "Under 23" 2 "23-32" 3 "33-62" 4 "63+"
label values age_group age_lbl

* Above/below the weighted mean income for each year
gen wt_income = perwt * inctot
bysort year: egen sum_wt_income = total(wt_income)
bysort year: egen sum_wt = total(perwt * (inctot < .))
gen mean_income = sum_wt_income / sum_wt
gen high_income = (inctot >= mean_income) if inctot < .
label define income_lbl 0 "Below mean income" 1 "Above mean income"
label values high_income income_lbl

label define region_lbl 1 "Northeast" 2 "Midwest" 3 "South" 4 "West", replace
label values expost_region exante_region region_lbl

save "$tables/figures_working.dta", replace


* ---------------------------------------------------------------
* Step 3: Summary tables (LaTeX)
* ---------------------------------------------------------------

* Overall population: % same-sex by year
table year [aw = perwt], statistic(mean pct_samesex) nformat(%3.0f) nototals
collect export "$tables/overall_table_a.tex", replace tableonly

* Overall population: % living in Obergefell states, by relationship type
table year in_samesex [aw = perwt], statistic(mean pct_oberg) nformat(%3.0f) nototals
collect export "$tables/overall_table_b.tex", replace tableonly

* Main variables (1): % migrate, % female, % with child
table year in_samesex [aw = perwt], ///
    statistic(mean pct_migrate pct_female pct_child) nformat(%3.0f) nototals
collect layout (year) (var#in_samesex)
collect export "$tables/var_table_1.tex", replace tableonly

* Main variables (2): mean age, % college, % white, mean income
table year in_samesex [aw = perwt], ///
    statistic(mean age pct_college pct_white inctot) nformat(%9.0fc) nototals
collect layout (year) (var#in_samesex)
collect export "$tables/var_table_2.tex", replace tableonly

* Regions (1): Midwest and South
table year in_samesex [aw = perwt], ///
    statistic(mean pct_midwest pct_south) nformat(%3.0f) nototals
collect layout (year) (var#in_samesex)
collect export "$tables/regions_1.tex", replace tableonly

* Regions (2): West and Northeast
table year in_samesex [aw = perwt], ///
    statistic(mean pct_west pct_northeast) nformat(%3.0f) nototals
collect layout (year) (var#in_samesex)
collect export "$tables/regions_2.tex", replace tableonly


* ---------------------------------------------------------------
* Step 4: Main difference charts
* Line = migration rate in Obergefell states minus other states,
* separately for same-sex and different-sex partners.
* ---------------------------------------------------------------

* Pull factor: grouped by CURRENT state
use "$tables/figures_working.dta", clear
collapse (mean) migrant [pw = perwt], by(year in_samesex oberg_now)
reshape wide migrant, i(year in_samesex) j(oberg_now)
gen diff = migrant1 - migrant0

twoway (line diff year if in_samesex == 1) ///
       (line diff year if in_samesex == 0, lpattern(dash)), ///
       xline(2015, lpattern(dot)) xlabel(2011(1)2019) ///
       title("Pull factor") xtitle("Year") ///
       ytitle("Migration rate, Obergefell minus other states") ///
       legend(order(1 "Same-sex partners" 2 "Different-sex partners"))
graph export "$figs/post_diffs.png", replace

* Push factor: grouped by LAST YEAR's state
use "$tables/figures_working.dta", clear
collapse (mean) migrant [pw = perwt], by(year in_samesex oberg_past)
reshape wide migrant, i(year in_samesex) j(oberg_past)
gen diff = migrant1 - migrant0

twoway (line diff year if in_samesex == 1) ///
       (line diff year if in_samesex == 0, lpattern(dash)), ///
       xline(2015, lpattern(dot)) xlabel(2011(1)2019) ///
       title("Push factor") xtitle("Year") ///
       ytitle("Migration rate, Obergefell minus other states") ///
       legend(order(1 "Same-sex partners" 2 "Different-sex partners"))
graph export "$figs/ante_diffs.png", replace


* ---------------------------------------------------------------
* Step 5: Flow charts
* Same as Step 4, but the outcome is a move from (pull) or to (push)
* a particular type of state.
* The R "stay" charts are left out: stay = 1 - migrant, so they are
* just the Step 4 charts flipped upside down.
* ---------------------------------------------------------------

* Pull factor, movers FROM Obergefell states
use "$tables/figures_working.dta", clear
collapse (mean) fromfed_migrant [pw = perwt], by(year in_samesex oberg_now)
reshape wide fromfed_migrant, i(year in_samesex) j(oberg_now)
gen diff = fromfed_migrant1 - fromfed_migrant0
twoway (line diff year if in_samesex == 1) ///
       (line diff year if in_samesex == 0, lpattern(dash)), ///
       xline(2015, lpattern(dot)) xlabel(2011(1)2019) ///
       title("Pull factor: movers from Obergefell states") xtitle("Year") ///
       ytitle("Obergefell minus other states") ///
       legend(order(1 "Same-sex partners" 2 "Different-sex partners"))
graph export "$figs/flows_post_fromfed.png", replace

* Pull factor, movers FROM other states
use "$tables/figures_working.dta", clear
collapse (mean) fromlocal_migrant [pw = perwt], by(year in_samesex oberg_now)
reshape wide fromlocal_migrant, i(year in_samesex) j(oberg_now)
gen diff = fromlocal_migrant1 - fromlocal_migrant0
twoway (line diff year if in_samesex == 1) ///
       (line diff year if in_samesex == 0, lpattern(dash)), ///
       xline(2015, lpattern(dot)) xlabel(2011(1)2019) ///
       title("Pull factor: movers from other states") xtitle("Year") ///
       ytitle("Obergefell minus other states") ///
       legend(order(1 "Same-sex partners" 2 "Different-sex partners"))
graph export "$figs/flows_post_fromlocal.png", replace

* Push factor, movers TO Obergefell states
use "$tables/figures_working.dta", clear
collapse (mean) tofed_migrant [pw = perwt], by(year in_samesex oberg_past)
reshape wide tofed_migrant, i(year in_samesex) j(oberg_past)
gen diff = tofed_migrant1 - tofed_migrant0
twoway (line diff year if in_samesex == 1) ///
       (line diff year if in_samesex == 0, lpattern(dash)), ///
       xline(2015, lpattern(dot)) xlabel(2011(1)2019) ///
       title("Push factor: movers to Obergefell states") xtitle("Year") ///
       ytitle("Obergefell minus other states") ///
       legend(order(1 "Same-sex partners" 2 "Different-sex partners"))
graph export "$figs/flows_ante_tofed.png", replace

* Push factor, movers TO other states
use "$tables/figures_working.dta", clear
collapse (mean) tolocal_migrant [pw = perwt], by(year in_samesex oberg_past)
reshape wide tolocal_migrant, i(year in_samesex) j(oberg_past)
gen diff = tolocal_migrant1 - tolocal_migrant0
twoway (line diff year if in_samesex == 1) ///
       (line diff year if in_samesex == 0, lpattern(dash)), ///
       xline(2015, lpattern(dot)) xlabel(2011(1)2019) ///
       title("Push factor: movers to other states") xtitle("Year") ///
       ytitle("Obergefell minus other states") ///
       legend(order(1 "Same-sex partners" 2 "Different-sex partners"))
graph export "$figs/flows_ante_tolocal.png", replace


* ---------------------------------------------------------------
* Step 6: Heterogeneity charts (one panel per group)
* The same chart is made for each grouping variable, so a loop is used.
* Pull charts group people by current state; push charts by last year's state.
* ---------------------------------------------------------------

* Pull factor
foreach g in female age_group college has_child high_income expost_region {
    use "$tables/figures_working.dta", clear
    collapse (mean) migrant [pw = perwt], by(year in_samesex oberg_now `g')
    reshape wide migrant, i(year in_samesex `g') j(oberg_now)
    gen diff = migrant1 - migrant0

    twoway (line diff year if in_samesex == 1) ///
           (line diff year if in_samesex == 0, lpattern(dash)), ///
           by(`g', note("") title("Pull factor by `g'")) ///
           xline(2015, lpattern(dot)) xlabel(2011(1)2019) ///
           xtitle("Year") ytitle("Obergefell minus other states") ///
           legend(order(1 "Same-sex partners" 2 "Different-sex partners"))
    graph export "$figs/post_diffs_`g'.png", replace
}

* Push factor (region = region of last year's state)
foreach g in female age_group college has_child high_income exante_region {
    use "$tables/figures_working.dta", clear
    collapse (mean) migrant [pw = perwt], by(year in_samesex oberg_past `g')
    reshape wide migrant, i(year in_samesex `g') j(oberg_past)
    gen diff = migrant1 - migrant0

    twoway (line diff year if in_samesex == 1) ///
           (line diff year if in_samesex == 0, lpattern(dash)), ///
           by(`g', note("") title("Push factor by `g'")) ///
           xline(2015, lpattern(dot)) xlabel(2011(1)2019) ///
           xtitle("Year") ytitle("Obergefell minus other states") ///
           legend(order(1 "Same-sex partners" 2 "Different-sex partners"))
    graph export "$figs/ante_diffs_`g'.png", replace
}


* ---------------------------------------------------------------
* Step 7: Massachusetts charts
* Note: the ACS data start in 2011, so the earlier legalization years
* (2003-2009) fall outside the chart.
* ---------------------------------------------------------------

* Pull: migration rate among people now living in MA
use "$ma_data", clear
keep if statefip == 25
collapse (mean) migrant [pw = perwt], by(year in_samesex)
twoway (line migrant year if in_samesex == 1) ///
       (line migrant year if in_samesex == 0, lpattern(dash)), ///
       xline(2011 2012 2013 2014 2015, lpattern(dot)) xlabel(2011(1)2019) ///
       title("Massachusetts: pull factor") xtitle("Year") ytitle("Share who moved in") ///
       legend(order(1 "Same-sex partners" 2 "Different-sex partners"))
graph export "$figs/MA_post_trends.png", replace

* Push: migration rate among people who lived in MA last year
use "$ma_data", clear
keep if past_state == 25
collapse (mean) migrant [pw = perwt], by(year in_samesex)
twoway (line migrant year if in_samesex == 1) ///
       (line migrant year if in_samesex == 0, lpattern(dash)), ///
       xline(2011 2012 2013 2014 2015, lpattern(dot)) xlabel(2011(1)2019) ///
       title("Massachusetts: push factor") xtitle("Year") ytitle("Share who moved out") ///
       legend(order(1 "Same-sex partners" 2 "Different-sex partners"))
graph export "$figs/MA_ante_trends.png", replace

* ---------------------------------------------------------------
* NEW FIGURES - watch interpretability
* ---------------------------------------------------------------

* other migration flow figures (new)
use "$tables/figures_working.dta", clear
collapse (mean) *_migrant [pw = perwt], by(year in_samesex)

// pull
twoway (line local2003tofed_migrant year if in_samesex == 1) ///
	(line local2008tofed_migrant year if in_samesex == 1) ///
	(line local2009tofed_migrant year if in_samesex == 1) ///
	(line local2003tofed_migrant year if in_samesex == 0) ///
	(line local2008tofed_migrant year if in_samesex == 0) ///
	(line local2009tofed_migrant year if in_samesex == 0), ///
       xline(2015, lpattern(dot)) xlabel(2011(1)2019) ///
       title("Pulls") xtitle("Year") ///
       legend(order(1 "Same-sex 2003" 2 "Same-sex 2008" 3 "Same-sex 2009" 4 "Different-sex 2003" 5 "Different-sex 2008" 6 "Different-sex 2009"))
* looks like something is there; kinda messy though (will need to fix regressions too - oi watch migration counterfactual)
* think about how much can be attributable to noise might have to drop 2019

// push
twoway (line fedtolocal2003_migrant year if in_samesex == 1) ///
	(line fedtolocal2008_migrant year if in_samesex == 1) ///
	(line fedtolocal2009_migrant year if in_samesex == 1) ///
	(line fedtolocal2003_migrant year if in_samesex == 0) ///
	(line fedtolocal2008_migrant year if in_samesex == 0) ///
	(line fedtolocal2009_migrant year if in_samesex == 0), ///
       xline(2015, lpattern(dot)) xlabel(2011(1)2019) ///
       title("Pushes") xtitle("Year") ///
       legend(order(1 "Same-sex 2003" 2 "Same-sex 2008" 3 "Same-sex 2009" 4 "Different-sex 2003" 5 "Different-sex 2008" 6 "Different-sex 2009"))
* if take out 2009 not much there darn
* different-sex still pretty flat (watch clustering)


* ---------------------------------------------------------------
* Step 8: Predicted (illustrative) charts - simulated, not data
* ---------------------------------------------------------------
clear
input year samesex_pull samesex_push oppsex
2011 -0.5 0.5 0
2012 -0.5 0.5 0
2013 -0.5 0.5 0
2014 -0.5 0.5 0
2015 -0.2 0.2 0
2016 -0.2 0.2 0
2017 -0.2 0.2 0
2018 -0.2 0.2 0
2019 -0.2 0.2 0
end

twoway (line samesex_pull year) (line oppsex year, lpattern(dash)), ///
       xline(2015, lpattern(dot)) xlabel(2011(1)2019) ylabel(none) ///
       title("Predicted pull factor differences") xtitle("Year") ///
       ytitle("Relative migration to Obergefell states") ///
       legend(order(1 "Same-sex partners" 2 "Different-sex partners"))
graph export "$figs/ex_post_diffs.png", replace

twoway (line samesex_push year) (line oppsex year, lpattern(dash)), ///
       xline(2015, lpattern(dot)) xlabel(2011(1)2019) ylabel(none) ///
       title("Predicted push factor differences") xtitle("Year") ///
       ytitle("Relative migration from Obergefell states") ///
       legend(order(1 "Same-sex partners" 2 "Different-sex partners"))
graph export "$figs/ex_ante_diffs.png", replace


* ---------------------------------------------------------------
* Step 9: Popular support table (only if expost_support is in the data)
* Higher values = warmer feelings toward gay men and lesbians.
* ---------------------------------------------------------------
use "$tables/figures_working.dta", clear
keep expost_state expost_support
duplicates drop
sort expost_support

file open tex using "$tables/pop_support.tex", write replace
file write tex "\begin{longtable}{lr}" _n
file write tex "State & Support Level \\" _n "\hline" _n
forvalues i = 1/`=_N' {
    file write tex (expost_state[`i']) " & " %3.0f (expost_support[`i']) " \\" _n
}
file write tex "\end{longtable}" _n
file close tex


* ---------------------------------------------------------------
* Step 10: Check legal-status coding (should show each state once per
* year, with old_legal switching from 0 to 1 in its legalization year
* and staying 0 after 2015 only for the 15 Obergefell states)
* ---------------------------------------------------------------
use "$tables/figures_working.dta", clear
tab expost_state year if expost_old_legal == 0
