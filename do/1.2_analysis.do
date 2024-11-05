********************************************************************************
* 									Analysis								   *
********************************************************************************
use "$datadir/productiongap.dta", clear



**************************** Country-level analysis ****************************

* Display (not) self-sufficient countries/regions and intensity of that
foreach group in LNS SS dairy fish fruit meat veg {
	di in red "`group'"
	count if prodgap_abs_`group' >= 0 & prodgap_abs_`group' != .
	count if prodgap_abs_`group' < 0 & prodgap_abs_`group' != .
	
	bysort UNregions: tab coverage_`group'
	tab UNregions if coverage_`group' == 0
	tab UNregions if coverage_`group' == 1
	tab UNregions_det if coverage_`group' == 0
	tab UNregions_det if coverage_`group' == 1
	tab UNregions if prodgap_perc_`group' < 50 & prodgap_perc_`group' != .
	tab UNregions_det if prodgap_perc_`group' < 50 & prodgap_perc_`group' != .
}

* Display country-level self-sufficiency
fre productdeprv

count if productdeprv <= 2
di = 71/184
count if productdeprv >= 2
count if inrange(productdeprv,2,5)

fre country_name if productdeprv == 7
fre country_name if productdeprv == 6
fre country_name if productdeprv == 0

bysort UNregions: fre country_name if productdeprv <= 2
bysort UNregions_det: fre country_name if productdeprv <= 2

count if productdeprv >= 5
di = 28/184

fre UNregions if productdeprv >= 5
fre UNregions_det if productdeprv >= 5


* Food group wise self-sufficiency
foreach group in LNS SS dairy fish fruit meat veg {
	di in red "`group'"
	count if prodgap_abs_`group' >= 0 & prodgap_abs_`group' != .
	di = (`r(N)'/184)*100
	count if prodgap_abs_`group' < 0 & prodgap_abs_`group' != .
	di = (`r(N)'/184)*100
}

foreach group in SS fish meat dairy fruit  veg LNS {
	di in red "`group'"
	gen halfcover_`group' = 0 if prodgap_perc_`group' < 50 & prodgap_perc_`group' != .
	replace halfcover_`group' = 1 if prodgap_perc_`group' >= 50 & prodgap_perc_`group' != .

	bysort UNregions: tab coverage_`group'
	tab2 UNregions coverage_`group', m
	tab2 UNregions_det coverage_`group', m
	tab2 wbregion coverage_`group', m
	
	tab2 UNregions halfcover_`group', m
	tab2 UNregions_det halfcover_`group', m
	tab2 wbregion halfcover_`group', m
	
	drop halfcover_`group'
}

* Other approaches
fre productdeprv_eat
fre productdeprv_cap // not comparable bc no fruits and veggies
fre productdeprv_cap_eat // not comparable bc no fruits and veggies

* Which countries are expected to become more self-sufficient with 2032 production increase?
gen change2032 = 0
foreach group in LNS SS dairy fish meat {
	replace change2032 = change2032 + 1 if prodgap_perc_`group' < 100 & prodgap_perc_cap_`group' >= 100
}
fre change2032
/*
- Improvement by two food groups: Nepal, Timor-Leste
- Improvement by one food group: 38 countries
*/

*************************** Regional-level analysis ****************************
* Economic unions
preserve					
collapse (sum) consumption_fish consumption_fruit consumption_LNS consumption_meat consumption_dairy consumption_SS consumption_veg totpop ///
			(sum) livewell_dairy_pop livewell_fish_pop livewell_fruit_pop livewell_LNS_pop livewell_SS_pop livewell_meat_pop livewell_veg_pop, by(econunions)

drop if econunions == ""
gen productdeprv = 0
lab var productdeprv "# of groups covered"
foreach group in LNS SS dairy fish fruit meat veg {
	gen livewell_`group'_pc = livewell_`group'_pop/totpop
	
	gen prodgap_abs_`group' = ((consumption_`group'/totpop) - livewell_`group'_pc)
	lab var prodgap_abs_`group' "Absolute `group' production gap to the livewell recommendation"
	gen prodgap_perc_`group' = ((consumption_`group'/totpop)/livewell_`group'_pc)*100
	lab var prodgap_perc_`group' "Percent `group' of the livewell recommendation covered by domestic production"
	
	replace productdeprv = productdeprv + 1 if prodgap_abs_`group' >= 0 & prodgap_abs_`group' != .
}

export excel econunions prodgap_abs_* productdeprv using "$workdir/tables/regiongap.xlsx", sheet("Economic Unions", replace) cell(A1) firstrow(varlabels) keepcellfmt
export excel econunions prodgap_perc_* productdeprv using "$workdir/tables/regiongap.xlsx", sheet("Economic Unions", modify) cell(A18) firstrow(varlabels) keepcellfmt

