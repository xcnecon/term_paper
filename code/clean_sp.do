// Step 1: Clean the quarterly stock price (sp) data
cd "$raw"
import delimited "sp.csv", clear  // Import the raw CSV data

// Step 2: Remove observations with missing earnings
drop if missing(earnings)  // Drop rows where earnings data is missing

// Step 3: Keep only the last observation for each quarter
count  // Count the total number of observations in the dataset
set obs 1842  // Set the observation count (if needed)
gen index = _n  // Create an index variable for row numbering
keep if mod(index, 3) == 0  // Keep only rows where the index is divisible by 3 (last month of each quarter)
drop index  // Drop the index variable as it's no longer needed

// Step 4: Remove data before 1947, as it's considered too old for analysis
drop if date < 1947

// Step 5: Standardize the 'date' variable for future merging (convert to year and quarter format)
gen year = floor(date)  // Extract the year from the date
gen month = round((date) * 100 - year * 100)  // Extract the month from the date
gen quarter = .  // Initialize a quarter variable
replace quarter = 1 if inrange(month, 1, 3)  // Assign Q1 for months 1-3
replace quarter = 2 if inrange(month, 4, 6)  // Assign Q2 for months 4-6
replace quarter = 3 if inrange(month, 7, 9)  // Assign Q3 for months 7-9
replace quarter = 4 if inrange(month, 10, 12)  // Assign Q4 for months 10-12
drop date  // Drop the original 'date' variable

// Step 6: Create a quarterly date variable and format it
gen date = yq(year, quarter)  // Create a quarterly date variable based on year and quarter
format date %tq  // Apply quarterly date format to the 'date' variable
drop month quarter year  // Drop intermediate variables used for creating the date
order date  // Reorder to place 'date' variable first

// Step 7: Calculate the quarterly stock price return
destring price, replace  // Ensure the 'price' variable is numeric
gen return = (price - price[_n-1]) / price[_n-1]  // Calculate percentage change in stock price from the previous period

// Step 8: Save the processed quarterly data
cd "$processed"
save "sp_quarterly.dta", replace  // Save the processed data as a .dta file

// ------------------------------------------------------------

// Step 9: Generate annual stock price data
cd "$raw"
import delimited "sp.csv", clear  // Re-import the raw CSV data

// Step 10: Remove observations with missing earnings (same as before)
drop if missing(earnings)  // Drop rows where earnings data is missing

// Step 11: Keep only the last observation for each year (December)
count  // Count the total number of observations in the dataset
set obs 1842  // Set the observation count (if needed)
gen index = _n  // Create an index variable for row numbering
keep if mod(index, 12) == 0  // Keep only rows where the index is divisible by 12 (last month of each year)
drop index  // Drop the index variable as it's no longer needed

// Step 12: Convert month format to year format
replace date = round(date)  // Round the date to the nearest year (assuming monthly format)
format date %ty  // Apply yearly date format to the 'date' variable

// Step 13: Save the processed annual data
cd "$processed"
save "sp_annual.dta", replace  // Save the processed data as a .dta file