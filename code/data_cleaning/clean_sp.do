// ------------------------------------------------------------
// Step 1: Clean the Quarterly Stock Price (SP) Data

cd "$raw"
import delimited "sp.csv", clear  // Load raw CSV data

// Step 2: Remove Missing Earnings Data
drop if missing(earnings)  // Drop rows with missing earnings

// Step 3: Keep Only Last Observation of Each Quarter
count  // Count total observations
set obs 1842  // Set observation count if necessary
gen index = _n  // Create an index for row numbering
keep if mod(index, 3) == 0  // Keep only rows for the last month of each quarter
drop index  // Remove index variable

// Step 4: Drop Data Before 1947
drop if date < 1947

// Step 5: Convert 'date' to Year and Quarter Format
gen year = floor(date)  // Extract year
gen month = round((date * 100) - (year * 100))  // Extract month
gen quarter = .  // Initialize quarter variable
replace quarter = 1 if inrange(month, 1, 3)  // Assign Q1 for months 1-3
replace quarter = 2 if inrange(month, 4, 6)  // Assign Q2 for months 4-6
replace quarter = 3 if inrange(month, 7, 9)  // Assign Q3 for months 7-9
replace quarter = 4 if inrange(month, 10, 12)  // Assign Q4 for months 10-12
drop date  // Drop original date

// Step 6: Create and Format Quarterly Date Variable
gen date = yq(year, quarter)  // Generate quarterly date from year and quarter
format date %tq  // Apply quarterly date format
drop month quarter year  // Drop intermediate variables
order date  // Move date to the first column

// Step 7: Calculate Quarterly Stock Price Return
destring price, replace  // Ensure 'price' is numeric

// Step 8: Save Processed Quarterly Data
cd "$processed"
save "sp_quarterly.dta", replace  // Save as .dta file

// ------------------------------------------------------------
// Step 9: Generate Annual Stock Price Data

cd "$raw"
import delimited "sp.csv", clear  // Reload raw CSV data

// Step 10: Remove Missing Earnings Data (Same as Before)
drop if missing(earnings)

// Step 11: Keep Only Last Observation of Each Year (December)
count
set obs 1842
gen index = _n
keep if mod(index, 12) == 0  // Keep only December data for each year
drop index

// Step 12: Convert to Year Format
replace date = round(date)  // Round date to the nearest year
format date %ty  // Format as yearly date

// Step 13: Calculate Annual Stock Price Return
destring price, replace
gen return = (price - price[_n-1]) / price[_n-1]

// Step 14: Save Processed Annual Data
cd "$processed"
save "sp_annual.dta", replace  // Save as .dta file
