* Set up file paths 
clear
if "`c(username)'" == "Yixin Sun" {
   global ddir "C:/Users/Yixin Sun/Dropbox/Coursework/field_courses/International Macro and Trade/Assignments/assignment2"
   global gdir "C:/Users/Yixin Sun/Dropbox/Coursework/Coursework/trade/assignment2"
   cd "$ddir" 
}

/**************************** Instructions ****************************
Estimate a regression of log (non-zero) trade flows on log bilateral distance, 
a contiguity indicator, a common-language indicator, exporter-year fixed effects, 
and importer-year fixed effects for the years 2000-2006. 

When using reg, you will have to create the fixed-effect dummies. 
When using the xtreg, areg, and reghdfe commands, use the fixed-effect options 
to absorb them. 

Report the computation time associated with each estimator.

***********************************************************************/

* Load and format data
* flow
* distw: population weighted distance
* iso_o: origin country
* year
* iso_d: destination country
* contig: contiguity
* comlang_off: common language 
use flow distw iso_o iso_d year contig comlang_off using "col_regfile09.dta", clear
drop if year < 2000 | year > 2006
drop if flow == 0

gen log_dist = ln(distw)
gen log_flow = ln(flow)
egen exp_year = group(iso_o year)
egen imp_year = group(iso_d year)
egen contig_dummy= group(contig)
egen lang_dummy= group(comlang_off)

set matsize 5000

* First regression - regress
timer clear 1
timer on 1
qui regress log_flow log_dist i.exp_year i.imp_year i.contig_dummy i.lang_dummy 
timer off 1
estimates store reg1

* Second regression - xtreg
* the within R-squared is obtained in a manner that assumes that groups
* (import-year dummies) are fixed quantities, so their effects are removed from 
* the model
xtset exp_year
timer clear 2
timer on 2
qui xtreg log_flow log_dist i.imp_year i.contig_dummy i.lang_dummy, fe
timer off 2
estimates store reg2

* Third regression - areg
timer clear 3
timer on 3
qui areg log_flow log_dist i.exp_year i.lang_dummy i.contig_dummy, absorb(imp_year)
timer off 3
estimates store reg3

* Fourth regression - reghdfe
* reghdfe drops singleton groups - probably what explains the different N as 
* compared to the other groups
timer clear 4
timer on 4
qui reghdfe log_flow log_dist, absorb(exp_year imp_year contig_dummy lang_dummy)
timer off 4
estimates store reg4

* organize computation times into table
timer list 
scalar time1 = r(t1)
scalar time2 = r(t2)
scalar time3 = r(t3)
scalar time4 = r(t4)
matrix times = (time1, time2, time3, time4)
matrix rownames times = "Runtime (seconds)"
matrix colnames times = reg xtreg areg reghdfe


* Export tables
esttab matrix(times) using "$gdir/sunny_table1_timer.tex", replace type ///
	title("Computation Time") nomtitles

esttab * using "$gdir/sunny_table1.tex", label nostar keep(log_dist) se r2 /// 
	replace type title("Log-linear Estimation") mtitles(reg xtreg areg reghdfe) ///
	nonumbers scalars(N) sfmt(%9.0fc) 
