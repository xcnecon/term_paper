// Please note that this program might take you 10 mins.
cd "$processed"  // Set to final dataset folder
use "data_quarterly.dta", clear  // Load quarterly data

local lookback = 80  // 10-year rolling window
local lags = 4
local start_window = tq(1947q1) + `lookback' - 1  // Forecast start
local end_window = tq(2024q1)  // Forecast end

gen d_`lags'_`lookback' = .  // Initialize forecast storage
gen p_`lags'_`lookback' = .  // Initialize forecast storage
gen pc_`lags'_`lookback' = .
gen dr_`lags'_`lookback' = .

// Rolling window forecasting loop with linear regression
forvalues i = `start_window'/`end_window' {    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: regress d_cpwi L(1/`lags').d_cpwi L(1/`lags').d_ps L(1/`lags').d_gs L(1/`lags').d_ni L(1/`lags').d_fi date
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace d_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}


forvalues i = `start_window'/`end_window' {    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: regress c_cpwi L(1/`lags').c_cpwi L(1/`lags').c_ps L(1/`lags').c_gs L(1/`lags').c_ni L(1/`lags').c_fi L(1/`lags').c_nd date
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace p_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

forvalues i = `start_window'/`end_window' {    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: regress c_cpwi L(1/`lags').c_cpwi date
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace pc_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

forvalues i = `start_window'/`end_window' {    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: regress d_cpwi L(1/`lags').d_cpwi L(1/`lags').d_ps L(1/`lags').d_gs L(1/`lags').d_nd L(1/`lags').d_fi date
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace dr_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}


local lookback = 100  // Adjust rolling window
local lags = 8
local start_window = tq(1947q1) + `lookback' - 1  // Forecast start
local end_window = tq(2024q1)  // Forecast end

gen d_`lags'_`lookback' = .  // Initialize forecast storage
gen p_`lags'_`lookback' = .  // Initialize forecast storage
gen pc_`lags'_`lookback' = .
gen dr_`lags'_`lookback' = .

// Rolling window forecasting loop with updated parameters
forvalues i = `start_window'/`end_window' {    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: regress d_cpwi L(1/`lags').d_cpwi L(1/`lags').d_ps L(1/`lags').d_gs L(1/`lags').d_ni L(1/`lags').d_fi date
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace d_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

forvalues i = `start_window'/`end_window' {    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: regress c_cpwi L(1/`lags').c_cpwi L(1/`lags').c_ps L(1/`lags').c_gs L(1/`lags').c_ni L(1/`lags').c_fi L(1/`lags').c_nd date
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace p_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

forvalues i = `start_window'/`end_window' {    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: regress c_cpwi L(1/`lags').c_cpwi date
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace pc_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

forvalues i = `start_window'/`end_window' {    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: regress d_cpwi L(1/`lags').d_cpwi L(1/`lags').d_ps L(1/`lags').d_gs L(1/`lags').d_nd L(1/`lags').d_fi date
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace dr_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

local lookback = 120  // Adjust rolling window
local lags = 12
local start_window = tq(1947q1) + `lookback' - 1  // Forecast start
local end_window = tq(2024q1)  // Forecast end
gen p_`lags'_`lookback' = .  // Initialize forecast storage

forvalues i = `start_window'/`end_window' {    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: regress c_cpwi L(1/`lags').c_cpwi L(1/`lags').c_ps L(1/`lags').c_gs L(1/`lags').c_ni L(1/`lags').c_fi L(1/`lags').c_nd date
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace p_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

local lookback = 160  // Adjust rolling window
local lags = 16
local start_window = tq(1947q1) + `lookback' - 1  // Forecast start
local end_window = tq(2024q1)  // Forecast end
gen p_`lags'_`lookback' = .  // Initialize forecast storage

forvalues i = `start_window'/`end_window' {    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: regress c_cpwi L(1/`lags').c_cpwi L(1/`lags').c_ps L(1/`lags').c_gs L(1/`lags').c_ni L(1/`lags').c_fi L(1/`lags').c_nd date
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace p_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

// R-squared calculations and final labels
replace d_4_80 = d_4_80 / l.cpwi
replace d_8_100 = d_8_100 / l.cpwi
replace dr_4_80 = dr_4_80 / l.cpwi
replace dr_8_100 = dr_8_100 / l.cpwi

gen r2_d_4_80 = .
gen r2_d_8_100 = .
gen r2_p_4_80 = .
gen r2_pc_4_80 = .
gen r2_p_8_100 = .
gen r2_pc_8_100 = .
gen r2_p_12_120 = .
gen r2_p_16_160 = .
gen r2_dr_4_80 =.
gen r2_dr_8_100 =.

local predictions "d_4_80 p_4_80 pc_4_80 d_8_100 p_8_100 pc_8_100 p_12_120 p_16_160 dr_4_80 dr_8_100"

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


label variable r2_d_4_80 "R2 for level 4-80"
label variable r2_d_8_100 "R2 for level 8-100"
label variable r2_p_4_80 "R2 for pct 4-80"
label variable r2_pc_4_80 "R2 for pct control 4-80"
label variable r2_p_8_100 "R2 for pct 8-100"
label variable r2_pc_8_100 "R2 for pct control 8-100"
label variable r2_p_12_120 "R2 for pct 12-120"
label variable r2_p_16_160 "R2 for pct 16-160"
label variable r2_dr_4_80 "R2 for alternative level 4-80"
label variable r2_dr_8_100 "R2 for alternative level 8-100"

cd "$final"
save "data_quarterly.dta", replace


cd "$processed"  // Set to final dataset folder
use "data_annual.dta", clear  // Load annual data

gen p_4_40 = .
gen p_6_60 = .
gen p_4_60 = .

local lookback = 40  // 10-year rolling window
local lags = 4
local start_window = 1929 + `lookback' - 1  // Forecast start
local end_window = 2023 // Forecast end

forvalues i = `start_window'/`end_window' {    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next year forecast

    qui: regress c_cpwi L(1/`lags').c_cpwi L(1/`lags').c_ps L(1/`lags').c_gs L(1/`lags').c_ni L(1/`lags').c_fi L(1/`lags').c_nd date
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace p_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

local lookback = 60  // Adjust rolling window
local lags = 6
local start_window = 1929 + `lookback' - 1  // Forecast start
local end_window = 2023  // Forecast end

forvalues i = `start_window'/`end_window' {    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next year forecast

    qui: regress c_cpwi L(1/`lags').c_cpwi L(1/`lags').c_ps L(1/`lags').c_gs L(1/`lags').c_ni L(1/`lags').c_fi L(1/`lags').c_nd date
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace p_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

local lookback = 60  // Adjust rolling window
local lags = 4
local start_window = 1929 + `lookback' - 1  // Forecast start
local end_window = 2023  // Forecast end

forvalues i = `start_window'/`end_window' {    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next year forecast

    qui: regress c_cpwi L(1/`lags').c_cpwi L(1/`lags').c_ps L(1/`lags').c_gs L(1/`lags').c_ni L(1/`lags').c_fi L(1/`lags').c_nd date
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace p_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

// Initialize variables to store R-squared values for each prediction type
gen r2_p_4_40 = .
gen r2_p_6_60 = .
gen r2_p_4_60 = .

// Define macros for prediction types and their actual variables
local predictions "p_4_40 p_6_60 p_4_60"

// Loop over each prediction type to calculate R-squared
forvalues i = 1/3 {
    local pred : word `i' of `predictions'
    local act "c_cpwi"

    // Calculate mean of the actual variable for non-missing predictions
    qui: summarize `act' if !missing(`pred')
    local mean_act = r(mean)

    // Compute sum of squares for residuals and total sum of squares for non-missing predictions
    qui: gen residuals_`pred' = (`act' - `pred') if !missing(`pred')
    qui: gen ss_residuals_`pred' = residuals_`pred'^2 if !missing(residuals_`pred')
    qui: gen ss_total_`pred' = (`act' - `mean_act')^2 if !missing(`pred')

    // Sum up residuals and total sum of squares
    qui: sum ss_residuals_`pred' if !missing(ss_residuals_`pred')
    local ss_res = r(sum)
    qui: sum ss_total_`pred' if !missing(ss_total_`pred')
    local ss_tot = r(sum)

    // Calculate R-squared and store in respective variable
    qui: replace r2_`pred' = 1 - (`ss_res' / `ss_tot')
}

// Clean up temporary variables
drop residuals_* ss_residuals_* ss_total_*

label variable p_4_40 "pct 4-40"
label variable p_6_60 "pct 6-60"
label variable p_4_60 "pct 4-60"
label variable r2_p_4_40 "R2 for pct 4-40"
label variable r2_p_6_60 "R2 for pct 6-60"
label variable r2_p_4_60 "R2 for pct 4-60"


cd "$final"
save "data_annual.dta", replace
