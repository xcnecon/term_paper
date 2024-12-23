cd "$final"
use "data_quarterly.dta", clear  // Load quarterly data
cd "$robustness"

// More Specifications: Summarize R2 Values
estpost sum r2_p_12_120 r2_p_16_160 r2_dr_4_80 r2_dr_8_100  // Summarize R2 values for different specifications
est sto r2  // Store the R2 summary
esttab r2 using r2_robust.txt, cells("mean") nomtitle nonumber md replace label  // Export R2 summary

// Annual Data Analysis
cd "$final"
use "data_annual.dta", clear  // Load annual data
cd "$robustness"
estpost sum r2_p_4_40 r2_p_6_60 r2_p_4_60  // Summarize R2 values for annual data specifications
est sto r2  // Store the R2 summary
esttab r2 using r2_robust_annual.txt, cells("mean") nomtitle nonumber md replace label  // Export R2 summary

// Plot Predictions for Annual Data
twoway (line p_4_40 date) (line c_cpwi date) if !missing(p_4_40), ///
    legend(position(11) ring(0) size(small)) ylabel(#6) title("4-40") name(g1, replace) ytitle("US dollars (billions)")
twoway (line p_6_60 date) (line c_cpwi date) if !missing(p_6_60), ///
    legend(position(11) ring(0) size(small)) ylabel(#6) title("6-60") name(g2, replace) ytitle("US dollars (billions)")

graph combine g1 g2, col(2)  // Combine the two graphs in 2 columns
graph export "prediction_annual.png", replace  // Export the combined graph


// sp500 earnings
cd "$final"
use "data_quarterly.dta", clear  // Load quarterly data
cd "$robustness"
scalar benchmark_spe = earnings[1]
gen spe_index = earnings / benchmark_spe
label variable spe_index "Index for SP500 earnings"
scalar benchmark_nipa = cpwi[1]
gen cpwi_index = cpwi / benchmark_nipa
label variable cpwi_index "Index for NIPAs Corporate Earnings"

twoway (line spe_index date)(line cpwi_index date), legend(position(11) ring(0) size(small)) title("SP500 earnings vs NIPAs profit")
graph export "SPvsNIPAs.png", replace

list r2_spe_4_80 r2_spe_8_100 r2_spe_12_120 if _n == 1

// the bottom-up appraoch
list r2_c_gs r2_c_ps r2_c_ni r2_c_fi r2_c_nd if _n == 1