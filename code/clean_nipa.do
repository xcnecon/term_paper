// Consolidate data into final quarterly and annual data table

// ------------------------------------------------------------
// Step 1: Clean the quarterly data
clear
cd "$raw"
import delimited "data_quarterly.csv"  // Import the raw quarterly CSV data

// Step 2: Reshape the dataset for analysis
xpose, clear  // Transpose the data (switch rows and columns)
rename (v1 v2 v3 v4 v5 v6 v7 v8) (ps gs ni fi nd cpwi cp discrepancy)  // Rename variables for clarity
drop in 1  // Drop the first row (appears to be empty for unknown reasons)
gen index = _n  // Create an index variable for merging later

// Step 3: Save the cleaned quarterly data
cd "$processed"
save "data_quarterly.dta", replace  // Save the transposed data in Stata format

// ------------------------------------------------------------
// Step 4: Create a list of quarterly dates starting from Q1 1947
clear
set obs 310  // Set the number of observations (quarters) to 310
gen date = qofd(date("1947-01-01", "YMD")) + _n - 1  // Generate a sequence of quarterly dates starting from Q1 1947
format date %tq  // Apply the quarterly date format
gen index = _n  // Create an index variable for merging

// Step 5: Save the date list for merging later
cd "$processed"
save "datelist.dta", replace  // Save the date list as a separate file

// ------------------------------------------------------------
// Step 6: Merge the date list with the quarterly data
use "data_quarterly.dta", clear  // Load the quarterly data
merge 1:1 index using "datelist.dta"  // Merge the date list into the quarterly data
drop _merge  // Drop merge indicator
drop index  // Drop the index variable as it's no longer needed
order date  // Reorder to place 'date' variable first

// Step 7: Remove the temporary date list file
erase "datelist.dta"  // Delete the file created to store the date list

// ------------------------------------------------------------
// Step 8: Merge the quarterly data with the stock price (sp) data
merge 1:1 date using "sp_quarterly.dta"  // Merge the stock price data into the quarterly dataset

// Step 9: Final cleanup and save the merged quarterly data
cd "$final"
save "data_quarterly.dta", replace  // Save the final merged quarterly data
drop if missing(date) | missing(ps)  // Drop observations with missing 'date' or 'ps' (price) values
drop _merge  // Drop merge indicator

// ------------------------------------------------------------
// Step 10: Clean the annual data
clear
cd "$raw"
import delimited "data_annual.csv"  // Import the raw annual CSV data

// Step 11: Reshape the annual dataset for analysis
xpose, clear  // Transpose the data (switch rows and columns)
rename (v1 v2 v3 v4 v5 v6 v7 v8) (ps gs ni fi nd cpwi cp discrepancy)  // Rename variables for clarity
drop in 1  // Drop the first row (appears to be empty for unknown reasons)

// Step 12: Create a 'date' variable based on the year
set obs 95  // Set the number of observations (years) to 95
gen date = _n + 1928  // Generate a sequence of years starting from 1929
order date  // Reorder to place 'date' variable first

// ------------------------------------------------------------
// Step 13: Merge the annual data with the stock price (sp) annual data
cd "$processed"
merge 1:1 date using "sp_annual.dta"  // Merge the stock price data into the annual dataset

// Step 14: Final cleanup and save the merged annual data
drop _merge  // Drop merge indicator
drop if missing(date) | missing(ps)  // Drop observations with missing 'date' or 'ps' (price) values

cd "$final"
save "data_annual.dta", replace  // Save the final merged annual data
