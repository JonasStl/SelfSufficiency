********************************************************************************
*									Analyse									   *
********************************************************************************
use "$datadir/timetrends_productiongap.dta", clear

* Globals
global coverage_EAT = "eatcoverage_fruit eatcoverage_veg eatcoverage_dairy eatcoverage_fish eatcoverage_meat eatcoverage_LNS eatcoverage_SS"
global coverage_LW = "coverage_fruit coverage_veg coverage_dairy coverage_fish coverage_meat coverage_LNS coverage_SS"
global prodgap_LW = "prodgap_perc_fruit prodgap_perc_veg prodgap_perc_dairy prodgap_perc_fish prodgap_perc_meat prodgap_perc_LNS prodgap_perc_SS"
global prodgap_EAT = "eatgap_perc_fruit eatgap_perc_veg eatgap_perc_dairy eatgap_perc_fish eatgap_perc_meat eatgap_perc_LNS eatgap_perc_SS"


foreach var of varlist $coverage_LW {
	di in red "`var'"
	forv yr = 2010(1)2032 {
		di in red "`yr'"
		count if `var' == . & year == `yr'
		count if `var' != . & year == `yr'
	} 
}


* Identify 2010 samples
foreach var of varlist $coverage_LW {
	gen _`var'_N2010 = 1 if `var' < . & year == 2010
	bysort country_name: egen `var'_N2010 = max(_`var'_N2010)
	
	gen _`var'_N2019 = 1 if `var' < . & year == 2019
	bysort country_name: egen `var'_N2019 = max(_`var'_N2019)
	
	gen  `var'_Nrestrict = 1 if `var'_N2010 == 1 & `var'_N2019 == 1
	
	drop _`var'_N2010 _`var'_N2019
}

foreach var of varlist $coverage_LW {
	di in red "`var'"
	forv yr = 2010(1)2032 {
		di in red "`yr'"		
		count if `var'_Nrestrict == . & year == `yr'
		count if `var'_Nrestrict != . & year == `yr'
	} 
}

* Keep restricted sample
keep if coverage_SS_Nrestrict == 1



* Calculate Means
preserve
collapse (mean) productdeprv productdeprv_eat coverage_LNS eatcoverage_LNS coverage_SS eatcoverage_SS coverage_dairy eatcoverage_dairy coverage_fish eatcoverage_fish coverage_fruit eatcoverage_fruit coverage_meat eatcoverage_meat coverage_veg eatcoverage_veg ///
	(sum) coverage_LNS_N=coverage_LNS coverage_SS_N=coverage_SS coverage_dairy_N=coverage_dairy coverage_fish_N=coverage_fish coverage_fruit_N=coverage_fruit coverage_meat_N=coverage_meat coverage_veg_N=coverage_veg ///
	(count) coverage_fruit_Nrestrict coverage_veg_Nrestrict coverage_dairy_Nrestrict coverage_fish_Nrestrict coverage_meat_Nrestrict coverage_LNS_Nrestrict coverage_SS_Nrestrict, by(year)

gen UNregions = "World"

tempfile world_projections
save `world_projections'

restore
collapse (mean) productdeprv productdeprv_eat coverage_LNS eatcoverage_LNS coverage_SS eatcoverage_SS coverage_dairy eatcoverage_dairy coverage_fish eatcoverage_fish coverage_fruit eatcoverage_fruit coverage_meat eatcoverage_meat coverage_veg eatcoverage_veg ///
	(sum) coverage_LNS_N=coverage_LNS coverage_SS_N=coverage_SS coverage_dairy_N=coverage_dairy coverage_fish_N=coverage_fish coverage_fruit_N=coverage_fruit coverage_meat_N=coverage_meat coverage_veg_N=coverage_veg, by(UNregions year)

append using `world_projections'

foreach var of varlist coverage_LNS eatcoverage_LNS coverage_SS eatcoverage_SS coverage_dairy eatcoverage_dairy coverage_fish eatcoverage_fish coverage_fruit eatcoverage_fruit coverage_meat eatcoverage_meat coverage_veg eatcoverage_veg {
	replace `var' = `var'*100
}

global lbl_LNS = "Legumes, nuts and seeds"
global lbl_SS = "Starchy staples"
global lbl_dairy = "Dairy products"
global lbl_fish = "Fish and seafood"
global lbl_meat = "Meat"
global lbl_fruit = "Fruits"
global lbl_veg = "Vegetables"

*-------------------------------
*** SI Figure 5: Coverage yes/no 
*-------------------------------
graph set window fontface "Times New Roman"

