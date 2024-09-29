// clean the sp data
cd "$raw"
import delimited "sp.csv", clear
// drop missing obs
drop if missing(earnings)
// only keep the last data in one quarter
count
set obs 1842
gen index = _n
// the index of last month in a quarter is a multiple of 3
keep if mod(index, 3)==0
drop index
// drop data before 1947, which is too old
drop if date < 1947
// setup a new index for easy merging
count
set obs 310
gen index = _n
order index
// calculate quarterly stock price change
destring price, replace
gen return = (price - price[_n-1]) / price[_n-1]
// save
cd "$processed"
save "sp.dta", replace
