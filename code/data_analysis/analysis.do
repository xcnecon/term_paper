cd "$final"
use "data_quarterly.dta", clear

cd "$results/analysis"

var c_cpwi c_ps c_gs c_ni c_fi c_nd, lags(1/8) exog(date) vce(robust)  // Estimate VAR model with lags and exogenous date
estimates store model1  // Store model estimates

esttab model1 using pct_var.txt, b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    r2 ar2 nonumber note("") noline md mtitle("Corporate profit pct change") replace  // Export results

log using "granger_results.txt", replace text  // Start Granger causality log
vargranger  // Run Granger causality test
log close  // Close log file

reg d_cpwi d_8_100, robust
estimate store m1
reg d_cpwi dc_8_100, robust
estimate store m2
reg c_cpwi p_8_100, robust
estimate store m3
reg c_cpwi pc_8_100, robust
estimate store m4

esttab m1 m2 m3 m4 using reg1.txt, b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    r2 nonumber replace note("") noline md label mtitle("Level 8-100" "Level control 8-100" "Pct 8-100" "Pct control 8-100")
