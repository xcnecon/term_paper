// ------------------------------------------------------------
// Step 1: Import Quarterly Data for Analysis

cd "$final"  // Set the directory to the folder containing the final dataset
use "data_quarterly.dta", clear  // Load the quarterly data into Stata

// ------------------------------------------------------------
// Step 2: Rolling Window Forecasting with a 10-Year Lookback

local lookback = 80  // Define a 10-year rolling window (40 quarters)
local start_window = tq(1947q1) + `lookback' - 1  // Start forecasting after the 10-year lookback period
local end_window = tq(2024q1)  // End of the forecasting period (2024Q1)

gen y_hat = .  // Initialize the variable to store forecasted values

// Loop over each quarter to apply a rolling window for VAR forecasting
forvalues i = `start_window'/`end_window' {
    display "Predicting for quarter: " %tq `i'+1  // Display the quarter being predicted
    
    // Define the start and end of the 10-year rolling window (40 quarters)
    local window_start = `i' - `lookback' + 1  // Start of the rolling window (10 years back)
    local window_end = `i'  // End of the rolling window (current quarter)
    
    // Define the next quarter to forecast (one quarter ahead)
    local forecast_period = `i' + 1

    // Estimate a VAR model using the past 10 years of data, including an exogenous date variable for trend
    qui: var d_cpwi d_ps d_gs d_ni d_fi, lags(1/4) exog(date)
    
    // Generate the forecast for the next quarter (one-step ahead prediction)
    qui: predict temp if date == `forecast_period'

    // Store the forecasted value in y_hat for the predicted quarter
    qui: replace y_hat = temp if date == `forecast_period'

    // Clean up: Drop the temporary forecast variable before the next iteration
    qui: drop temp
}

// ------------------------------------------------------------
// Step 3: Evaluate the Forecast Accuracy

// Generate residuals (forecast errors) by comparing actual values to the forecasted values
gen forecast_error = d_cpwi - y_hat if !missing(y_hat)

// Step 4: Calculate Sum of Squared Errors (SSE)
gen squared_error = forecast_error^2 if !missing(y_hat)  // Calculate squared errors (residuals squared)
sum squared_error if !missing(y_hat)  // Sum the squared errors
scalar SSE = r(sum)  // Store the sum of squared errors as SSE

// Step 5: Calculate Total Sum of Squares (TSS)
sum d_cpwi if !missing(y_hat)  // Calculate the mean of actual values for the forecasted period
scalar mean_cp = r(mean)  // Store the mean of actual values
gen total_squared = (d_cpwi - mean_cp)^2 if !missing(y_hat)  // Calculate the total squared deviations from the mean
sum total_squared if !missing(y_hat)  // Sum the squared deviations
scalar TSS = r(sum)  // Store the Total Sum of Squares (TSS)

// Step 6: Calculate R-squared to Measure Forecast Accuracy
scalar R2 = 1 - (SSE / TSS)  // Compute R-squared as 1 minus the proportion of unexplained variance
display "R-squared = " R2  // Display the R-squared value

// ------------------------------------------------------------
// Step 7: Display Regression Results

label variable y_hat "Corporate Profit Delta Predicted"  // Label the predicted delta variable
reg d_cpwi y_hat if !missing(y_hat)  // Regress actual corporate profit delta on the predicted delta
estimate store model  // Store the regression results

cd "$results"  // Navigate to the results folder
esttab model using regression_results.txt, b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) /// 
    r2 ar2 nonumber replace note("") noline md mtitle("Model")  // Export regression results to a text file

// ------------------------------------------------------------
// Step 8: Visualize Actual vs Predicted Corporate Profit Delta

twoway (line d_cpwi date) (line y_hat date) if !missing(y_hat)  // Plot actual and predicted corporate profit delta
graph export "line_plot_5.png", replace  // Export the plot as a PNG file

// Generate the predicted corporate profit level (cpwi_hat) by adding the predicted delta to the previous quarter's value
gen cpwi_hat = cpwi[_n-1] + y_hat  // Create the predicted level of corporate profit
label variable cpwi_hat "Corporate Profit Predicted"  // Label the predicted corporate profit variable

// Plot actual corporate profit vs predicted corporate profit
twoway (line cpwi date) (line cpwi_hat date) if !missing(cpwi_hat)
graph export "line_plot_6.png", replace  // Export the plot as a PNG file

// This is the end. Thank you for reviewing my code!
