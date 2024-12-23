// ------------------------------------------------------------
// Step 1: Load Quarterly Data

cd "$final"  // Navigate to the data directory
use "data_quarterly.dta", clear  // Load quarterly data
tsset date  // Set the time variable for time series analysis

// ------------------------------------------------------------
// Step 3: Plot Variables Over Time (Pre- and Post-1980)

twoway (line cpwi date) (line ps date) (line gs date) (line nd date) (line fi date) (line ni date) if date < tq(1980q1), ///
    legend(position(11) ring(0) size(small)) ylabel(#6) title("1947Q1-1979Q4") name(g1, replace) ytitle("US dollars (billions)")

twoway (line cpwi date) (line ps date) (line gs date) (line nd date) (line fi date) (line ni date) if date >= tq(1980q1), ///
    legend(position(11) ring(0) size(small)) ylabel(#6) title("1980Q1-2024Q2") name(g2, replace) ytitle("US dollars (billions)")

graph combine g1 g2, col(2)
cd "$eda"
graph export "series.png", replace

// ------------------------------------------------------------
// Step 4: Plot Corporate Profit Identity Relationship

gen rhs = -ps -gs + fi + nd + ni  // Calculate the right-hand side (RHS) of the identity equation
label variable rhs "RHS without adjustment"
twoway (line rhs date) (line cpwi date), legend(position(11) ring(0) size(small)) name(g1, replace) ///
    title("Corporate Profit & RHS") ytitle("US dollars (billions)") ylabel(#6)

gen rhs_adjusted = rhs - discrepancy  // Adjust RHS by subtracting discrepancy
label variable rhs_adjusted "RHS with adjustment for discrepancy"
scatter cpwi rhs_adjusted, legend(position(11) ring(0) size(small)) name(g2, replace) ///
    title("Corporate Profit & RHS with Adjustment") ytitle("US dollars (billions)") ylabel(#6)

graph combine g1 g2, col(2)
graph export "identity.png", replace

// ------------------------------------------------------------
// Step 6: Plot % QoQ Changes for Variables

twoway (line c_cpwi date), title("Corporate Profit %qoq") name(g1, replace)
twoway (line c_ps date), title("Personal Savings %qoq") name(g2, replace)
twoway (line c_gs date), title("Government Savings %qoq") name(g3, replace)
twoway (line c_nd date), title("Net Dividend %qoq") name(g4, replace)
twoway (line c_fi date), title("Foreign Saving %qoq") name(g5, replace)
twoway (line c_ni date), title("Net Investment %qoq") name(g6, replace)

graph combine g1 g2 g3 g4 g5 g6, col(2)  // Combine all %qoq plots in two columns
graph export "series_pct.png", replace  // Save the combined graph

// ------------------------------------------------------------
// Step 7: Plot Delta QoQ Changes for Variables

twoway (line d_cpwi date), title("Corporate Profit Delta qoq") name(g1, replace)
twoway (line d_ps date), title("Personal Savings Delta qoq") name(g2, replace)
twoway (line d_gs date), title("Government Savings Delta qoq") name(g3, replace)
twoway (line d_nd date), title("Net Dividend Delta qoq") name(g4, replace)
twoway (line d_fi date), title("Foreign Saving Delta qoq") name(g5, replace)
twoway (line d_ni date), title("Net Investment Delta qoq") name(g6, replace)

graph combine g1 g2 g3 g4 g5 g6, col(2)  // Combine all delta qoq plots in two columns
graph export "series_level.png", replace  // Save the combined graph
