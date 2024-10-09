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
// standardize date variable for future merging
gen year = floor(date)  // Extract the year
gen month = round((date) * 100 - year * 100)  // Extract the month
gen quarter = .
replace quarter = 1 if inrange(month, 1, 3)
replace quarter = 2 if inrange(month, 4, 6)
replace quarter = 3 if inrange(month, 7, 9)
replace quarter = 4 if inrange(month, 10, 12)
drop date
gen date = yq(year, quarter)
format date %tq  // Apply quarterly date format
drop month quarter year
order date
// calculate quarterly stock price change
destring price, replace
gen return = (price - price[_n-1]) / price[_n-1]
// save
cd "$processed"
save "sp_quarterly.dta", replace


// generate annual data
cd "$raw"
import delimited "sp.csv", clear
// drop missing obs
drop if missing(earnings)
// only keep the last data in the last month of a year
count
set obs 1842
gen index = _n
keep if mod(index, 12)==0
drop index
// transfrom month into year
replace date = round(date)
format date %ty
// save
cd "$processed"
save "sp_annual.dta", replace
