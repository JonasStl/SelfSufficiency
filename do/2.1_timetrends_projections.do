global workdir "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis"
global datadir "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/data"


********************************************************************************
************************ Agricultural Outlook Database	************************
********************************************************************************
import delimited "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/data/Agricultural Outlook Database/HIGH_AGLINK_2023-2023-1-EN-20240109T100123.csv", clear

* Drop unnecessary variables
drop referenceperiodcode referenceperiod flagcodes flags variable unit unitcode v8 powercodecode powercode

* Keep/Calculate food production growth
keep if inlist(v6,"Production","Feed","Biofuel use","Other use") // (for now)

* Reshape
encode v6, gen(element)
fre element
drop v6

reshape wide value, i(location country commodity v4 time) j(element)
foreach var of varlist value1 value2 value3 value4 {
	replace `var' = 0 if `var' == .
}
//gen productionadj = value4 - (value1 + value2 + value3)


* Calculate growth
forv n = 1/4 {
	gen _base`n' = value`n' if time == 2020 // base year
	bysort location country commodity v4: egen base`n' = max(_base`n')
		
	gen growth`n' = (value`n'/base`n')
	replace growth`n' = 1 if value`n' == 0 & base`n' == 0
	
	drop _base`n' base`n' value`n'
}

ren growth1 growth_biofuel
ren growth2 growth_feed
ren growth3 growth_otheruse
ren growth4 growth_production


keep if time > 2022
ren time year

* Food item matching with FAO FBS (file will be merged in the main file)



*** Country-level production

preserve 
ren country country_name
ren v4 Outlookname
drop location commodity 

drop if inlist(country_name,"WORLD","NORTH AMERICA","LATIN AMERICA","EUROPE","European Union", ///
	"AFRICA","ASIA","OCEANIA","DEVELOPED COUNTRIES") | ///
	inlist(country_name,"DEVELOPING COUNTRIES","LEAST DEVELOPED COUNTRIES (LDC)","OECD countries","BRICS")

replace country_name = "China" if country_name == "China  (2)" // which is the right china
replace country_name = "United Kingdom" if country_name == "United Kingdom"
//replace area = "Russian Federation" if area == "Russia"
replace country_name = "China, mainland" if country_name == "China" // which is the right china
replace country_name = "Iran, Islamic Rep." if country_name == "Iran"
replace country_name = "Korea, Rep." if country_name == "Korea"
replace country_name = "Türkiye" if country_name == "Turkey"

reshape wide growth_biofuel growth_feed growth_otheruse growth_production, i(country_name Outlookname) j(year)

save "$datadir/timetrends_outlook_country.dta", replace

restore


* Calculate mean growth rates for 2 meat items by country
preserve
keep if inlist(v4,"Beef and veal","Sheepmeat","Pigmeat","Poultry meat")
collapse (mean) growth_biofuel growth_feed growth_otheruse growth_production, by(country year)
gen v4 = "Other meat (calculated)"
expand 2
replace v4 = "Offals (calculated)" in 1/470

tempfile temp0
save `temp0'
restore

append using `temp0'


*** Region-level production

* Create MENA region based on median of other countries
preserve
keep if inlist(country,"Egypt","Iran","Israel","Saudi Arabia","Turkey")
collapse (median) growth_biofuel growth_feed growth_otheruse growth_production, by(commodity v4 year)
gen country = "Middle East"

tempfile temp1
save `temp1'
restore

* Create MENA region based on median of other countries
preserve
keep if inlist(country,"Kazakhstan")
collapse (median) growth_biofuel growth_feed growth_otheruse growth_production, by(commodity v4 year)
gen country = "Central Asia"

tempfile temp2
save `temp2'
restore

* Append medians
append using `temp1'
append using `temp2'

keep if inlist(country,"WORLD","NORTH AMERICA","LATIN AMERICA","EUROPE","European Union  (1)","AFRICA","ASIA","OCEANIA","DEVELOPED COUNTRIES") | ///
	inlist(country,"DEVELOPING COUNTRIES","LEAST DEVELOPED COUNTRIES (LDC)","OECD  (3)","BRICS","Middle East","Central Asia")
	
ren country outlookregions
ren v4 Outlookname

drop location commodity
reshape wide growth_biofuel growth_feed growth_otheruse growth_production, i(outlookregions Outlookname) j(year)
	
save "$datadir/timetrends_outlook_region.dta", replace


********************************************************************************
* 							Calculate production 								*
********************************************************************************
use "$datadir/timetrends_base2020.dta", clear
merge m:1 itemcode using "$datadir/Outlook_FAOFBS.dta", keep(match master) nogen
merge m:1 country_name Outlookname using "$datadir/timetrends_outlook_country.dta", keep(match master) gen(outlook_country)
merge m:1 outlookregions Outlookname using "$datadir/timetrends_outlook_region.dta", gen(outlook_region) update keepusing(growth_biofuel* growth_feed* growth_otheruse* growth_production*)
drop if outlook_region==2

forv years = 2023(1)2032 {
	gen production`years' = value5511*growth_production`years'
	gen feeduse`years' = value5521*growth_feed`years'
}

drop productionadj
forv years = 2023(1)2032 { // I am relying on the same assumptions as for the capacility approach (values for other uses from 2020 -> not good -> I could also use continuous growth trends based on past data)
	gen productionadj`years' = production`years' - (value5123 + value5154 + feeduse`years' + value5527)
	replace productionadj`years' = production`years' - (value5123 + value5154 + feeduse`years' + value5527 + value5131) if inlist(itemcode,2555,2557,2560,2561,2570,2563)
	replace productionadj`years' = 0 if productionadj`years' < 0					
}

drop econunions UNregions_det UNregions growth_biofuel* growth_feed* growth_otheruse* growth_production* 
drop production2023-feeduse2032

reshape long productionadj, i(country_name itemcode item worldregions region iso3 outlookregions Outlookname) j(year)

drop outlook_country outlook_region note
drop value5123 value5131 value5154 value5511 value5521 value5527

save "$datadir/timetrends_outlook.dta", replace

