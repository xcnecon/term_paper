// import cbo projection file
cd "$raw"
import delimited "cbo_projection", clear

// only keep deficit forecast
keep if component == "deficit"

// only keep forecasts for next year
gen is_nextyear = projected_fiscal_year - real(substr(baseline_date, 1, 4))
keep if is_nextyear == 1
drop is_nextyear

// only keep the last forecasts for the next year
bysort projected_fiscal_year: gen is_last = _n == _N
keep if is_last

// keep useful variables and rename
keep baseline_date projected_fiscal_year value
rename (baseline_date projected_fiscal_year) (forecast_date forecasted_date)

// save
cd "$processed"
save "cbo_annual"
