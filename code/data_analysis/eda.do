// import quarterly data for analysis
cd "$final"
use "data_quarterly.dta", clear
tsset date // setting time variable for ts analysis


//

// vector autoregression across the entire dataset
var d_cp d_ps d_gs d_ni d_fi, lags(1/4) exog(date)

// granger causality test
vargranger
