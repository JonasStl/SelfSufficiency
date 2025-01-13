global workdir "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis"
global datadir "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/data"

/*
						Time trends in self-sufficiency
																			*/
																			

********************************************************************************
************************ Food Group Recommendations WWF ************************
********************************************************************************
import excel "$datadir/foodgroups_wwf.xlsx", firstrow clear // per capita per day Livewell food group requirements based on Table 4 of "Eating for net zero technical report", Excel sheet uploaded on GitHub
encode Foodgroup, gen(fg)
ren Age15_3 Age1_3 
local agegroups = "Age11_18 Age1_3 Age19_64 Age4_10 Age65"
reshape wide `agegroups', i(Foodgroup) j(fg)
foreach age of local agegroups {
	//subinstr(`age',"Age","",.)
	ren `age'1 livewell_dairy_`age'
	ren `age'2 livewell_fish_`age'
	ren `age'3 livewell_fruit_`age'
	ren `age'4 livewell_LNS_`age'
	ren `age'5 livewell_SS_`age'
	ren `age'6 livewell_meat_`age'
	ren `age'7 livewell_veg_`age'
}
ren *Age* **
drop Foodgroup

foreach var of varlist * {
	forv v = 1/7 {
		replace `var' = `var'[_n+`v'] if `var'[_n+`v'] != .
	}
}
drop in 2/7
gen Variant = "Estimates"
tempfile diet_wwf
save `diet_wwf'


********************************************************************************
************************** Demographic Scaling Factors *************************
********************************************************************************
* 2010- 2023
import excel "$datadir/WPP2024_POP_F01_1_POPULATION_SINGLE_AGE_BOTH_SEXES.xlsx", sheet("Estimates") cellrange(A17:DH22000) firstrow clear // World Population Prospects 2022

tempfile populationestimates
save `populationestimates'

* 2024- 2032
import excel "$datadir/WPP2024_POP_F01_1_POPULATION_SINGLE_AGE_BOTH_SEXES.xlsx", sheet("Medium variant") cellrange(A17:DH22874) firstrow clear // World Population Prospects 2022

append using `populationestimates'

drop if ISO3Alphacode == ""	// drop aggregates
keep if inrange(Year,2010,2032)
foreach var of varlist L-DH {
	destring `var', replace
	replace `var' = `var'*1000	// population in thsnd.
}

*** Population groups based on dietary recommendations
egen pop_1_3 = rowtotal(M N O)
egen pop_4_10 = rowtotal(P-V)
egen pop_11_18 = rowtotal(W-AD)
egen pop_19_64 = rowtotal(AE-BX)
egen pop_65 = rowtotal(BY-DH)

*** Dietary recommendations
replace Variant = "Estimates" if Variant != "Estimates"
merge m:1 Variant using `diet_wwf', nogen


*** Scale recommendations up on population level
egen totpop = rowtotal(pop_1_3 pop_4_10 pop_11_18 pop_19_64 pop_65)

foreach groups in dairy fish fruit LNS SS meat veg {
	gen livewell_`groups'_pop = pop_1_3*livewell_`groups'_1_3 + pop_4_10*livewell_`groups'_4_10 + pop_11_18*livewell_`groups'_11_18 + pop_19_64*livewell_`groups'_19_64 + pop_65*livewell_`groups'_65
	gen livewell_`groups'_pc = livewell_`groups'_pop/totpop
}

ren ISO3Alphacode iso3
keep livewell_dairy_* livewell_fish_* livewell_fruit_* livewell_LNS_* livewell_SS_* livewell_meat_* livewell_veg_* Year iso3 totpop

* EAT-Lancet

gen eatlancet_dairy_pc = 250
gen eatlancet_fish_pc = 28
gen eatlancet_fruit_pc = 200
gen eatlancet_LNS_pc = 125
gen eatlancet_SS_pc = 282
gen eatlancet_meat_pc = 43
gen eatlancet_veg_pc = 300

drop *_1_3 *_4_10 *_11_18 *_19_64 *_65
ren Year year
save "$datadir/timetrends_fooddemand.dta", replace

																			

********************************************************************************
******************************* Food demand change *****************************
********************************************************************************

*** FAO Data ***
import delimited "/Users/jonasstehl/ownCloud/Data/Food Balance Sheets/FoodBalanceSheets_E_All_Data_(Normalized)/FoodBalanceSheets_E_All_Data_(Normalized).csv", clear // downloaded on July 24th, 2024

