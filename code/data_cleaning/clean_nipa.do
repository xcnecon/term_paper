// ------------------------------------------------------------
// Step 1: Clean the Quarterly Data

clear
cd "$raw"  // Go to the raw data folder
import delimited "data_quarterly.csv"  // Load the raw quarterly data

// Step 2: Reshape the Dataset
xpose, clear  // Transpose data for analysis
rename (v1 v2 v3 v4 v5 v6 v7 v8) (ps gs ni fi nd cpwi cp discrepancy)  // Rename variables
drop in 1  // Remove the first row (empty)
gen index = _n  // Create index for merging

// Step 3: Save the Cleaned Quarterly Data
cd "$processed"  // Go to the processed data folder
save "data_quarterly.dta", replace  // Save cleaned data

// ------------------------------------------------------------
// Step 4: Create a Sequence of Quarterly Dates

clear
set obs 310  // Set observations for 310 quarters
gen date = qofd(date("1947-01-01", "YMD")) + _n - 1  // Generate quarterly dates starting Q1 1947
format date %tq  // Format as quarterly dates
gen index = _n  // Create index for merging

// Step 5: Save the Date List
cd "$processed"  // Go to processed data folder
save "datelist.dta", replace  // Save date list

// ------------------------------------------------------------
// Step 6: Merge Date List with Quarterly Data

use "data_quarterly.dta", clear  // Load cleaned data
merge 1:1 index using "datelist.dta"  // Merge dates with data
drop _merge index  // Drop merge indicators and index
order date  // Move date to the first column

// Step 7: Remove Temporary Date List
erase "datelist.dta"  // Delete date list file

// ------------------------------------------------------------
// Step 8: Merge Quarterly Data with Stock Price Data

merge 1:1 date using "sp_quarterly.dta"  // Merge stock prices by date
drop if missing(date) | missing(ps)  // Remove missing dates or prices
drop _merge  // Drop merge indicator

// Step 9: Create Differenced Variables
tsset date  // Set date as time variable
gen d_cpwi = d.cpwi
gen d_ps = d.ps
gen d_gs = d.gs
gen d_ni = d.ni
gen d_fi = d.fi
gen d_nd = d.nd

// Step 10: Create Percentage Change Variables
gen c_cpwi = d_cpwi / cpwi[_n-1]
gen c_ps = d_ps / ps[_n-1]
gen c_gs = d_gs / gs[_n-1]
gen c_ni = d_ni / ni[_n-1]
gen c_fi = d_fi / fi[_n-1]
gen c_nd = d_nd / nd[_n-1]

// Step 11: Label Variables for Clarity
label variable cpwi "Corporate Profit"
label variable cp "Corporate Profit without Adjustments"
label variable gs "Government Saving"
label variable ps "Personal Savings"
label variable ni "Net Investment"
label variable fi "Foreign Saving"
label variable nd "Net Dividend"
label variable discrepancy "Statistical Discrepancy in the NIPA"
label variable price "SP500 Price"
label variable earnings "Earnings per SP500"

label variable d_cpwi "Corporate Profit (Delta qoq)"
label variable d_gs "Government Saving (Delta qoq)"
label variable d_ps "Personal Savings (Delta qoq)"
label variable d_ni "Net Investment (Delta qoq)"
label variable d_fi "Foreign Saving (Delta qoq)"
label variable d_nd "Net Dividend (Delta qoq)"

label variable c_cpwi "Corporate Profit (% qoq)"
label variable c_gs "Government Saving (% qoq)"
label variable c_ps "Personal Savings (% qoq)"
label variable c_ni "Net Investment (% qoq)"
label variable c_fi "Foreign Saving (% qoq)"
label variable c_nd "Net Dividend (% qoq)"

// Step 12: Save the Final Quarterly Dataset
cd "$processed"
save "data_quarterly.dta", replace

// ------------------------------------------------------------
// Step 13: Clean the Annual Data

clear
cd "$raw"
import delimited "data_annual.csv"

// Step 14: Reshape the Annual Data
xpose, clear
rename (v1 v2 v3 v4 v5 v6 v7 v8) (ps gs ni fi nd cpwi cp discrepancy)
drop in 1

// Step 15: Create Date Variable for Years
set obs 95  // 95 observations (years)
gen date = _n + 1928  // Generate years starting from 1929
order date

// ------------------------------------------------------------
// Step 16: Merge Annual Data with Stock Price Data

cd "$processed"
merge 1:1 date using "sp_annual.dta"  // Merge stock prices
drop _merge  // Drop merge indicator
drop if missing(date) | missing(ps)

// Step 17: Create Differenced Variables
tsset date
gen d_cpwi = d.cpwi
gen d_ps = d.ps
gen d_gs = d.gs
gen d_ni = d.ni
gen d_fi = d.fi
gen d_nd = d.nd

// Step 18: Create Percentage Change Variables
gen c_cpwi = d_cpwi / cpwi[_n-1]
gen c_ps = d_ps / ps[_n-1]
gen c_gs = d_gs / gs[_n-1]
gen c_ni = d_ni / ni[_n-1]
gen c_fi = d_fi / fi[_n-1]
gen c_nd = d_nd / nd[_n-1]

// Step 19: Label Variables
label variable cpwi "Corporate Profit"
label variable cp "Corporate Profit without Adjustments"
label variable gs "Government Saving"
label variable ps "Personal Savings"
label variable ni "Net Investment"
label variable fi "Foreign Saving"
label variable nd "Net Dividend"
label variable discrepancy "Statistical Discrepancy in the NIPA"
label variable price "SP500 Price"
label variable earnings "Earnings per SP500"

label variable d_cpwi "Corporate Profit (Delta qoq)"
label variable d_gs "Government Saving (Delta qoq)"
label variable d_ps "Personal Savings (Delta qoq)"
label variable d_ni "Net Investment (Delta qoq)"
label variable d_fi "Foreign Saving (Delta qoq)"
label variable d_nd "Net Dividend (Delta qoq)"

label variable c_cpwi "Corporate Profit (% qoq)"
label variable c_gs "Government Saving (% qoq)"
label variable c_ps "Personal Savings (% qoq)"
label variable c_ni "Net Investment (% qoq)"
label variable c_fi "Foreign Saving (% qoq)"
label variable c_nd "Net Dividend (% qoq)"

// Step 20: Save the Final Annual Dataset
cd "$processed"
save "data_annual.dta", replace
