cd "$final"
use "data_quarterly.dta", clear  // Load dataset

cd "$results/analysis"

var c_cpwi c_ps c_gs c_ni c_fi c_nd, lags(1/8) exog(date) vce(robust)  // Estimate VAR model with lags
estimates store model1  // Store model

esttab model1 using pct_var.txt, b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    r2 nonumber note("Robust std. err. in parentheses") noline md mtitle("Corporate profit pct change") replace  // Export results

log using "granger_results.txt", replace text  // Start Granger causality log
vargranger  // Perform Granger causality test
log close  // End log

estpost sum r2_d_4_80 r2_dc_4_80 r2_p_4_80 r2_pc_4_80 r2_d_8_100 r2_dc_8_100 r2_p_8_100 r2_pc_8_100  // Summarize R2 values
est sto r2  // Store R2 summary
esttab r2 using r2.txt, cells("mean") nomtitle nonumber md replace label  // Export R2 summary

* Generate prediction graphs
twoway (line d_4_80 date) (line d_cpwi date) if !missing(d_4_80), ///
    legend(position(11) ring(0) size(small)) ylabel(#6) title("level 4-80") name(g1, replace) ytitle("US dollars (billions)")
twoway (line d_8_100 date) (line d_cpwi date) if !missing(d_8_100), ///
    legend(position(11) ring(0) size(small)) ylabel(#6) title("level 8-100") name(g2, replace) ytitle("US dollars (billions)")
twoway (line p_4_80 date) (line c_cpwi date) if !missing(p_4_80), ///
    legend(position(11) ring(0) size(small)) ylabel(#6) title("pct 4-80") name(g3, replace) ytitle("US dollars (billions)")
twoway (line p_8_100 date) (line c_cpwi date) if !missing(p_8_100), ///
    legend(position(11) ring(0) size(small)) ylabel(#6) title("pct 8-100") name(g4, replace) ytitle("US dollars (billions)")

graph combine g1 g2 g3 g4, col(2)  // Combine graphs in 2 columns
graph export "prediction.png", replace  // Export combined graph
