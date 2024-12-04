cd "/Users/xieyufei/Desktop/PhD/1.1/280 Computing/*hw/part4/econ280project/"

global data "data/"
global results "results/"

cap erase "${results}table1.xls"
cap erase "${results}table1.txt"


/// gender
use "${data}ms_blel_jpal_long", clear
duplicates drop st_id, force
tempfile gender
save `gender'


/// table 1a: math

use "${data}ms_blel_jpal_long", clear
				
///	merge with % correct data

merge 1:1 st_id round using "${data}ms_blel_forirt", keep(master match) keepus(cm*) nogen	
						
///	keep key vars
			
keep st_id round strata cm* m_theta_mle h_theta_mle treat
				
///	reshape wide

reshape wide h_theta* m_theta* cm*, i(st_id strata) j(round)

/// merge gender

merge 1:1 st_id using `gender', keep(master match) keepus(st_female1) nogen
gen treat_fem=treat*st_female1
lab var treat_fem "Treatment * Female"
			
///	run regressions

xtreg cm_arithmetic2 treat st_female1 treat_fem m_theta_mle1, robust i(strata) fe
outreg2 using "${results}table1.xls", label less(1) keep(treat m_theta_mle1 treat_fem) replace noaster
			
foreach v in cm_word_compute2 cm_data2 cm_fraction2 cm_geometry2 ///
cm_number2 cm_patterns2 {			
	xtreg `v' treat st_female1 treat_fem m_theta_mle1, robust i(strata) fe
	outreg2 using "${results}table1.xls", label less(1) keep(treat m_theta_mle1 treat_fem) append noaster
}

/// table 1b: hindi

/// load j-pal data long

use "${data}ms_blel_jpal_long", clear
				
///	merge with % correct data
			
merge 1:1 st_id round using "${data}ms_blel_forirt", keep(master match) keepus(ch*) nogen	
						
///	keep key vars
			
keep st_id round strata ch* m_theta_mle h_theta_mle treat
				
///	reshape wide
			
reshape wide h_theta* m_theta* ch*, i(st_id strata) j(round)

/// merge gender

merge 1:1 st_id using `gender', keep(master match) keepus(st_female1) nogen
gen treat_fem=treat*st_female1
lab var treat_fem "Treatment * Female"
		
xtreg ch_sentence2 treat st_female1 treat_fem h_theta_mle1, robust i(strata) fe
outreg2 using "${results}table1.xls", label less(1) keep(treat h_theta_mle1 treat_fem) append noaster
			
foreach v in ch_retrieve2 ch_inference2 ch_interpret2 {			
	xtreg `v' treat st_female1 treat_fem h_theta_mle1, robust i(strata) fe
	outreg2 using "${results}table1.xls", label less(1) keep(treat h_theta_mle1 treat_fem) append noaster
}






