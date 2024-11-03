cd "$final"
use "data_quarterly.dta", clear  // Load the quarterly data file

cd "$results/analysis"

var c_cpwi c_ps c_gs c_ni c_fi c_nd, lags(1/8) exog(date) vce(robust)  // Run VAR model with lags and robust errors
estimates store model1  // Save the VAR model

esttab model1 using pct_var.txt, b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    r2 nonumber note("Robust std. err. in parentheses") noline md mtitle("Corporate profit pct change") replace  // Export model results

log using "granger_pct.txt", replace text  // Open log for Granger causality test
vargranger  // Run the Granger causality test
log close  // Close the log

var d_cpwi d_ps d_gs d_ni d_fi, lags(1/8) exog(date) vce(robust)  // Run VAR model with differenced data
estimates store model2  // Save the model

esttab model2 using level_var.txt, b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    r2 nonumber note("Robust std. err. in parentheses") noline md mtitle("Corporate profit pct change") replace  // Export results

log using "granger_lvl.txt", replace text  // Open log for Granger causality test
vargranger  // Run the Granger causality test
log close  // Close the log file

estpost sum r2_p_4_80 r2_pc_4_80 r2_p_8_100 r2_pc_8_100 r2_d_4_80 r2_d_8_100 // Summarize R2 values
est sto r2  // Save the summary
esttab r2 using r2.txt, cells("mean") nomtitle nonumber md replace label  // Export R2 summary

* Generate prediction graphs
twoway (line d_4_80 date) (line c_cpwi date) if !missing(d_4_80), ///
    legend(position(11) ring(0) size(small)) ylabel(#6) title("Level 4-80") name(g1, replace) ytitle("US dollars (billions)")
twoway (line d_8_100 date) (line c_cpwi date) if !missing(d_8_100), ///
    legend(position(11) ring(0) size(small)) ylabel(#6) title("Level 8-100") name(g2, replace) ytitle("US dollars (billions)")
twoway (line p_4_80 date) (line c_cpwi date) if !missing(p_4_80), ///
    legend(position(11) ring(0) size(small)) ylabel(#6) title("Pct 4-80") name(g3, replace) ytitle("US dollars (billions)")
twoway (line p_8_100 date) (line c_cpwi date) if !missing(p_8_100), ///
    legend(position(11) ring(0) size(small)) ylabel(#6) title("Pct 8-100") name(g4, replace) ytitle("US dollars (billions)")

graph combine g1 g2 g3 g4, col(2)  // Combine graphs into 2 columns
graph export "prediction.png", replace  // Save the combined graph

estpost sum d_4_80 d_8_100 p_4_80 p_8_100 c_cpwi
est sto sum_stats
esttab sum_stats using sum_stats.txt, cells("mean sd min max") nomtitle nonumber md replace label  // Export summary statistics