// Please note that this program might take you 10 mins.
cd "$processed"  // Set to final dataset folder
use "data_quarterly.dta", clear  // Load quarterly data

local lookback = 80  // 10-year rolling window
local lags = 4
local start_window = tq(1947q1) + `lookback' - 1  // Forecast start
local end_window = tq(2024q1)  // Forecast end

gen d_`lags'_`lookback' = .  // Initialize forecast storage
gen dc_`lags'_`lookback' = .
gen p_`lags'_`lookback' = .  // Initialize forecast storage
gen pc_`lags'_`lookback' = .
gen dr_`lags'_`lookback' = . // robustness check

// Rolling window VAR forecasting loop
forvalues i = `start_window'/`end_window' {
    display "Predicting for: " %tq `i'+1  // Show prediction quarter
    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: var d_cpwi d_ps d_gs d_ni d_fi, lags(1/`lags') exog(date)  // VAR model
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace d_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

forvalues i = `start_window'/`end_window' {
    display "Predicting for: " %tq `i'+1  // Show prediction quarter
    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: var d_cpwi, lags(1/`lags') exog(date)  // VAR model
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace dc_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

forvalues i = `start_window'/`end_window' {
    display "Predicting for: " %tq `i'+1  // Show prediction quarter
    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: var c_cpwi c_ps c_gs c_ni c_fi, lags(1/`lags') exog(date)  // VAR model
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace p_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

forvalues i = `start_window'/`end_window' {
    display "Predicting for: " %tq `i'+1  // Show prediction quarter
    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: var c_cpwi, lags(1/`lags') exog(date)  // VAR model
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace pc_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

forvalues i = `start_window'/`end_window' {
    display "Predicting for: " %tq `i'+1  // Show prediction quarter
    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: var d_cpwi d_ps d_gs d_nd d_fi, lags(1/`lags') exog(date)  // VAR model without ni; using nd instead
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace dr_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}


local lookback = 100  // Adjust rolling window
local lags = 8
local start_window = tq(1947q1) + `lookback' - 1  // Forecast start
local end_window = tq(2024q1)  // Forecast end

gen d_`lags'_`lookback' = .  // Initialize forecast storage
gen dc_`lags'_`lookback' = .
gen p_`lags'_`lookback' = .  // Initialize forecast storage
gen pc_`lags'_`lookback' = .
gen dr_`lags'_`lookback'= . // robustness check

// Rolling window VAR forecasting loop with updated parameters
forvalues i = `start_window'/`end_window' {
    display "Predicting for: " %tq `i'+1  // Show prediction quarter
    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: var d_cpwi d_ps d_gs d_ni d_fi, lags(1/`lags') exog(date)  // VAR model
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace d_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

forvalues i = `start_window'/`end_window' {
    display "Predicting for: " %tq `i'+1  // Show prediction quarter
    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: var d_cpwi, lags(1/`lags') exog(date)  // VAR model
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace dc_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

forvalues i = `start_window'/`end_window' {
    display "Predicting for: " %tq `i'+1  // Show prediction quarter
    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: var c_cpwi c_ps c_gs c_ni c_fi, lags(1/`lags') exog(date)  // VAR model
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace p_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

forvalues i = `start_window'/`end_window' {
    display "Predicting for: " %tq `i'+1  // Show prediction quarter
    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: var c_cpwi, lags(1/`lags') exog(date)  // VAR model
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace pc_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

forvalues i = `start_window'/`end_window' {
    display "Predicting for: " %tq `i'+1  // Show prediction quarter
    
    local window_start = `i' - `lookback' + 1  // Rolling window start
    local window_end = `i'  // Rolling window end
    local forecast_period = `i' + 1  // Next quarter forecast

    qui: var d_cpwi d_ps d_gs d_nd d_fi, lags(1/`lags') exog(date)  // VAR model
    qui: predict temp if date == `forecast_period'  // One-step forecast
    qui: replace dr_`lags'_`lookback' = temp if date == `forecast_period'  // Save forecast
    qui: drop temp  // Drop temporary variable
}

// Initialize variables to store R-squared values for each prediction type
gen r2_d_4_80 = .
gen r2_dc_4_80 = .
gen r2_p_4_80 = .
gen r2_pc_4_80 = .
gen r2_d_8_100 = .
gen r2_dc_8_100 = .
gen r2_p_8_100 = .
gen r2_pc_8_100 = .
gen r2_dr_4_80= .
gen r2_dr_8_100 =.

// Define macros for prediction types and their actual variables
local predictions "d_4_80 dc_4_80 p_4_80 pc_4_80 d_8_100 dc_8_100 p_8_100 pc_8_100 dr_4_80 dr_8_100"
local actuals "d_cpwi d_cpwi c_cpwi c_cpwi d_cpwi d_cpwi c_cpwi c_cpwi d_cpwi d_cpwi"

// Loop over each prediction type to calculate R-squared
forvalues i = 1/10 {
    local pred : word `i' of `predictions'
    local act : word `i' of `actuals'

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

label variable d_4_80 "Predicted level change"
label variable dc_4_80 "Predicted level change"
label variable d_8_100 "Predicted level change"
label variable dc_8_100 "Predicted level change"
label variable p_4_80 "Predicted pct change"
label variable pc_4_80 "Predicted pct change"
label variable p_8_100 "Predicted pct change"
label variable pc_8_100 "Predicted pct change"
label variable dr_4_80 "Predicted level change"
label variable dr_8_100 "Predicted level change"

cd "$final"
save "data_quarterly.dta", replace