drop if areacode > 1000 // drop aggregates

save "$datadir/FBS_time.dta", replace

use "$datadir/FBS_time.dta", clear

* Drop irrelevant food items
drop if inlist(item,"Population","Grand Total","Vegetal Products","Animal Products") //Aggregates
drop if inlist(item,"Sugar Crops","Sugar cane","Sugar beet") //Sugar Crops
drop if inlist(item,"Sugar & Sweeteners","Sugar non-centrifugal","Sugar (Raw Equivalent)","Sweeteners, Other","Honey") //Sugar & Sweeteners
drop if inlist(item,"Spices","Pepper","Pimento","Cloves","Spices, Other") //Spices
drop if inlist(item,"Alcoholic Beverages","Wine","Beer","Beverages, Fermented","Beverages, Alcoholic","Alcohol, Non-Food") // Alcoholic beverages
drop if inlist(item,"Stimulants","Coffee and products","Cocoa Beans and products","Tea (including mate)") //Stimulants
drop if inlist(item,"Miscellaneous","Infant food") //Miscellaneous
drop if inlist(itemcode,2571,2586,2737,2740,2781,2782,2558,2559,2562) //oils and fats
drop if inlist(itemcode,2572,2573,2574,2575,2576,2577,2578,2579,2580,2581,2582) //oils
drop if inlist(itemcode,2744) //eggs

drop if inlist(itemcode,2905,2907,2911,2912,2913,2914,2918,2919,2943,2945,2946,2949,2948,2960,2961) //Food group aggregates

* Only keep relevant elements
keep if /*element == "Domestic supply quantity" | element == "Food" |*/ element == "Production" | /*element == "Total Population - Both sexes" |*/ element == "Feed" | element == "Losses" | element == "Other uses (non-food)" | element == "Seed" | element == "Processing"