ren productdeprv productdeprv_unions
ren prodgap_perc_* gap_perc_*_unions
tempfile unions
save `unions'

restore


* World regions
// UN regions
preserve					
collapse (sum) consumption_fish consumption_fruit consumption_LNS consumption_meat consumption_dairy consumption_SS consumption_veg totpop ///
			(sum) livewell_dairy_pop livewell_fish_pop livewell_fruit_pop livewell_LNS_pop livewell_SS_pop livewell_meat_pop livewell_veg_pop, by(UNregions)

drop if UNregions == ""
gen productdeprv = 0
lab var productdeprv "# of groups covered"
foreach group in LNS SS dairy fish fruit meat veg {
	gen livewell_`group'_pc = livewell_`group'_pop/totpop
	
	gen prodgap_abs_`group' = ((consumption_`group'/totpop) - livewell_`group'_pc)
	lab var prodgap_abs_`group' "Absolute `group' production gap to the livewell recommendation"
	gen prodgap_perc_`group' = ((consumption_`group'/totpop)/livewell_`group'_pc)*100
	lab var prodgap_perc_`group' "Percent `group' of the livewell recommendation covered by domestic production"
	
	replace productdeprv = productdeprv + 1 if prodgap_abs_`group' >= 0 & prodgap_abs_`group' != .
}


export excel UNregions prodgap_abs_* productdeprv using "$workdir/tables/regiongap.xlsx", sheet("UNregions", replace) cell(A1) firstrow(varlabels) keepcellfmt 
export excel UNregions prodgap_perc_* productdeprv using "$workdir/tables/regiongap.xlsx", sheet("UNregions", modify) cell(A10) firstrow(varlabels) keepcellfmt 

ren productdeprv productdeprv_regions
ren prodgap_perc_* gap_perc_*_regions
tempfile regions
save `regions'

restore

// detailled
preserve					
collapse (sum) consumption_fish consumption_fruit consumption_LNS consumption_meat consumption_dairy consumption_SS consumption_veg totpop ///
			(sum) livewell_dairy_pop livewell_fish_pop livewell_fruit_pop livewell_LNS_pop livewell_SS_pop livewell_meat_pop livewell_veg_pop, by(UNregions_det)

drop if UNregions_det == ""
gen productdeprv = 0
lab var productdeprv "# of groups covered"
foreach group in LNS SS dairy fish fruit meat veg {
	gen livewell_`group'_pc = livewell_`group'_pop/totpop
	
	gen prodgap_abs_`group' = ((consumption_`group'/totpop) - livewell_`group'_pc)
	lab var prodgap_abs_`group' "Absolute `group' production gap to the livewell recommendation"
	gen prodgap_perc_`group' = ((consumption_`group'/totpop)/livewell_`group'_pc)*100
	lab var prodgap_perc_`group' "Percent `group' of the livewell recommendation covered by domestic production"
	
	replace productdeprv = productdeprv + 1 if prodgap_abs_`group' >= 0 & prodgap_abs_`group' != .
}

export excel UNregions_det prodgap_abs_* productdeprv using "$workdir/tables/regiongap.xlsx", sheet("UNregions detailled", replace) cell(A1) firstrow(varlabels) keepcellfmt 
export excel UNregions_det prodgap_perc_* productdeprv using "$workdir/tables/regiongap.xlsx", sheet("UNregions detailled", modify) cell(A26) firstrow(varlabels) keepcellfmt 

ren productdeprv productdeprv_detreg
ren prodgap_perc_* gap_perc_*_detreg
tempfile detreg
save `detreg'

restore		

*** Improvement through regional integration
use "$datadir/productiongap.dta", clear
merge m:1 econunions using `unions', nogen keepusing(productdeprv_unions gap_perc_*)
merge m:1 UNregions using `regions', nogen keepusing(productdeprv_regions gap_perc_*)
merge m:1 UNregions_det using `detreg', nogen keepusing(productdeprv_detreg gap_perc_*)

* Calculate change
gen deprv_unions_chg = productdeprv_unions - productdeprv
fre deprv_unions_chg
sum deprv_unions_chg 
list country_name deprv_unions_chg if inlist(deprv_unions_chg,-4,-3,3,4,5,6) // those with large numbers benefit particularly from regional integration 


gen deprv_UNregions_det_chg = productdeprv_detreg - productdeprv
fre deprv_UNregions_det_chg
sum deprv_UNregions_det_chg
list country_name deprv_UNregions_det_chg if inlist(deprv_UNregions_det_chg,-2,5,6) // those with large numbers benefit particularly from regional integration

gen deprv_UNregions_chg = productdeprv_regions - productdeprv
fre deprv_UNregions_chg
sum deprv_UNregions_chg 
list country_name deprv_UNregions_chg if inlist(deprv_UNregions_chg,-2,5,6) 
