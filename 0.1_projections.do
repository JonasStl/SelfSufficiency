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
	gen _target`n' = value`n' if time == 2032 // target year

	bysort location country commodity v4: egen base`n' = max(_base`n')
	bysort location country commodity v4: egen target`n' = max(_target`n')
	
	gen growth`n' = (target`n'/base`n')
	replace growth`n' = 1 if target`n' == 0 & base`n' == 0
	
	drop _base`n' _target`n' base`n' target`n' value`n'
}

ren growth1 growth_biofuel
ren growth2 growth_feed
ren growth3 growth_otheruse
ren growth4 growth_production


keep if time == 2020
drop time


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

save "$datadir/outlook_country.dta", replace

restore


* Calculate mean growth rates for 2 meat items by country
preserve
keep if inlist(v4,"Beef and veal","Sheepmeat","Pigmeat","Poultry meat")
collapse (mean) growth_biofuel growth_feed growth_otheruse growth_production, by(country)
gen v4 = "Other meat (calculated)"
expand 2
replace v4 = "Offals (calculated)" in 1/47

tempfile temp0
save `temp0'
restore

append using `temp0'


*** Region-level production

* Create MENA region based on median of other countries
preserve
keep if inlist(country,"Egypt","Iran","Israel","Saudi Arabia","Turkey")
collapse (median) growth_biofuel growth_feed growth_otheruse growth_production, by(commodity v4)
gen country = "Middle East"

tempfile temp1
save `temp1'
restore

* Create MENA region based on median of other countries
preserve
keep if inlist(country,"Kazakhstan")
collapse (median) growth_biofuel growth_feed growth_otheruse growth_production, by(commodity v4)
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
	
save "$datadir/outlook_region.dta", replace