******* Group countries to various regions (used for several matchings) ********
{
ren area country_name
replace country_name = "Netherlands" if country_name == "Netherlands (Kingdom of the)"

cap ssc install kountry
kountry country_name, from(other) geo(meb) //(Middle_East broadly defined)
ren GEO worldregions

replace worldregions = "Europe" if inlist(country_name,"Czechia","Montenegro","North Macedonia","United Kingdom of Great Britain and Northern Ireland")
replace worldregions = "Americas" if inlist(country_name,"Bolivia (Plurinational State of)","Venezuela (Bolivarian Republic of)")
replace worldregions = "Africa" if inlist(country_name,"Cabo Verde","Côte d'Ivoire","Eswatini")
replace worldregions = "Asia" if inlist(country_name,"China, Hong Kong SAR","China, Macao SAR","China, Taiwan Province of")
replace worldregions = "Middle East" if inlist(country_name,"Türkiye")
// (all country names assigned)
drop NAMES_STD

* Create regions for Household Waste conversion factors
gen region = ""
replace region = "Europe" if worldregions == "Europe" | inlist(country_name,"Georgia","Armenia","Azerbaijan")
replace region = "USA, Canada, Oceania" if inlist(country_name,"Canada","United States of America","Australia","New Zealand")
replace region = "Industrialized Asia" if inlist(country_name,"Japan","China","China, Hong Kong SAR","China, Macao SAR","China, Taiwan Province of","South Korea")
replace region = "sub-Saharan Africa" if worldregions == "Africa"
replace region = "North Africa, West and Central Asia" if worldregions == "Middle East" | inlist(country_name,"Kazakhstan","Tajikistan","Kyrgyzstan","Mongolia","Turkmenistan","Uzbekistan")
replace region = "Latin America" if (worldregions == "Americas" & region != "USA, Canada, Oceania") | (worldregions == "Oceania" & region != "USA, Canada, Oceania") //Oceania is not considered in the food waste report and assigned to Latin America.
replace region = "South and Southeast Asia" if worldregions == "Asia" & region == "" 
// (all country names assigned)


* Add countrycodes and rename countries (for EAT-Lancet)
replace country_name = "Bahamas, The" if country_name == "Bahamas"
replace country_name = "Bolivia" if country_name == "Bolivia (Plurinational State of)"
replace country_name = "Congo, Dem. Rep." if country_name == "Democratic Republic of the Congo"
replace country_name = "Congo, Rep." if country_name == "Congo"
replace country_name = "Czech Republic" if country_name == "Czechia"
replace country_name = "Egypt, Arab Rep." if country_name == "Egypt"
replace country_name = "Gambia, The" if country_name == "Gambia"
replace country_name = "Iran, Islamic Rep." if country_name == "Iran (Islamic Republic of)"
replace country_name = "Korea, Rep." if country_name == "Republic of Korea"
replace country_name = "Kyrgyz Republic" if country_name == "Kyrgyzstan"
replace country_name = "Lao PDR" if country_name == "Lao People's Democratic Republic"
replace country_name = "Moldova" if country_name == "Republic of Moldova"
replace country_name = "Slovak Republic" if country_name == "Slovakia"
replace country_name = "St. Kitts and Nevis" if country_name == "Saint Kitts and Nevis"
replace country_name = "St. Lucia" if country_name == "Saint Lucia"
replace country_name = "St. Vincent and the Grenadines" if country_name == "Saint Vincent and the Grenadines"
replace country_name = "Tanzania" if country_name == "United Republic of Tanzania"
replace country_name = "United Kingdom" if country_name == "United Kingdom of Great Britain and Northern Ireland"
replace country_name = "United States" if country_name == "United States of America"
replace country_name = "Vietnam" if country_name == "Viet Nam"

* Create ISO3 codes
kountry country_name, from(other) stuck
ren _ISO3N_ iso3n
kountry iso3n, from(iso3n) to(iso3c)
ren _ISO3C_ iso3
drop iso3n

// Replace iso3 variable with ISO 3 country codes for specific country names
replace iso3 = "CPV" if country_name == "Cabo Verde"
replace iso3 = "HKG" if country_name == "China, Hong Kong SAR"
replace iso3 = "MAC" if country_name == "China, Macao SAR"
replace iso3 = "TWN" if country_name == "China, Taiwan Province of"
replace iso3 = "CIV" if country_name == "Côte d'Ivoire"
replace iso3 = "SWZ" if country_name == "Eswatini"
replace iso3 = "MKD" if country_name == "North Macedonia"
replace iso3 = "TUR" if country_name == "Türkiye"
replace iso3 = "VEN" if country_name == "Venezuela (Bolivarian Republic of)"
// (all country names assigned)

drop if iso3 == "TWN" // not in shapefile

* Create other regional levels
kountry iso3, from(iso3c) geo(undet) // detailed UN regions
drop NAMES_STD
ren GEO UNregions_det
replace UNregions_det = "Eastern Europe" if iso3 == "MNE"
kountry iso3, from(iso3c) geo(men) // (Middle-East narrowly defined)
drop NAMES_STD
ren GEO UNregions
replace UNregions = "Europe" if iso3 == "MNE"


* Generate variable for regional matching
gen outlookregions = ""
replace outlookregions = "EUROPE" if region == "Europe"
replace outlookregions = "LATIN AMERICA" if region == "Latin America"
replace outlookregions = "AFRICA" if region == "sub-Saharan Africa"
replace outlookregions = "OCEANIA" if worldregions == "Oceania"
replace outlookregions = "ASIA" if (region == "South and Southeast Asia" | inlist(UNregions_det,"Eastern Asia","South-Eastern Asia","Southern Asia")) & outlookregions == ""
replace outlookregions = "Middle East" if worldregions == "Middle East" & outlookregions == ""
replace outlookregions = "NORTH AMERICA" if UNregions_det == "Northern America" & outlookregions == ""
replace outlookregions = "Central Asia" if UNregions_det == "Central Asia" & outlookregions == ""
}

********************************************************************************

*** Calculate domestic production available for consumption
bysort elementcode: tab element
drop element flag yearcode unit areacodem49 itemcodefbs areacode
replace value = value*1000	// original value in thsd. tonnes

reshape wide value, i(outlookregions UNregions UNregions_det region worldregion iso3 country_name year itemcode item) j(elementcode)
foreach var of varlist value5123 value5154 value5511 value5521 value5527 value5131 {
	replace `var' = 0 if `var' == . 
}
gen productionadj = value5511 - (value5123 + value5154 + value5521 + value5527)
replace productionadj = value5511 - (value5123 + value5154 + value5521 + value5527 + value5131) if inlist(itemcode,2555,2557,2560,2561,2570,2563) // to account for processing into oil
replace productionadj = 0 if productionadj < 0

*** Add Agricultural Outlook Projection Data
append using "$datadir/timetrends_outlook.dta", gen(trends)
gsort country_name itemcode item year

