* Importing the data
insheet using crime-iv.csv,  names clear

* I label all the variables again
label variable republicanjudge 					"Republican Judge"
label variable severityofcrime 					"Severity of Crime"
label variable monthsinjail 					"Total months spent in jail"
label variable recidivates 						"Recidivates"


** Making Balance Tables **

global balanceopts  noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01)
estpost ttest severityofcrime, by(republicanjudge) unequal welch
esttab using balancetables.rtf, cell("mu_1(f(3)) mu_2(f(3)) b(f(3) star)") wide label collabels("Democrat Judge" "Republican Judge" "Difference") noobs $balanceopts mlabels(none) eqlabels(none) replace mgroups(none)



global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"

** Regression- First stage **

reg monthsinjail republicanjudge severityofcrime
eststo firststageregression
esttab firststageregression using regoutput.rtf, $tableoptions 


** Regression- Reduced form stage **

reg recidivates republicanjudge severityofcrime
eststo reducedformregression
esttab reducedformregression using regoutput2.rtf, $tableoptions 


** Instrumental Variable Regression - directly using ivreg2 **

ivreg2 recidivates (monthsinjail = republicanjudge)  severityofcrime
eststo ivregression
esttab ivregression using regoutput3.rtf, $tableoptions 
