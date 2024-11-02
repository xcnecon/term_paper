// ------------------------------------------------------------
// Step 1: Import Quarterly Data for Analysis

cd "$final"  // Navigate to the directory containing the final dataset
use "data_quarterly.dta", clear  // Load the quarterly data into Stata
tsset date  // Set the time variable for time series analysis

// ------------------------------------------------------------
// Step 3: Create Line Plot for Multiple Variables Over Time

twoway (line cpwi date) (line ps date) (line gs date) (line nd date) (line fi date) (line ni date) if date < tq(1980q1), legend(position(11) ring(0) size(small)) ylabel(#6) title("1947Q1-1979Q4") name(g1, replace) ytitle("US dollars (billions)")
	
twoway (line cpwi date) (line ps date) (line gs date) (line nd date) (line fi date) (line ni date) if date >= tq(1980q1), legend(position(11) ring(0) size(small)) ylabel(#6) title("1980Q1-2024Q2") name(g2, replace) ytitle("US dollars (billions)")

graph combine g1 g2, col(2)
graph export "series.png", replace


// ------------------------------------------------------------
// Step 4: Create Line Plot to Show Identity Relationship

gen rhs = -ps -gs + fi + nd + ni  // Create a new variable based on the identity equation (right-hand side)
label variable rhs "RHS without adjustment"
twoway (line rhs date) (line cpwi date), ///
	legend(position(11) ring(0) size(small)) ///
	name(g1, replace) ///
	title("Corporate Profit & RHS") ///
	ytitle("US dollars (billions)") ///
	ylabel(#6)

gen rhs_adjusted = rhs - discrepancy  // Adjust the rhs variable by subtracting the discrepancy term
label variable rhs_adjusted "RHS with adjustment for discrepancy"
scatter cpwi rhs_adjusted, /// 
	legend(position(11) ring(0) size(small)) ///
	name(g2, replace) ///
	title("Corporate Profit & RHS with Adjustment") ///
	ytitle("US dollars (billions)") ///
	ylabel(#6)

graph combine g1 g2, col(2)
graph export "identity.png", replace
// ------------------------------------------------------------
// Step 6: Create Individual Line Plots for % QoQ Changes

twoway (line c_cpwi date), title("Corporate Profit %qoq") name(g1, replace)  // Line plot for corporate profit % qoq
twoway (line c_ps date), title("Personal Savings %qoq") name(g2, replace)  // Line plot for personal savings % qoq
twoway (line c_gs date), title("Government Savings %qoq") name(g3, replace)  // Line plot for government savings % qoq
twoway (line c_nd date), title("Net Dividend %qoq") name(g4, replace)  // Line plot for net dividend % qoq
twoway (line c_fi date), title("Foreign Investment %qoq") name(g5, replace)  // Line plot for foreign investment % qoq
twoway (line c_ni date), title("Net Investment %qoq") name(g6, replace)  // Line plot for net investment % qoq

graph combine g1 g2 g3 g4 g5 g6, col(2)  // Combine the line plots into one graph, arranged in two columns
graph export "series_pct.png", replace  // Export the combined graph as a PNG file

// ------------------------------------------------------------
// Step 7: Create Individual Line Plots for Delta QoQ Changes

twoway (line d_cpwi date), title("Corporate Profit Delta qoq") name(g1, replace)  // Line plot for corporate profit delta qoq
twoway (line d_ps date), title("Personal Savings Delta qoq") name(g2, replace)  // Line plot for personal savings delta qoq
twoway (line d_gs date), title("Government Savings Delta qoq") name(g3, replace)  // Line plot for government savings delta qoq
twoway (line d_nd date), title("Net Dividend Delta qoq") name(g4, replace)  // Line plot for net dividend delta qoq
twoway (line d_fi date), title("Foreign Investment Delta qoq") name(g5, replace)  // Line plot for foreign investment delta qoq
twoway (line d_ni date), title("Net Investment Delta qoq") name(g6, replace)  // Line plot for net investment delta qoq

graph combine g1 g2 g3 g4 g5 g6, col(2)  // Combine the delta qoq line plots into one graph, arranged in two columns
graph export "series_level.png", replace  // Export the combined graph as a PNG file
