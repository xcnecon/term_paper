// Step 1: Import the CBO projection file
cd "$raw"
import delimited "cbo_projection", clear  // Import the raw CBO projection CSV file

// Step 2: Filter to keep only deficit forecasts
keep if component == "deficit"  // Keep only rows where the 'component' is 'deficit'

// Step 3: Keep only forecasts for the next fiscal year
gen is_nextyear = projected_fiscal_year - real(substr(baseline_date, 1, 4))  // Calculate whether it's a forecast for the next fiscal year
keep if is_nextyear == 1  // Keep only forecasts made for the next year
drop is_nextyear  // Drop the temporary calculation variable

// Step 4: Keep only the most recent forecasts for each fiscal year
bysort projected_fiscal_year: gen is_last = _n == _N  // Identify the last forecast for each projected fiscal year
keep if is_last  // Keep only the last forecast
drop is_last  // Drop the temporary variable

// Step 5: Keep only the useful variables and rename them for clarity
keep baseline_date projected_fiscal_year value  // Keep only the relevant variables
rename (baseline_date projected_fiscal_year) (forecast_date forecasted_date)  // Rename for consistency

// Step 6: Save the cleaned data
cd "$processed"
save "cbo_annual.dta", replace  // Save the cleaned data as a .dta file