/*
I used projected agricultural production for each food item from Agricultural Outlook. Similarly, I adjusted feed use.
I assumed food losses, non-food uses, and use for seed to be constant -> I took 2020 values.
*/

*** Calculation of daily per person gram production ***
gen value = (productionadj/365)*1000*1000 //Calculate production per day in g (before in tonns)
lab var value "Production per day (in g)"
drop value5511 value5123 value5154 value5521 value5527 value5131

* Group food items
gen foodgroups1 = ""

replace foodgroups1 = "wheat, rye, other grains" if inlist(itemcode,2511,2515,2513,2516,2520)
replace foodgroups1 = "maize, millet, sorghum" if inlist(itemcode,2514,2517,2518)
replace foodgroups1 = "rice" if itemcode == 2807
replace foodgroups1 = "starchy roots" if inrange(itemcode,2531,2535)
replace foodgroups1 = "nuts" if inlist(itemcode,2551,2552)
replace foodgroups1 = "pulses" if inrange(itemcode,2546,2549)
replace foodgroups1 = "oilseeds" if inlist(itemcode,2555,2557,2560,2561,2570)
replace foodgroups1 = "vegetables" if inrange(itemcode,2601,2605) | itemcode == 2775
replace foodgroups1 = "fruits" if inlist(itemcode,2611,2612,2613,2614,2615,2616,2617,2618,2619,2620,2625,2563)
replace foodgroups1 = "milk and dairy" if inlist(itemcode,2848,2743)
replace foodgroups1 = "beef" if itemcode == 2731
replace foodgroups1 = "lamb" if itemcode == 2732
replace foodgroups1 = "poultry" if itemcode == 2734
replace foodgroups1 = "pork" if itemcode == 2733
replace foodgroups1 = "other meat" if itemcode == 2735 | itemcode == 2736
replace foodgroups1 = "fish and seafood" if inrange(itemcode,2761,2769)


* Generate HDB food groups
gen HDB_FGs = ""
replace HDB_FGs = "Starchy staples" if inlist(foodgroups1,"wheat, rye, other grains","maize, millet, sorghum","rice","starchy roots")	
replace HDB_FGs = "Vegetables" if inlist(foodgroups1,"vegetables")
replace HDB_FGs = "Fruits" if inlist(foodgroups1,"fruits")
replace HDB_FGs = "Meat" if inlist(foodgroups1,"beef","lamb","poultry","pork","other meat") | itemcode == 2736 
replace HDB_FGs = "Milk and dairy products" if inlist(foodgroups1,"milk and dairy")
replace HDB_FGs = "Fish and seafood" if inlist(foodgroups1,"fish and seafood")
replace HDB_FGs = "Legumes, nuts and seeds" if inlist(foodgroups1,"nuts","pulses","oilseeds")


* Calculate true consumption
merge m:1 region foodgroups1 using "$datadir/conversionfactors.dta", nogen // from Gustavsson et al. 2011 (data available on GitHub)

gen consumption = .
replace consumption = value*conversionfactor if value >= 0
replace consumption = value/conversionfactor if value < 0


* Aggregate over HDB food groups
collapse (sum) consumption, by(country_name year HDB_FGs) 

encode HDB_FGs, gen(HDB_FG)
fre HDB_FG
drop HDB_FGs
reshape wide consumption, i(country_name year) j(HDB_FG)

ren consumption1 consumption_fish
ren consumption2 consumption_fruit
ren consumption3 consumption_LNS
ren consumption4 consumption_meat
ren consumption5 consumption_dairy
ren consumption6 consumption_SS
ren consumption7 consumption_veg


* EAT Lancet Diet

* Add countrycodes and rename countries (for EAT-Lancet)
replace country_name = "Bahamas, The" if country_name == "Bahamas"
replace country_name = "Bolivia" if country_name == "Bolivia (Plurinational State of)"
replace country_name = "Congo, Dem. Rep." if country_name == "Democratic Republic of the Congo"
replace country_name = "Congo, Rep." if country_name == "Congo"
replace country_name = "Czech Republic" if country_name == "Czechia"
replace country_name = "Egypt, Arab Rep." if country_name == "Egypt"
replace country_name = "Gambia, The" if country_name == "Gambia"
replace country_name = "Iran, Islamic Rep." if country_name == "Iran (Islamic Republic of)"
replace country_name = "Korea, Rep." if country_name == "Republic of Korea"
replace country_name = "Kyrgyz Republic" if country_name == "Kyrgyzstan"
replace country_name = "Lao PDR" if country_name == "Lao People's Democratic Republic"
replace country_name = "Moldova" if country_name == "Republic of Moldova"
replace country_name = "Slovak Republic" if country_name == "Slovakia"
replace country_name = "St. Kitts and Nevis" if country_name == "Saint Kitts and Nevis"
replace country_name = "St. Lucia" if country_name == "Saint Lucia"
replace country_name = "St. Vincent and the Grenadines" if country_name == "Saint Vincent and the Grenadines"
replace country_name = "Tanzania" if country_name == "United Republic of Tanzania"
replace country_name = "United Kingdom" if country_name == "United Kingdom of Great Britain and Northern Ireland"
replace country_name = "United States" if country_name == "United States of America"
replace country_name = "Vietnam" if country_name == "Viet Nam"

