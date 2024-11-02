cd "$final"
use "data_quarterly.dta", clear

cd "$results/robustness"

var d_cpwi d_ps d_gs d_ni d_fi, lags(1/8) exog(date) vce(robust)  // Estimate VAR model with lags and exogenous date
estimates store model1  // Store model estimates

esttab model1 using level_var.txt, b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    r2 ar2 nonumber note("") noline md mtitle("Corporate profit pct change") replace  // Export results

log using "granger_results.txt", replace text  // Start Granger causality log
vargranger  // Run Granger causality test
log close  // Close log file

reg d_cpwi d_4_80, robust
estimate store m1
reg d_cpwi dc_4_80, robust
estimate store m2
reg c_cpwi p_4_80, robust
estimate store m3
reg c_cpwi pc_4_80, robust
estimate store m4
esttab m1 m2 m3 m4 using reg1.txt, b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    r2 nonumber replace note("") noline md label mtitle("Level 4-80" "Level control 4-80" "Pct 4-80" "Pct control 4-80")

reg d_cpwi dr_4_80, robust
estimates store m5
reg d_cpwi dr_8_100, robust
estimates store m6
esttab m1 m2 m3 m4 using reg2.txt, b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    r2 nonumber replace note("") noline md label mtitle("Level 4-80" "Level 8-100")
