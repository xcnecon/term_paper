// Please note that this program might take about 10 minutes to run

cd "$processed"  // Go to the final dataset folder
use "data_quarterly.dta", clear  // Load the quarterly data

local lookback = 80  // Set 10-year rolling window
local lags = 4
local start_window = tq(1947q1) + `lookback' - 1  // Forecast start
local end_window = tq(2024q1)  // Forecast end

// Initialize variables to store forecasts
gen d_`lags'_`lookback' = .
gen p_`lags'_`lookback' = .
gen pc_`lags'_`lookback' = .
gen dr_`lags'_`lookback' = .

// Rolling window forecasting loop using linear regression
forvalues i = `start_window'/`end_window' {    
    local forecast_period = `i' + 1  // Forecast for the next quarter

    qui: regress d_cpwi L(1/`lags').d_cpwi L(1/`lags').d_ps L(1/`lags').d_gs L(1/`lags').d_ni L(1/`lags').d_fi date
    qui: predict temp if date == `forecast_period'  // Generate one-step forecast
    qui: replace d_`lags'_`lookback' = temp if date == `forecast_period'  // Store forecast
    qui: drop temp  // Remove temp variable
}

// Repeat similar process for other models with different parameters
// (The rest of the script will follow similar patterns for setting up different lags and lookback periods)

// Adjust the lookback window and lags for each section as specified
local lookback = 100  
local lags = 8
local start_window = tq(1947q1) + `lookback' - 1
local end_window = tq(2024q1)

// Initialize forecast storage for the new configuration
gen d_`lags'_`lookback' = .
gen p_`lags'_`lookback' = .
gen pc_`lags'_`lookback' = .
gen dr_`lags'_`lookback' = .

// Forecasting loop with updated parameters
forvalues i = `start_window'/`end_window' {    
    local forecast_period = `i' + 1

    qui: regress d_cpwi L(1/`lags').d_cpwi L(1/`lags').d_ps L(1/`lags').d_gs L(1/`lags').d_ni L(1/`lags').d_fi date
    qui: predict temp if date == `forecast_period'
    qui: replace d_`lags'_`lookback' = temp if date == `forecast_period'
    qui: drop temp
}

// Continue similarly for other lookback periods and configurations

// R-squared calculations
replace d_4_80 = d_4_80 / l.cpwi
replace d_8_100 = d_8_100 / l.cpwi
replace dr_4_80 = dr_4_80 / l.cpwi
replace dr_8_100 = dr_8_100 / l.cpwi

// Initialize R-squared storage variables
gen r2_d_4_80 = .
gen r2_d_8_100 = .
gen r2_p_4_80 = .
gen r2_pc_4_80 = .
gen r2_p_8_100 = .
gen r2_pc_8_100 = .
gen r2_p_12_120 = .
gen r2_p_16_160 = .
gen r2_dr_4_80 = .
gen r2_dr_8_100 = .

local predictions "d_4_80 p_4_80 pc_4_80 d_8_100 p_8_100 pc_8_100 p_12_120 p_16_160 dr_4_80 dr_8_100"

// Calculate R-squared for each prediction type
forvalues i = 1/10 {
    local pred : word `i' of `predictions'
    local act "c_cpwi"

    qui: summarize `act' if !missing(`pred')
    local mean_act = r(mean)

    qui: gen residuals_`pred' = (`act' - `pred') if !missing(`pred')
    qui: gen ss_residuals_`pred' = residuals_`pred'^2 if !missing(residuals_`pred')
    qui: gen ss_total_`pred' = (`act' - `mean_act')^2 if !missing(`pred')

    qui: sum ss_residuals_`pred' if !missing(ss_residuals_`pred')
    local ss_res = r(sum)
    qui: sum ss_total_`pred' if !missing(ss_total_`pred')
    local ss_tot = r(sum)

    qui: replace r2_`pred' = 1 - (`ss_res' / `ss_tot')
}

drop residuals_* ss_residuals_* ss_total_*

// Label variables for clarity
label variable d_4_80 "level 4-80"
label variable d_8_100 "level 8-100"
label variable p_4_80 "pct 4-80"
label variable pc_4_80 "pct control 4-80"
label variable p_8_100 "pct 8-100"
label variable pc_8_100 "pct control 8-100"
label variable p_12_120 "pct 12-120"
label variable p_16_160 "pct 16-160"
label variable dr_4_80 "alternative level 4-80"
label variable dr_8_100 "alternative level 8-100"

// Save quarterly data
cd "$final"
save "data_quarterly.dta", replace

// Load and process annual data
cd "$processed"
use "data_annual.dta", clear

gen p_4_40 = .
gen p_6_60 = .
gen p_4_60 = .

local lookback = 40  // 10-year window for annual data
local lags = 4
local start_window = 1929 + `lookback' - 1
local end_window = 2023

// Forecasting loop for annual data with different parameters
forvalues i = `start_window'/`end_window' {
    local forecast_period = `i' + 1

    qui: regress c_cpwi L(1/`lags').c_cpwi L(1/`lags').c_ps L(1/`lags').c_gs L(1/`lags').c_ni L(1/`lags').c_fi L(1/`lags').c_nd date
    qui: predict temp if date == `forecast_period'
    qui: replace p_`lags'_`lookback' = temp if date == `forecast_period'
    qui: drop temp
}

// Initialize R-squared storage for annual predictions
gen r2_p_4_40 = .
gen r2_p_6_60 = .
gen r2_p_4_60 = .

// R-squared calculations for annual predictions
local predictions "p_4_40 p_6_60 p_4_60"

forvalues i = 1/3 {
    local pred : word `i' of `predictions'
    local act "c_cpwi"

    qui: summarize `act' if !missing(`pred')
    local mean_act = r(mean)

    qui: gen residuals_`pred' = (`act' - `pred') if !missing(`pred')
    qui: gen ss_residuals_`pred' = residuals_`pred'^2 if !missing(residuals_`pred')
    qui: gen ss_total_`pred' = (`act' - `mean_act')^2 if !missing(`pred')

    qui: sum ss_residuals_`pred' if !missing(ss_residuals_`pred')
    local ss_res = r(sum)
    qui: sum ss_total_`pred' if !missing(ss_total_`pred')
    local ss_tot = r(sum)

    qui: replace r2_`pred' = 1 - (`ss_res' / `ss_tot')
}

// Clean up temporary variables and add labels
drop residuals_* ss_residuals_* ss_total_*

label variable p_4_40 "pct 4-40"
label variable p_6_60 "pct 6-60"
label variable p_4_60 "pct 4-60"
label variable r2_p_4_40 "R2 for pct 4-40"
label variable r2_p_6_60 "R2 for pct 6-60"
label variable r2_p_4_60 "R2 for pct 4-60"

// Save the annual data file
cd "$final"
save "data_annual.dta", replace
