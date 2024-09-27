// directories have been set; clean data here

// clean quarterly data
clear
cd "$raw"
import delimited "data_quarterly.csv"
xpose, clear
rename (v1 v2 v3 v4 v5 v6 v7 v8) (ps gs ni fi nd cpwi cp discrepancy)
drop in 1 // for weird reasons, the first line is empty
gen index = _n
cd "$processed"
save "data_quarterly.dta", replace
// create a list of date
clear
set obs 310
gen quarter = qofd(date("1947-01-01", "YMD")) + _n - 1
gen date = dofq(quarter)
format date %tdCCYY-NN-DD
drop quarter
gen index = _n
cd "$processed"
save "datelist.dta", replace
// add the date list to  gs_ps_ni.dta
use "data_quarterly.dta", clear
merge 1:1 index using "datelist.dta"
drop _merge
drop index
order date
save "data_quarterly", replace
erase "datelist.dta" // remove the file created to save the date list

// clean annual data
clear
cd "$raw"
import delimited "data_annual.csv"
xpose, clear
rename (v1 v2 v3 v4 v5 v6 v7 v8) (ps gs ni fi nd cpwi cp discrepancy)
drop in 1 // for weird reasons, the first line is empty
set obs 95
gen date = _n + 1928
order date
cd "$processed"
save "data_annual.dta", replace

