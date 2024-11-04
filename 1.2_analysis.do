********************************************************************************
* 									Analysis								   *
********************************************************************************
use "$datadir/productiongap.dta", clear



**************************** Country-level analysis ****************************

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


* Coverage by food group
fre productdeprv

count if productdeprv <= 2
di = 66/184
count if productdeprv >= 2

fre country_name if productdeprv == 7
fre country_name if productdeprv == 6
fre country_name if productdeprv == 0

bysort UNregions: fre country_name if productdeprv <= 2
bysort UNregions_det: fre country_name if productdeprv <= 2

count if productdeprv >= 5
di = 28/184

fre UNregions if productdeprv >= 5
fre UNregions_det if productdeprv >= 5

twoway hist productdeprv, discrete percent gap(10) ylab(, angle(0)) ytitle("Percent of countries") xlab(0(1)7) fcolor(green*0.6) lcolor(green) graphregion(color(white)) ///
	text(4.35 0 "8", size(medium) placement(n) margin(small)) ///
	text(9.78 1 "18", size(medium) placement(n) margin(small)) ///
	text(16.85 2 "31", size(medium) placement(n) margin(small)) ///
	text(25.54 3 "47", size(medium) placement(n) margin(small)) ///
	text(17.93 4 "33", size(medium) placement(n) margin(small)) ///
	text(23.37 5 "43", size(medium) placement(n) margin(small)) ///
	text(2.17 6 "4", size(medium) placement(n) margin(small)) ///
	text(0 7 "0", size(medium) placement(n) margin(small)) 
graph export "$workdir/graphs/ngap.png", replace 

