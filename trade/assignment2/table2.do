* Set up file paths 
clear
if "`c(username)'" == "Yixin Sun" {
   global ddir "C:/Users/Yixin Sun/Dropbox/Coursework/field_courses/International Macro and Trade/Assignments/assignment2"
   global gdir "C:/Users/Yixin Sun/Dropbox/Coursework/Coursework/trade/assignment2"
   cd "$ddir" 
}

/**
Now we examine the roles of zeros in the trade-flow matrix. Run a regression for 
the years 2004-2006 with the same covariates as above. Use Stata estimators and 
the following specifications to produce a table containing 8 columns:
**/
use flow distw iso_o iso_d year contig comlang_off using "col_regfile09.dta", clear
drop if year < 2004 | year > 2006
gen log_dist = ln(distw)
gen log_flow = ln(flow)
gen log_flow1 = ln(flow + 1)
egen exp_year = group(iso_o year)
egen imp_year = group(iso_d year)
egen contig_dummy= group(contig)
egen lang_dummy= group(comlang_off)

set matsize 5000

* Reg 1: A log-linear regression that omits observations in which flow equals zero.
timer clear 1
timer on 1
qui reghdfe log_flow log_dist, absorb(exp_year imp_year contig_dummy lang_dummy) residuals(res)
estimates store reg1 
timer off 1


* Reg 2: A log-linear regression that omits observations in which flow equals zero. 
* In addition, set the dependent variable to log of flow plus one.
timer clear 2
timer on 2
qui reghdfe log_flow1 log_dist if flow != 0, absorb(exp_year imp_year contig_dummy lang_dummy) 
estimates store reg2 
timer off 2

* Reg 3: A log-linear regression in which the dependent variable is log of flow plus one.
timer clear 3
timer on 3
qui reghdfe log_flow1 log_dist, absorb(exp_year imp_year contig_dummy lang_dummy) 
estimates store reg3 
timer off 3


* Reg 4: An estimate of the same constant-elasticity specification that uses the 
* ppml command to implement the PPML estimator of Silva and Tenreyro (REStat 2006). 
* Use all observations, including zeros, in this and following three columns.
timer clear 4
timer on 4
ppml log_flow log_dist exp_year imp_year contig_dummy lang_dummy
timer off 4


* Reg 5: An estimate of the same constant-elasticity specification that uses the 
* poi2hdfe command to implement the PPML estimator.
timer clear 5
timer on 5

timer off 5


* Reg 6: An estimate of the same constant-elasticity specification that uses the 
* ppml_panel_sg command to implement the PPML estimator.
timer clear 6
timer on 6

timer off 6


* Reg 7: An estimate of the same constant-elasticity specification that uses the 
* ppmlhdfe command to implement the PPML estimator.
timer clear 7
timer on 7

timer off 7


* Reg 8: An estimate of the same constant-elasticity specification that uses the 
* ppmlhdfe command to implement the PPML estimator. Omit observations in which 
* flow equals zero.
timer clear 8
timer on 8

timer off 8
