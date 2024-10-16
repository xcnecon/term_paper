// ------------------------------------------------------------
// Step 1: Import Quarterly Data for Analysis

cd "$final"  // Navigate to the directory containing the final dataset
use "data_quarterly.dta", clear  // Load the quarterly data into Stata
tsset date  // Set the time variable for time series analysis

// ------------------------------------------------------------
// Step 2: Generate and Export Summary Statistics

estpost summarize d_cpwi d_ps d_gs d_ni d_fi d_nd return  // Generate summary statistics for selected variables
est sto sum_stats  // Store the summary statistics in memory
cd "$results"  // Navigate to the results folder for saving output
esttab sum_stats using sum_stats.txt, cells("count mean sd min max") /// 
    nomtitle nonumber md replace label  // Export summary statistics to a text file with count, mean, sd, min, and max

// ------------------------------------------------------------
// Step 3: Create Line Plot for Multiple Variables Over Time

twoway (line cpwi date) (line ps date) (line gs date) (line nd date) (line fi date) (line ni date)  // Plot multiple variables over time
graph export "line_plot_1.png", replace 

// ------------------------------------------------------------
// Step 4: Create Line Plot to Show Identity Relationship

gen rhs = -ps -gs + fi + nd + ni  // Create a new variable based on the identity equation (right-hand side)
label variable rhs "-ps -gs + fi + nd + ni"
twoway (line rhs date) (line cpwi date) // Plot the identity variable against corporate profit
graph export "line_plot_2.png", replace 


// ------------------------------------------------------------
// Step 5: Create Scatter Plot for Identity Relationship with Adjustments

gen rhs_adjusted = rhs - discrepancy  // Adjust the rhs variable by subtracting the discrepancy term
label variable rhs_adjusted "-ps -gs + fi + nd + ni - discrepancy"
scatter cpwi rhs_adjusted, ytitle("Corporate Profit") /// 
    xtitle("Net_invest + Foreign_save + Net_div - Personal_save - Gov_save - Stat_disc")  // Create a scatter plot to compare the variables
graph export "scatter_plot_1.png", replace // Export the scatter plot as a PNG file


// ------------------------------------------------------------
// Step 6: Create Individual Line Plots for % QoQ Changes

twoway (line c_cpwi date), title("Corporate Profit %qoq") name(g1, replace)  // Line plot for corporate profit % qoq
twoway (line c_ps date), title("Personal Savings %qoq") name(g2, replace)  // Line plot for personal savings % qoq
twoway (line c_gs date), title("Government Savings %qoq") name(g3, replace)  // Line plot for government savings % qoq
twoway (line c_nd date), title("Net Dividend %qoq") name(g4, replace)  // Line plot for net dividend % qoq
twoway (line c_fi date), title("Foreign Investment %qoq") name(g5, replace)  // Line plot for foreign investment % qoq
twoway (line c_ni date), title("Net Investment %qoq") name(g6, replace)  // Line plot for net investment % qoq

graph combine g1 g2 g3 g4 g5 g6, col(2)  // Combine the line plots into one graph, arranged in two columns
graph export "line_plot_3.png", replace  // Export the combined graph as a PNG file

// ------------------------------------------------------------
// Step 7: Create Individual Line Plots for Delta QoQ Changes

twoway (line d_cpwi date), title("Corporate Profit Delta qoq") name(g1, replace)  // Line plot for corporate profit delta qoq
twoway (line d_ps date), title("Personal Savings Delta qoq") name(g2, replace)  // Line plot for personal savings delta qoq
twoway (line d_gs date), title("Government Savings Delta qoq") name(g3, replace)  // Line plot for government savings delta qoq
twoway (line d_nd date), title("Net Dividend Delta qoq") name(g4, replace)  // Line plot for net dividend delta qoq
twoway (line d_fi date), title("Foreign Investment Delta qoq") name(g5, replace)  // Line plot for foreign investment delta qoq
twoway (line d_ni date), title("Net Investment Delta qoq") name(g6, replace)  // Line plot for net investment delta qoq

graph combine g1 g2 g3 g4 g5 g6, col(2)  // Combine the delta qoq line plots into one graph, arranged in two columns
graph export "line_plot_4.png", replace  // Export the combined graph as a PNG file

// ------------------------------------------------------------
// Step 8: Run Vector Autoregression (VAR) Across the Entire Dataset

var d_cp d_ps d_gs d_ni d_fi, lags(1/4) exog(date)  // Estimate a VAR model with specified lags and exogenous date variable
estimates store model1  // Store the model estimates

// Export the VAR model results to a text file
esttab model1 using reg_table_1.txt, b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) /// 
    r2 ar2 nonumber replace note("") noline md mtitle("Model 1")  // Export coefficients, standard errors, and statistics

// ------------------------------------------------------------
// Step 9: Granger Causality Test

log using "granger_results.txt", replace text  // Start logging the Granger causality test results to a text file
vargranger  // Run the Granger causality test
log close  // Close the log file and save the results