* Food group wise self-sufficiency
foreach group in LNS SS dairy fish fruit meat veg {
	di in red "`group'"
	count if prodgap_abs_`group' >= 0 & prodgap_abs_`group' != .
	di = (`r(N)'/184)*100
	count if prodgap_abs_`group' < 0 & prodgap_abs_`group' != .
	di = (`r(N)'/184)*100
}

foreach group in SS  /* fish meat dairy fruit  veg LNS  */ {
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

* Fruits



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
- Improvement by one food group: 33 countries
*/


kdensity prodgap_perc_SS, addplot(kdensity prodgap_perc_cap_SS)
kdensity prodgap_perc_LNS, addplot(kdensity prodgap_perc_cap_LNS)
kdensity prodgap_perc_dairy, addplot(kdensity prodgap_perc_cap_dairy)
kdensity prodgap_perc_fish, addplot(kdensity prodgap_perc_cap_fish)
kdensity prodgap_perc_meat, addplot(kdensity prodgap_perc_cap_meat)
hist prodgap_perc_SS, color(red) addplot(hist prodgap_perc_cap_SS, color(green))


*************************** Regional-level analysis ****************************
* Economic unions (covers 107 of 184 countries)
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

export excel econunions prodgap_abs_* productdeprv using "$workdir/tables/regiongap.xlsx", sheet("Economic Unions", replace) cell(A1) firstrow(varlabels) keepcellfmt //still drop those that are not considered later
export excel econunions prodgap_perc_* productdeprv using "$workdir/tables/regiongap.xlsx", sheet("Economic Unions", modify) cell(A18) firstrow(varlabels) keepcellfmt //still drop those that are not considered later

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


export excel UNregions prodgap_abs_* productdeprv using "$workdir/tables/regiongap.xlsx", sheet("UNregions", replace) cell(A1) firstrow(varlabels) keepcellfmt //still drop those that are not considered later
export excel UNregions prodgap_perc_* productdeprv using "$workdir/tables/regiongap.xlsx", sheet("UNregions", modify) cell(A10) firstrow(varlabels) keepcellfmt //still drop those that are not considered later

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

export excel UNregions_det prodgap_abs_* productdeprv using "$workdir/tables/regiongap.xlsx", sheet("UNregions detailled", replace) cell(A1) firstrow(varlabels) keepcellfmt //still drop those that are not considered later
export excel UNregions_det prodgap_perc_* productdeprv using "$workdir/tables/regiongap.xlsx", sheet("UNregions detailled", modify) cell(A26) firstrow(varlabels) keepcellfmt //still drop those that are not considered later

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
sum deprv_unions_chg // When countries engage in intra-union trade, it leads to an average improvement in self-sufficiency of 0.40 food groups. (l. 476)
list country_name deprv_unions_chg if inlist(deprv_unions_chg,-4,-3,4,5,6) // those with large numbers benefit particularly from regional integration (Lesotho = 4 food groups)


gen deprv_UNregions_det_chg = productdeprv_detreg - productdeprv
fre deprv_UNregions_det_chg
sum deprv_UNregions_det_chg
list country_name deprv_UNregions_det_chg if inlist(deprv_UNregions_det_chg,-2,5,6) // those with large numbers benefit particularly from regional integration

gen deprv_UNregions_chg = productdeprv_regions - productdeprv
fre deprv_UNregions_chg
sum deprv_UNregions_chg //change in self-sufficiency through regional integration (l. 479)
list country_name deprv_UNregions_chg if inlist(deprv_UNregions_chg,-2,5,6) // Major beneficiaries with +6 FGs are Macao, Timor-Leste and Afghanistan


twoway kdensity deprv_unions_chg, lcolor(blue) bwidth(1) || kdensity deprv_UNregions_det_chg, lcolor(green) bwidth(1) || kdensity deprv_UNregions_chg, lcolor(red) bwidth(1)  || ///
	,xline(.6074766, lcolor(blue) lpattern(dash)) xline(.8907104, lcolor(green) lpattern(dash)) xline(1.502732, lcolor(red) lpattern(dash)) graphregion(color(white)) legend(rows(1) order(1 "Economic Unions" 2 "UN detailed regions" 3 "Continents") size(small)) xtitle("Change in dietary deprivation with regional integration if food distributed equally", size(small) margin(2))


* Kdensity for change in percentage points by food group to show which food groups are particularly important for regional trade
foreach group in LNS SS dairy fish fruit meat veg {
	gen gapchange_`group'_unions = gap_perc_`group'_unions - prodgap_perc_`group'
	gen gapchange_`group'_detreg = gap_perc_`group'_detreg - prodgap_perc_`group'
	gen gapchange_`group'_regions = gap_perc_`group'_regions - prodgap_perc_`group'
}

twoway kdensity gapchange_meat_unions , lcolor(blue) || kdensity gapchange_veg_unions , lcolor(green) || kdensity gapchange_fruit_unions , lcolor(orange) || kdensity gapchange_dairy_unions , lcolor(red) || kdensity gapchange_SS_unions , lcolor(ebblue) || kdensity gapchange_fish_unions , lcolor(gold) 
twoway kdensity gapchange_meat_detreg , lcolor(blue) || kdensity gapchange_veg_detreg , lcolor(green) || kdensity gapchange_fruit_detreg , lcolor(orange) || kdensity gapchange_dairy_detreg , lcolor(red) || kdensity gapchange_SS_detreg , lcolor(ebblue) 
twoway kdensity gapchange_meat_regions , lcolor(blue) || kdensity gapchange_veg_regions , lcolor(green) || kdensity gapchange_fruit_regions , lcolor(orange) || kdensity gapchange_dairy_regions , lcolor(red) || kdensity gapchange_SS_regions , lcolor(ebblue) || kdensity gapchange_fish_regions , lcolor(gold) 

*** Comparison with WDI 


twoway scatter prodgap_perc_meat si_pov_nahc , mcolor(midblue) msize(vsmall) mlabel(iso3) mlabcolor(midblue) || ///
		lfit prodgap_perc_meat si_pov_nahc , color(red) ///
	, /*xscale(log)*/ ytitle("Percent of self-sufficiency in meat") xtitle("Private consumption expenditure (2017 PPP)," "per capita per day, log scale") graphregion(color(white)) legend(off)
			

