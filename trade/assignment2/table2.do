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
qui reghdfe log_flow log_dist if flow != 0, absorb(exp_year imp_year contig_dummy lang_dummy) ///
	residuals(res)
timer off 1
estimates store reg1 


* Reg 2: A log-linear regression that omits observations in which flow equals zero. 
* In addition, set the dependent variable to log of flow plus one.
timer clear 2
timer on 2
qui reghdfe log_flow1 log_dist if flow != 0, absorb(exp_year imp_year contig_dummy lang_dummy) 
timer off 2
estimates store reg2 

* Reg 3: A log-linear regression in which the dependent variable is log of flow plus one.
timer clear 3
timer on 3
qui reghdfe log_flow1 log_dist, absorb(exp_year imp_year contig_dummy lang_dummy) 
timer off 3
estimates store reg3 


* Reg 4: An estimate of the same constant-elasticity specification that uses the 
* ppml command to implement the PPML estimator of Silva and Tenreyro (REStat 2006). 
* Use all observations, including zeros, in this and following three columns.
timer clear 4
timer on 4
ppml flow log_dist exp_year imp_year contig_dummy lang_dummy
timer off 4
estimates store reg4


* Reg 5: An estimate of the same constant-elasticity specification that uses the 
* poi2hdfe command to implement the PPML estimator.
timer clear 5
timer on 5
poi2hdfe flow log_dist contig_dummy lang_dummy, id1(imp_year) id2(exp_year)
timer off 5
estimates store reg5


* Reg 6: An estimate of the same constant-elasticity specification that uses the 
* ppml_panel_sg command to implement the PPML estimator.
timer clear 6
timer on 6
ppml_panel_sg flow log_dist contig_dummy lang_dummy, importer(iso_d) exporter(iso_o) ///
	year(year) nopair
timer off 6
estimates store reg6

* Reg 7: An estimate of the same constant-elasticity specification that uses the 
* ppmlhdfe command to implement the PPML estimator.
timer clear 7
timer on 7
ppmlhdfe flow log_dist, absorb(imp_year exp_year i.lang_dummy i.contig_dummy)
timer off 7
estimates store reg7


* Reg 8: An estimate of the same constant-elasticity specification that uses the 
* ppmlhdfe command to implement the PPML estimator. Omit observations in which 
* flow equals zero.
timer clear 8
timer on 8
ppmlhdfe flow log_dist if flow != 0, absorb(imp_year exp_year i.lang_dummy i.contig_dummy)
timer off 8
estimates store reg8


* organize computation times into table
timer list 
scalar time1 = r(t1)
scalar time2 = r(t2)
scalar time3 = r(t3)
scalar time4 = r(t4)
scalar time5 = r(t5)
scalar time6 = r(t6)
scalar time7 = r(t7)
scalar time8 = r(t8)
matrix times = (time1, time2, time3, time4, time5, time6, time7, time8)
matrix rownames times = "Runtime (seconds)"
matrix colnames times = (1) (2) (3) (4) (5) (6) (7) (8)


* Export tables
esttab matrix(times) using "$gdir/sunny_table2_timer.tex", replace type ///
	title("Computation Time") nomtitles

esttab reg1 reg2 reg3 using "$gdir/sunny_table2.1.tex", label nostar keep(log_dist) se r2 /// 
	replace type title("Log-linear Estimation") nonumbers scalars(N) sfmt(%9.0fc) ///
	mtitles("No 0" "No 0, log(Flow + 1)" "Yes 0, log(Flow = 1)")
	
esttab reg4 reg5 reg6 reg7 reg8 using "$gdir/sunny_table2.2.tex", label nostar keep(log_dist) se r2 /// 
	replace type title("Log-linear Estimation") nonumbers scalars(N) sfmt(%9.0fc) ///
	mtitles(ppml poi2hdfe ppml_panel_sg ppmlhdfe "ppmlhdfe, No 0")
	
* export graph of residuals
grstyle init
grstyle set mesh, horizontal compact minor
twoway scatter res log_dist, title("Heteroskedasticity of Errors, Drop 0 Flow") ///
	msize(tiny) scheme(538)
graph export "table2_residuals.png", replace as(png)


* HOW DO I SAVE THIS OUTPUT?????
qui regress log_flow log_dist i.exp_year i.imp_year i.contig_dummy i.lang_dummy 
hettest