* Create ISO3 codes
kountry country_name, from(other) stuck
ren _ISO3N_ iso3n
kountry iso3n, from(iso3n) to(iso3c)
ren _ISO3C_ iso3
drop iso3n

// Replace iso3 variable with ISO 3 country codes for specific country names
replace iso3 = "CPV" if country_name == "Cabo Verde"
replace iso3 = "HKG" if country_name == "China, Hong Kong SAR"
replace iso3 = "MAC" if country_name == "China, Macao SAR"
replace iso3 = "TWN" if country_name == "China, Taiwan Province of"
replace iso3 = "CIV" if country_name == "Côte d'Ivoire"
replace iso3 = "SWZ" if country_name == "Eswatini"
replace iso3 = "MKD" if country_name == "North Macedonia"
replace iso3 = "TUR" if country_name == "Türkiye"
replace iso3 = "VEN" if country_name == "Venezuela (Bolivarian Republic of)"
// (all country names assigned)

* Merge food demand data
drop if country_name == "China"
merge 1:1 iso3 year using "$datadir/timetrends_fooddemand.dta", keep(match master) nogen // Netherlands Antilles (former) not matched (will be dropped anyway)

*Calculate per capita values
foreach group in LNS SS dairy fish fruit meat veg {
	lab var consumption_`group' "Domestic supply of `group' per day (in g)"
	gen consumptionpc_`group' = consumption_`group'/totpop
	lab var consumptionpc_`group' "Domestic supply of `group' per capita per day (in g)"
}


* Calculate difference in percent if a healthy diet was adopted
foreach group in LNS SS dairy fish fruit meat veg {
	gen prodgap_abs_`group' = consumptionpc_`group' - livewell_`group'_pc
	lab var prodgap_abs_`group' "Absolute `group' production gap to the livewell recommendation (g/capita/day)"

	gen prodgap_perc_`group' = (consumptionpc_`group'/livewell_`group'_pc)*100
	lab var prodgap_perc_`group' "Percent `group' production gap to the livewell recommendation (in perc)"
	
	
	gen eatgap_abs_`group' = consumptionpc_`group' - eatlancet_`group'_pc
	lab var eatgap_abs_`group' "Absolute `group' production gap to the EAT-Lancet recommendation (g/capita/day)"

	gen eatgap_perc_`group' = (consumptionpc_`group'/eatlancet_`group'_pc)*100
	lab var eatgap_perc_`group' "Percent `group' production gap to the EAT-Lancet recommendation (in perc)"
}

export excel country_name year prodgap_abs_* prodgap_perc_* using "$workdir/tables/timetrends_productiongap.xlsx", replace firstrow(varlabels) keepcellfmt


* Food group deprivation
gen productdeprv = 0
gen productdeprv_eat = 0

