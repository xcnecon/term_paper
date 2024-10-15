// ------------------------------------------------------------
// Step 1: Clean the quarterly data

clear
cd "$raw"  // Navigate to the raw data directory
import delimited "data_quarterly.csv"  // Import the raw quarterly CSV data

// Step 2: Reshape the dataset for analysis
xpose, clear  // Transpose the data to switch rows with columns
rename (v1 v2 v3 v4 v5 v6 v7 v8) (ps gs ni fi nd cpwi cp discrepancy)  // Rename variables for better understanding
drop in 1  // Drop the first row which appears to be empty
gen index = _n  // Generate an index variable to facilitate merging

// Step 3: Save the cleaned quarterly data
cd "$processed"  // Navigate to the processed data directory
save "data_quarterly.dta", replace  // Save the cleaned and transposed data in Stata format

// ------------------------------------------------------------
// Step 4: Create a sequence of quarterly dates starting from Q1 1947

clear
set obs 310  // Set the number of observations (quarters) to 310
gen date = qofd(date("1947-01-01", "YMD")) + _n - 1  // Generate a quarterly date sequence starting from Q1 1947
format date %tq  // Apply quarterly date format
gen index = _n  // Create an index variable for merging purposes

// Step 5: Save the date list for merging
cd "$processed"  // Navigate to the processed data directory
save "datelist.dta", replace  // Save the date list as a separate Stata file

// ------------------------------------------------------------
// Step 6: Merge the date list with the quarterly data

use "data_quarterly.dta", clear  // Load the cleaned quarterly data
merge 1:1 index using "datelist.dta"  // Merge the date list into the quarterly data using the index variable
drop _merge  // Drop the merge indicator
drop index  // Drop the index variable after merging
order date  // Reorder the dataset to place 'date' as the first variable

// Step 7: Remove the temporary date list file
erase "datelist.dta"  // Delete the date list file after merging

// ------------------------------------------------------------
// Step 8: Merge quarterly data with stock price data

merge 1:1 date using "sp_quarterly.dta"  // Merge the stock price data with the quarterly dataset based on the date
drop if missing(date) | missing(ps)  // Drop observations where 'date' or 'ps' (price) are missing
drop _merge  // Drop the merge indicator

// Step 9: Generate differenced variables for non-stationary series
tsset date // Setting time varibale for time series manipulation
gen d_cpwi = d.cpwi
gen d_ps = d.ps
gen d_gs = d.gs
gen d_ni = d.ni
gen d_fi = d.fi
gen d_nd = d.nd

// Step 10: Generate percentage change variables for the series
gen c_cpwi = d_cpwi / cpwi[_n-1]
gen c_ps = d_ps / ps[_n-1]
gen c_gs = d_gs / gs[_n-1]
gen c_ni = d_ni / ni[_n-1]
gen c_fi = d_fi / fi[_n-1]
gen c_nd = d_nd / nd[_n-1]

// Step 11: Label all variables for clarity
// Step 19: Label all variables for clarity
label variable cpwi "Corporate Profit"
label variable cp "Corporate Profit without Adjustments"
label variable gs "Government Saving"
label variable ps "Personal Savings"
label variable ni "Net Investment"
label variable fi "Foreign Saving"
label variable nd "Net Dividend"
label variable discrepancy "Statistical Discrepancy in the NIPA"
label variable price "SP500 Price"
label variable earnings "Eearnings per SP500"
label variable return "SP500 Quarterly Return"

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

// Step 12: Save the final cleaned quarterly dataset
cd "$final"  // Navigate to the final data directory
save "data_quarterly.dta", replace  // Save the final cleaned and processed quarterly data

// ------------------------------------------------------------
// Step 13: Clean the annual data

clear
cd "$raw"  // Navigate to the raw data directory
import delimited "data_annual.csv"  // Import the raw annual CSV data

// Step 14: Reshape the annual data for analysis
xpose, clear  // Transpose the data (switch rows and columns)
rename (v1 v2 v3 v4 v5 v6 v7 v8) (ps gs ni fi nd cpwi cp discrepancy)  // Rename variables for clarity
drop in 1  // Drop the first row (appears empty)

// Step 15: Generate a 'date' variable representing the years
set obs 95  // Set the number of observations (years) to 95
gen date = _n + 1928  // Generate a sequence of years starting from 1929
order date  // Reorder to place 'date' as the first variable

// ------------------------------------------------------------
// Step 16: Merge the annual data with stock price data

cd "$processed"  // Navigate to the processed data directory
merge 1:1 date using "sp_annual.dta"  // Merge stock price data into the annual dataset
drop _merge  // Drop the merge indicator
drop if missing(date) | missing(ps)  // Drop observations where 'date' or 'ps' is missing

// Step 17: Generate differenced variables for non-stationary series
tsset date // Setting time varibale for time series manipulation
gen d_cpwi = d.cpwi
gen d_ps = d.ps
gen d_gs = d.gs
gen d_ni = d.ni
gen d_fi = d.fi
gen d_nd = d.nd

// Step 18: Generate percentage change variables for the series
gen c_cpwi = d_cpwi / cpwi[_n-1]
gen c_ps = d_ps / ps[_n-1]
gen c_gs = d_gs / gs[_n-1]
gen c_ni = d_ni / ni[_n-1]
gen c_fi = d_fi / fi[_n-1]
gen c_nd = d_nd / nd[_n-1]

// Step 19: Label all variables for clarity
label variable cpwi "Corporate Profit"
label variable cp "Corporate Profit without Adjustments"
label variable gs "Government Saving"
label variable ps "Personal Savings"
label variable ni "Net Investment"
label variable fi "Foreign Saving"
label variable nd "Net Dividend"
label variable discrepancy "Statistical Discrepancy in the NIPA"
label variable price "SP500 Price"
label variable earnings "Eearnings per SP500"
label variable return "SP500 Quarterly Return"


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

// Step 20: Save the final cleaned annual dataset
cd "$final"  // Navigate to the final data directory
save "data_annual.dta", replace  // Save the final cleaned and processed annual data