foreach group in LNS SS dairy fish meat {
	qui sum coverage_`group'_Nrestrict if UNregions == "World" & year == 2010
	local Nnote = `r(sum)'
	
	twoway ///
	(line coverage_`group' year if UNregions == "Africa" & inrange(year,2010,2022), lcolor(gold*0.9)) ///
	(line coverage_`group' year if UNregions == "Americas" & inrange(year,2010,2022), lcolor(red*0.9)) ///
	(line coverage_`group' year if UNregions == "Asia" & inrange(year,2010,2022), lcolor(green*0.9)) ///
	(line coverage_`group' year if UNregions == "Europe" & inrange(year,2010,2022), lcolor(dkorange*0.9) ) ///
	(line coverage_`group' year if UNregions == "Middle East" & inrange(year,2010,2022), lcolor(sienna*0.9)) ///
	(line coverage_`group' year if UNregions == "Oceania"& inrange(year,2010,2022), lcolor(midblue*0.9)) ///
	(line coverage_`group' year if UNregions == "World" & inrange(year,2010,2022), lcolor(black) lpattern(dash)) ///
	(line coverage_`group' year if UNregions == "Africa" & inrange(year,2022,2032), lcolor(gold*0.9) lpattern(shortdash_dot)) ///
	(line coverage_`group' year if UNregions == "Americas" & inrange(year,2022,2032), lcolor(red*0.9) lpattern(shortdash_dot)) ///
	(line coverage_`group' year if UNregions == "Asia" & inrange(year,2022,2032), lcolor(green*0.9) lpattern(shortdash_dot)) ///
	(line coverage_`group' year if UNregions == "Europe" & inrange(year,2022,2032), lcolor(dkorange*0.9) lpattern(shortdash_dot)) ///
	(line coverage_`group' year if UNregions == "Middle East" & inrange(year,2022,2032), lcolor(sienna*0.9) lpattern(shortdash_dot)) ///
	(line coverage_`group' year if UNregions == "Oceania" & inrange(year,2022,2032), lcolor(midblue*0.9) lpattern(shortdash_dot)) ///
	(line coverage_`group' year if UNregions == "World" & inrange(year,2022,2032), lcolor(black) lpattern(shortdash_dot)) ///
	, graphregion(color(white)) ytitle("") xtitle("") xlab(2010(5)2030, labsize(small)) yscale(range(0 100)) ylab(0(20)100, angle(0) labsize(small)) xscale(range(2010 2032)) name(map_`group', replace) ///
	title("${lbl_`group'}", size(medsmall)) note("n = `Nnote'", size(vsmall) position(5) ring(0)) ///
	legend(order(1 "Africa" 2 "Americas" 3 "Asia" 4 "Europe" 5 "Middle East" 6 "Oceania" 7 "World") rows(8) position(6) size(medsmall) ring(0) region(lstyle(none)) /*position(12)*/)
}

foreach group in fruit veg {
	twoway ///
	(line coverage_`group' year if UNregions == "Africa" & inrange(year,2010,2022), lcolor(gold*0.9)) ///
	(line coverage_`group' year if UNregions == "Americas" & inrange(year,2010,2022), lcolor(red*0.9)) ///
	(line coverage_`group' year if UNregions == "Asia" & inrange(year,2010,2022), lcolor(green*0.9)) ///
	(line coverage_`group' year if UNregions == "Europe" & inrange(year,2010,2022), lcolor(dkorange*0.9) ) ///
	(line coverage_`group' year if UNregions == "Middle East" & inrange(year,2010,2022), lcolor(sienna*0.9)) ///
	(line coverage_`group' year if UNregions == "Oceania"& inrange(year,2010,2022), lcolor(midblue*0.9)) ///
	(line coverage_`group' year if UNregions == "World" & inrange(year,2010,2022), lcolor(black) lpattern(dash)) ///
	, graphregion(color(white)) ytitle("") xtitle("") xlab(2010(5)2030, labsize(small)) yscale(range(0 100)) ylab(0(20)100, angle(0) labsize(small)) xscale(range(2010 2032))  name(map_`group', replace) ///
	title("${lbl_`group'}", size(medsmall)) note("n = `Nnote'", size(vsmall) position(5) ring(0)) ///
	legend(order(1 "Africa" 2 "Americas" 3 "Asia" 4 "Europe" 5 "Middle East" 6 "Oceania" 7 "World") rows(8) position(6) size(medsmall) ring(0) region(lstyle(none)) /*position(12)*/)
}

grc1leg2 map_fruit map_veg map_dairy map_fish map_meat map_LNS map_SS , rows(4) cols(2) graphregion(color(white)) ring(0) position(4) lyoffset(2) lxoffset(-17) imargin(0) xsize(2) ysize(3) l1("Self-sufficiency (% of countries)") b1("Year")
graph export "$workdir/graphs/trends.png", replace 

* Change in self-sufficiency by number of countries
list productdeprv coverage_* if year == 2010 & UNregions == "World", abbreviate(20) 
list productdeprv coverage_* if year == 2022 & UNregions == "World", abbreviate(20) 
list productdeprv coverage_* if year == 2032 & UNregions == "World", abbreviate(20) 

*-------------------------------------------------------
*** SI Table 2: Large table with 2010, 2022 and 2032 ***
*-------------------------------------------------------
use "$datadir/timetrends_productiongap.dta", clear

* Identify 2010 samples
foreach var of varlist $coverage_LW {
	gen _`var'_N2010 = 1 if `var' < . & year == 2010
	bysort country_name: egen `var'_N2010 = max(_`var'_N2010)
	
	gen _`var'_N2019 = 1 if `var' < . & year == 2019
	bysort country_name: egen `var'_N2019 = max(_`var'_N2019)
	
	gen  `var'_Nrestrict = 1 if `var'_N2010 == 1 & `var'_N2019 == 1
	
	drop _`var'_N2010 _`var'_N2019
}

foreach var of varlist $coverage_LW {
	di in red "`var'"
	forv yr = 2010(1)2032 {
		di in red "`yr'"		
		count if `var'_Nrestrict == . & year == `yr'
		count if `var'_Nrestrict != . & year == `yr'
	} 
}

* Keep restricted sample
keep if coverage_SS_Nrestrict == 1

*Is a country SS in 2022?
foreach group in LNS SS dairy fish meat fruit veg {
	gen _SS_2022_`group' = coverage_`group' if year == 2022
	bysort country_name: egen SS_2022_`group' = max(_SS_2022_`group')
	drop _SS_2022_`group'
}

* Deprivation using 5FGs
gen productdeprv_5FG = 0
foreach var of varlist coverage_dairy coverage_fish coverage_meat coverage_LNS coverage_SS {	
	replace productdeprv_5FG = productdeprv_5FG + 1 if `var' == 1
	replace productdeprv_5FG = . if `var' == . 
}

* Different years have a different number of total countries --> don't use total number of countries in this case to compare years (only for 2022 versus 2032)
foreach var of varlist $coverage_LW $coverage_EAT {	
	replace `var' = `var'*100
	//count if `var' < . & year == 2032
}

tabstat $coverage_LW if inlist(year,2010,2020,2032), by(year) statistics(mean N /*semean sd sum*/) nototal format(%9.3g) /*columns(statistics)*/ longstub save

return list
matrix A = r(Stat1)[1,1..7]
matrix B = r(Stat2)[1,1..7]
matrix C = r(Stat3)[1,3..7]
matrix N = r(Stat1)[2,1..7]

putexcel set "$workdir/tables/trends.xlsx", replace
putexcel D1 = "(1) Fruits"
putexcel E1 = "(2) Vegetables"
putexcel F1 = "(3) Dairy products"
putexcel G1 = "(4) Fish and seafood"
putexcel H1 = "(5) Meat"
putexcel I1 = "(6) Legumes/ nuts/seeds"
putexcel J1 = "(7) Starchy Staples"
putexcel K1:L1 = "Avg. # of food groups self-sufficient", merge
putexcel K2 = "Of 7: (1)-(7)"
putexcel L2 = "Of 5: (3)-(7)"

* Extnesive margin
putexcel C2:J2 = "Panel 1: % of countries self-sufficient", merge
putexcel C3 = "2010"
putexcel C4 = "2020"
putexcel C5 = "2032"
putexcel D3 = matrix(A), nformat(#.00)
putexcel D4 = matrix(B), nformat(#.00)
putexcel F5 = matrix(C), nformat(#.00)


* Intensive margin
putexcel C6:J6 = "Panel 2: Self-sufficiency of countries <100% in 2022", merge
putexcel C7 = "2010"
putexcel C8 = "2020"
putexcel C9 = "2032"
tabstat prodgap_perc_fruit if inlist(year,2010,2020,2032) & SS_2022_fruit == 0 , by(year) statistics(mean  /*semean sd*/) nototal format(%9.3g)  longstub save
matrix D7 = r(Stat1)[1,1]
matrix D8 = r(Stat2)[1,1]

putexcel D7 = matrix(D7), nformat(#.00)
putexcel D8 = matrix(D8), nformat(#.00)

tabstat prodgap_perc_veg if inlist(year,2010,2020,2032) & SS_2022_veg == 0 , by(year) statistics(mean  /*semean sd*/) nototal format(%9.3g) columns(statistics) longstub save
matrix E7 = r(Stat1)[1,1]
matrix E8 = r(Stat2)[1,1]

putexcel E7 = matrix(E7), nformat(#.00)
putexcel E8 = matrix(E8), nformat(#.00)

tabstat prodgap_perc_dairy if inlist(year,2010,2020,2032) & SS_2022_dairy == 0 , by(year) statistics(mean  /*semean sd*/) nototal format(%9.3g) columns(statistics) longstub save
matrix F7 = r(Stat1)[1,1]
matrix F8 = r(Stat2)[1,1]
matrix F9 = r(Stat3)[1,1]
putexcel F7 = matrix(F7), nformat(#.00)
putexcel F8 = matrix(F8), nformat(#.00)
putexcel F9 = matrix(F9), nformat(#.00)
tabstat prodgap_perc_fish if inlist(year,2010,2020,2032) & SS_2022_fish == 0 , by(year) statistics(mean  /*semean sd*/) nototal format(%9.3g) columns(statistics) longstub save
matrix G7 = r(Stat1)[1,1]
matrix G8 = r(Stat2)[1,1]
matrix G9 = r(Stat3)[1,1]
putexcel G7 = matrix(G7), nformat(#.00)
putexcel G8 = matrix(G8), nformat(#.00)
putexcel G9 = matrix(G9), nformat(#.00)
tabstat prodgap_perc_meat if inlist(year,2010,2020,2032) & SS_2022_meat == 0 , by(year) statistics(mean  /*semean sd*/) nototal format(%9.3g) columns(statistics) longstub save
matrix H7 = r(Stat1)[1,1]
matrix H8 = r(Stat2)[1,1]
matrix H9 = r(Stat3)[1,1]
putexcel H7 = matrix(H7), nformat(#.00)
putexcel H8 = matrix(H8), nformat(#.00)
putexcel H9 = matrix(H9), nformat(#.00)
tabstat prodgap_perc_LNS if inlist(year,2010,2020,2032) & SS_2022_LNS == 0 , by(year) statistics(mean  /*semean sd*/) nototal format(%9.3g) columns(statistics) longstub save
matrix I7 = r(Stat1)[1,1]
matrix I8 = r(Stat2)[1,1]
matrix I9 = r(Stat3)[1,1]
putexcel I7 = matrix(I7), nformat(#.00)
putexcel I8 = matrix(I8), nformat(#.00)
putexcel I9 = matrix(I9), nformat(#.00)
tabstat prodgap_perc_SS if inlist(year,2010,2020,2032) & SS_2022_SS == 0 , by(year) statistics(mean  /*semean sd*/) nototal format(%9.3g) columns(statistics) longstub save
matrix J7 = r(Stat1)[1,1]
matrix J8 = r(Stat2)[1,1]
matrix J9 = r(Stat3)[1,1]
putexcel J7 = matrix(J7), nformat(#.00)
putexcel J8 = matrix(J8), nformat(#.00)
putexcel J9 = matrix(J9), nformat(#.00)


* Deprivation 7 FGs
tabstat productdeprv if inlist(year,2010,2020) & coverage_dairy_Nrestrict == 1, by(year) statistics(mean  /*semean sd*/) nototal format(%9.3g)  longstub save
matrix K3 = r(Stat1)[1,1]
matrix K4 = r(Stat2)[1,1]
putexcel K3 = matrix(K3), nformat(#.00)
putexcel K4 = matrix(K4), nformat(#.00)


tabstat productdeprv_5FG if inlist(year,2010,2020,2032) & coverage_dairy_Nrestrict == 1, by(year) statistics(mean N  /*semean sd*/) nototal format(%9.3g)  longstub save
matrix L3 = r(Stat1)[1,1]
matrix L4 = r(Stat2)[1,1]
matrix L5 = r(Stat3)[1,1]
putexcel L3 = matrix(L3), nformat(#.00)
putexcel L4 = matrix(L4), nformat(#.00)
putexcel L5 = matrix(L5), nformat(#.00)
matrix N10 = r(Stat1)[2,1]

* Sample
putexcel C10 = "Sample"
putexcel D10 = matrix(N)
putexcel K10 = matrix(N10)
putexcel L10 = matrix(N10)

putexcel save
