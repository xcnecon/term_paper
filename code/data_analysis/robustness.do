cd "$final"
use "data_quarterly.dta", clear

cd "$results/robustness"

var d_cpwi d_ps d_gs d_ni d_fi, lags(1/8) exog(date) vce(robust)  // Estimate VAR model with lags and exogenous date
estimates store model1  // Store model estimates

esttab model1 using level_var.txt, b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    r2 nonumber note("Robust std. err. in parentheses") noline md mtitle("Corporate profit pct change") replace  // Export results

log using "granger_results.txt", replace text  // Start Granger causality log
vargranger  // Run Granger causality test
log close  // Close log file

estpost sum r2_dr_4_80 r2_dr_8_100  // Summarize R2 values
est sto r2  // Store R2 summary
esttab r2 using r2_robust.txt, cells("mean") nomtitle nonumber md replace label  // Export R2 summary


gen trans_dr_4_80 = dr_4_80 / d_cpwi[_n-1]
gen trans_dr_8_100 = dr_8_100 / d_cpwi[_n-1]
label variable trans_dr_4_80 "transformed level 4-80"
label variable trans_dr_8_100 "transformed level 8-100"

* Generate prediction graphs
twoway (line trans_dr_4_80 date) (line c_cpwi date) if !missing(d_4_80), ///
    legend(position(11) ring(0) size(small)) ylabel(#6) title("transformed level 4-80") name(g1, replace) ytitle("US dollars (billions)")
twoway (line trans_dr_8_100 date) (line c_cpwi date) if !missing(d_8_100), ///
    legend(position(11) ring(0) size(small)) ylabel(#6) title("transformed level 8-100") name(g2, replace) ytitle("US dollars (billions)")
twoway (line p_4_80 date) (line c_cpwi date) if !missing(p_4_80), ///
    legend(position(11) ring(0) size(small)) ylabel(#6) title("pct 4-80") name(g3, replace) ytitle("US dollars (billions)")
twoway (line p_8_100 date) (line c_cpwi date) if !missing(p_8_100), ///
    legend(position(11) ring(0) size(small)) ylabel(#6) title("pct 8-100") name(g4, replace) ytitle("US dollars (billions)")

graph combine g1 g2 g3 g4, col(2)  // Combine graphs in 2 columns
graph export "contrast.png", replace  // Export combined graph

estpost sum trans_dr_4_80 trans_dr_8_100 p_4_80 p_8_100
est sto c 
esttab c using compare.txt, cells("mean sd min max") nomtitle nonumber md replace label
