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

forvalues i = `start_window'/`end_window' {
    local forecast_period = `i' + 1

    qui: regress c_cpwi L(1/`lags').c_cpwi L(1/`lags').c_ps L(1/`lags').c_gs L(1/`lags').c_ni L(1/`lags').c_fi L(1/`lags').c_nd date
    qui: predict temp if date == `forecast_period'
    qui: replace p_`lags'_`lookback' = temp if date == `forecast_period'
    qui: drop temp
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


// predict each component for later bottom-up analysis
// Set up parameters
cd "$final"  // Navigate to the folder containing the dataset
use "data_quarterly.dta", clear  // Load the quarterly data

// Initialize key variables
local lookback = 100  // 25-year rolling window (quarters)
local lags = 8
local start_window = tq(1947q1) + `lookback' - 1  // Forecast start
local end_window = tq(2024q1)  // Forecast end

// List of dependent variables to predict
local dep_vars "c_gs c_ps c_ni c_fi c_nd"

// Initialize storage for forecasts and R-squared
foreach dep in `dep_vars' {
    gen pred_`dep' = .  // Create forecast variable
    gen r2_`dep' = .    // Create R-squared variable
}

// Rolling window forecasting loop
forvalues i = `start_window'/`end_window' {
    local forecast_period = `i' + 1  // Predict next quarter

    foreach dep in `dep_vars' {
        // Regress the dependent variable on independent variables with lags
        qui: reg `dep' L(1/`lags').c_cpwi L(1/`lags').c_gs L(1/`lags').c_ps L(1/`lags').c_ni L(1/`lags').c_fi L(1/`lags').c_nd date
        qui: predict temp if date == `forecast_period'  // Generate forecast
        qui: replace pred_`dep' = temp if date == `forecast_period'  // Store forecast
        qui: drop temp  // Remove temporary variable
    }
}

// Calculate R-squared for each prediction
foreach dep in `dep_vars' {
    local act `dep'  // The actual variable

    qui: summarize `act' if !missing(pred_`dep')
    local mean_act = r(mean)

    qui: gen residuals_`dep' = (`act' - pred_`dep') if !missing(pred_`dep')
    qui: gen ss_residuals_`dep' = residuals_`dep'^2 if !missing(residuals_`dep')
    qui: gen ss_total_`dep' = (`act' - `mean_act')^2 if !missing(pred_`dep')

    qui: sum ss_residuals_`dep' if !missing(ss_residuals_`dep')
    local ss_res = r(sum)
    qui: sum ss_total_`dep' if !missing(ss_total_`dep')
    local ss_tot = r(sum)

    qui: replace r2_`dep' = 1 - (`ss_res' / `ss_tot')

foreach dep in `dep_vars' {
    label variable pred_`dep' "Predicted `dep'"
    label variable r2_`dep' "R2 for `dep'"
}

gen pred_d_cpwi = l.gs * pred_c_gs + l.ps * (pred_c_ps) + l.ni * (pred_c_ni) + l.fi * (pred_c_f}

// Clean up temporary variables
drop residuals_* ss_residuals_* ss_total_*

// Add variable labels for clarityi) + l.nd * (pred_c_nd)
gen pred_c_cpwi = pred_d_cpwi / l.cpwi
gen residuals = c_cpwi - pred_c_cpwi if !missing(c_cpwi, pred_c_cpwi)
gen ss_residuals = residuals^2 if !missing(residuals)
sum ss_residuals if !missing(ss_residuals)
local ss_res = r(sum)
sum c_cpwi if !missing(c_cpwi, pred_c_cpwi)
local mean_c_cpwi = r(mean)
gen ss_total = (c_cpwi - `mean_c_cpwi')^2 if !missing(c_cpwi)
sum ss_total if !missing(ss_total)
local ss_tot = r(sum)
gen bu_r2 = 1 - (`ss_res' / `ss_tot')
drop residuals ss_residuals ss_total

// Save the annual data file
cd "$final"
save "data_quarterly.dta", replace