lab var productdeprv "Number of food groups that can be covered by own production"
foreach group in LNS SS dairy fish fruit meat veg {
	//Livewell
	gen coverage_`group' = .
	replace coverage_`group' = 1 if prodgap_abs_`group' >= 0 & prodgap_abs_`group' != .
	replace coverage_`group' = 0 if prodgap_abs_`group' < 0 & prodgap_abs_`group' != .
	
	replace productdeprv = productdeprv + 1 if prodgap_abs_`group' >= 0 & prodgap_abs_`group' != .
	replace productdeprv = . if prodgap_abs_`group' == .
	
	//EAT-Lancet
	gen eatcoverage_`group' = .
	replace eatcoverage_`group' = 1 if eatgap_abs_`group' >= 0 & eatgap_abs_`group' != .
	replace eatcoverage_`group' = 0 if eatgap_abs_`group' < 0 & eatgap_abs_`group' != .
	
	replace productdeprv_eat = productdeprv_eat + 1 if eatgap_abs_`group' >= 0 & eatgap_abs_`group' != .
	replace productdeprv_eat = . if eatgap_abs_`group' == .
}


* Add regions
* Create other regional levels
kountry iso3, from(iso3c) geo(undet) // detailed UN regions
drop NAMES_STD
ren GEO UNregions_det
replace UNregions_det = "Eastern Europe" if iso3 == "MNE"
kountry iso3, from(iso3c) geo(men) // (Middle-East narrowly defined)
drop NAMES_STD
ren GEO UNregions
replace UNregions = "Europe" if iso3 == "MNE"


* Economic unions
gen econunions = ""
replace econunions = "EUCU" if inlist(iso3,"AUT", "BEL", "BGR", "HRV", "CYP", "CZE", "DNK", "EST", "FIN") | ///
							inlist(iso3,  "FRA", "DEU", "GRC", "HUN", "IRL", "ITA", "LVA", "LTU", "LUX") | ///
							inlist(iso3, "MLT", "NLD", "POL", "PRT", "ROU", "SVK", "SVN", "ESP", "SWE") | ///
							inlist(iso3, "GBR")
replace econunions = "EACU" if inlist(iso3,"ARM", "BLR", "KAZ", "KGZ", "RUS")
replace econunions = "GCC" if inlist(iso3,"BHR", "KWT", "OMN", "QAT", "SAU", "ARE")
replace econunions = "SACU" if inlist(iso3,"BWA", "LSO", "NAM", "SWZ", "ZAF")
replace econunions = "EAC" if inlist(iso3,"BDI", "KEN", "RWA", "TZA", "UGA") 
replace econunions = "CEMAC" if inlist(iso3,"CMR", "CAF", "COG", "GAB", "TCD") //"GNQ" --> No data
replace econunions = "WAEMU" if inlist(iso3,"SEN", "MLI", "BFA", "CIV", "NER", "TGO", "BEN")
replace econunions = "MERCOSUR" if inlist(iso3,"ARG", "BRA", "PRY", "URY")
replace econunions = "CAN" if inlist(iso3,"BOL", "COL", "ECU", "PER")
replace econunions = "CARICOM" if inlist(iso3,"ABW", "ATG", "BHS", "BRB", "BLZ", "DMA", "GRD", "GUY", "HTI") | ///
								inlist(iso3, "JAM", "KNA", "LCA", "VCT", "SUR", "TTO", "TCA", "VGB", "VIR") | ///
								inlist(iso3,"BLZ")
replace econunions = "CACM" if inlist(iso3,"CRI", "SLV", "GTM", "HND", "NIC")
replace econunions = "AFTA" if inlist(iso3,"BRN","KHM","IDN","LAO","MYS","MMR","PHL") | ///
								inlist(iso3,"SGP","THA","VNM")
replace econunions = "USMCA" if inlist(iso3,"USA","CAN","MEX")
replace econunions = "SAARC" if inlist(iso3,"AFG","BGD","BTN","IND","MDV","NPL","PAK","LKA")

drop if iso3 == "TWN" 
drop if country_name == "Netherlands Antilles (former)"
drop if inlist(country_name,"Sudan","South Sudan") // split during time period


save "$datadir/timetrends_productiongap.dta", replace


* Preparation for map
use "$datadir/timetrends_productiongap.dta", clear

*Is a country SS in 2020?
foreach group in LNS SS dairy fish meat fruit veg {
	gen _SS_2020_`group' = coverage_`group' if year == 2020
	bysort country_name: egen SS_2020_`group' = max(_SS_2020_`group')
	drop _SS_2020_`group'
}

* Keep 2020 and 2032 to calculate difference
keep if year == 2020 | year == 2032

keep prodgap_perc_LNS prodgap_perc_SS prodgap_perc_dairy prodgap_perc_fish prodgap_perc_meat country_name year SS_2020_* iso3

reshape wide prodgap_perc_LNS prodgap_perc_SS prodgap_perc_dairy prodgap_perc_fish prodgap_perc_meat , i(country_name) j(year)

foreach group in LNS SS dairy fish meat {
	gen prodgap_change_`group'2032 = prodgap_perc_`group'2032 - prodgap_perc_`group'2020
}

save "$datadir/timetrends_productiongap_2032.dta", replace
