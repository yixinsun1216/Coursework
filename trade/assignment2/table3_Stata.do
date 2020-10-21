* Set up file paths 
clear
if "`c(username)'" == "Yixin Sun" {
   global ddir "C:/Users/Yixin Sun/Dropbox/Coursework/field_courses/International Macro and Trade/Assignments/assignment2"
   global gdir "C:/Users/Yixin Sun/Dropbox/Coursework/Coursework/trade/assignment2"
   cd "$ddir" 
}

/**************************** Instructions ****************************
Now estimate the log-linear specification of Table 1 using non-zero trade 
flows for all years (1948-2006) using reghdfe. Compare the speed of this 
calculation to the speed of estimating it in Julia using the FixedEffectModels 
package and in R using the fixest package. 
Use heteroskedastic-robust standard errors in all cases.
***********************************************************************/
use flow distw iso_o iso_d year contig comlang_off using "col_regfile09.dta", clear
drop if flow == 0

gen log_dist = ln(distw)
gen log_flow = ln(flow)
egen exp_year = group(iso_o year)
egen imp_year = group(iso_d year)
egen contig_dummy= group(contig)
egen lang_dummy= group(comlang_off)


set matsize 5000

timer clear 1
timer on 1
qui reghdfe log_flow log_dist, absorb(exp_year imp_year contig_dummy lang_dummy)
timer off 1
estimates store reg1

* output to tex
esttab reg1 using "$gdir/sunny_table1.tex", label nostar keep(log_dist) se r2 /// 
	replace type title("reghdfe Estimator") nomtitles nonumbers scalars(N) sfmt(%9.0fc) 
	
* format and output computation time to csv to be combined with Julia and R timers
timer list
scalar times1 = r(t1)
matrix times = (times1)

mat2txt, m(times) saving("$gdir/stata_time.csv") replace
	

