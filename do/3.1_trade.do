global workdir "./SelfSufficiency/Analysis"
global datadir "./SelfSufficiency/Analysis/data"


********************************************************************************
*************************** Trade Shock Vulnerability **************************
********************************************************************************

*** Prepare FAOSTAT data ***
import delimited "$datadir/Trade_DetailedTradeMatrix_E_All_Data_(Normalized)/Trade_DetailedTradeMatrix_E_All_Data_(Normalized).csv", clear // downloaded on November 26th, 2023

keep if year == 2020
keep if element == "Import Quantity"

save "$datadir/tradematrix.dta", replace
***
use "$datadir/tradematrix.dta", clear

* Drop irrelevant items
drop if inlist(itemcode,1002,1007,1008,1009,101,1025,1026,1027,1028,1030,1031,1037,1038,1039,1040,1043,1045,1046,1047,1065,1066,109,1100,1129,1146,1168,1169,1181,1182,1183,1185,1186,1187,1195,1213,1214,1215,1216,1217,1218,1219,1221,1222,1225,1232,1241,1242,1243,1259,1274,1275,1276,1277,1293,1295,1296,156,157,160,161,162,163,164,165,166,167,168,169,170,172,173,175,237,237,239,240,241,244,251,252,253,256,257,258,259,261,264,266,268,269,271,272,273,274,276,278,281,282,290,291,293,294,297,564,391) // Oil, hair, etc.

drop if inlist(itemcode,1062,1063,1064,1091) // Eggs

drop if inlist(itemcode,631, 633, 634, 635, 636, 639, 640, 641, 643, 646, 647, 649, 651, 652, 653, 654, 655, 656, 657, 658, 659, 660, 661, 662, 663, 664, 665, 666, 667, 671, 672, 677, 687, 689, 692, 693, 698, 702, 711, 720, 723, 737, 748, 753, 754, 755, 767, 768, 769, 770, 771, 773, 774, 777, 778, 780, 782, 788, 789, 809, 813, 821, 826, 828, 829, 831, 836, 837, 839, 840, 841, 842, 843, 845, 846, 850, 852, 853, 854, 855, 857, 858, 859, 862, 887, 910, 919, 920, 921, 922, 928, 929, 930, 957, 958, 959, 982, 983, 984, 987, 988, 994, 995, 996, 997, 998, 999,517)

drop if inlist(itemcode,491,492,496,498,499,510,513,514,518,519,565,622,626,628,562,563,580,509,576,390,39,51,873) //Juices

drop if inlist(itemcode,238,332,335,341,245,37,61,17,213,59,112,85,73,105,81,47) //Cake and Bran

drop if inlist(itemcode,265,339,340,334,60,331,329,336,270,280,292,267,36) //Oil-heavy seeds


* Group items
gen foodgroup = ""
replace foodgroup = "Dairy" if inlist(itemcode,1021,1022,882, 885, 886, 888, 889, 890, 891, 892, 893, 894, 895, 896, 897, 898, 899, 900, 901, 903, 904, 905, 907, 908, 909, 953,882,885,886,887, 888, 889)

//Fish is in separate dataset: https://www.fao.org/fishery/statistics-query/en/trade/trade_quantity

replace foodgroup = "Fruits" if inlist(itemcode,249,250,260,262,486, 490, 495, 497, 507, 512, 515, 521, 523, 526, 527, 530, 531, 534, 536, 537, 538, 539, 541, 544, 547, 549, 550, 552, 554, 558, 560, 561, 566, 567, 568, 569, 570, 571, 572, 574, 575, 577, 583, 584, 587, 591, 592, 600, 603, 604, 619, 620, 623, 624, 625)

replace foodgroup = "Legumes, nuts and seeds" if inlist(itemcode,176,181,187,191,195,197,201,203,205,210,211,212,216,217,220,221,222,223,224,225,226,229,230,231,232,233,234,235,236,242,243,246,247,263,275,289,295,296,299,311, 312, 313, 314, 333, 338, 343, 461)

replace foodgroup = "Starchy staples" if inlist(itemcode,103,104,108,110,111,113,114,115,116,117,118,120,121,122,125,126,127,128,129,135,136,137,149,15,150,151,16,18,19,20,21,22,27,28,29,30,31, 32, 35, 38, 41, 44, 45, 46, 48, 49, 50, 56, 57, 58, 71, 72, 75, 76, 77, 79, 80, 83, 84, 86, 89, 90, 91, 92, 94, 95, 96, 97, 489)

replace foodgroup = "Meat" if inlist(itemcode,1016,1017,1018,1034,1035,1036,1041,1042,1057,1058,1059,1060,1061,1068,1069,1072,1073,1074,1075,1079,1080,1081,1083,1089,1096,1097,1098,1103,1104,1105,1107,1108,1110,1126,1127,1134,1136,1140,1141,1150,1157,1163,1164,1166,1167,1171,1172,1173,866, 867, 868, 869, 870, 871, 872, 874, 875, 877, 878, 946, 947, 948, 953, 976, 977, 978, 979)

replace foodgroup = "Vegetables" if inlist(itemcode,358, 366, 367, 372, 373, 388, 392, 393, 394, 397, 399, 401, 402, 403, 406, 407, 414, 417, 420, 423, 426, 430, 446, 447, 448, 449, 450, 451, 459, 460, 463, 465, 466, 469, 471, 472, 473, 474, 475, 476)

* Adjust units 
// An and 1000 An
drop if unit == "An" | unit == "1000 An" 


*********************************** Analysis ***********************************
* collapse by food group
drop partnercountrycodem49 partnercountrycode reportercountrycode reportercountrycodem49 itemcode itemcodecpc item elementcode element yearcode year unit flag 
collapse (sum) value , by(reportercountries partnercountries foodgroup)

* Calculate total import sum
bysort reportercountries foodgroup: egen totimports = total(value), mis

* Import share of partner country of total imports in food group
gen importshare = (value/totimports)*100

* Sort countries according to their import contributions
gsort reportercountries foodgroup -importshare
bysort reportercountries foodgroup: gen importrank = _n


* Merge Self-sufficiency data
ren reportercountries country_name

replace country_name = "Vietnam" if country_name == "Viet Nam"
replace country_name = "United States" if country_name == "United States of America"
replace country_name = "United Kingdom" if country_name == "United Kingdom of Great Britain and Northern Ireland"
replace country_name = "Tanzania" if country_name == "United Republic of Tanzania"
replace country_name = "St. Vincent and the Grenadines" if country_name == "Saint Vincent and the Grenadines"
replace country_name = "St. Lucia" if country_name == "Saint Lucia"
replace country_name = "St. Kitts and Nevis" if country_name == "Saint Kitts and Nevis"
replace country_name = "Slovak Republic" if country_name == "Slovakia"
replace country_name = "Netherlands" if country_name == "Netherlands (Kingdom of the)"
replace country_name = "Lao PDR" if country_name == "Lao People's Democratic Republic"
replace country_name = "Kyrgyz Republic" if country_name == "Kyrgyzstan"
replace country_name = "Iran, Islamic Rep." if country_name == "Iran (Islamic Republic of)"
replace country_name = "Gambia, The" if country_name == "Gambia"
replace country_name = "Egypt, Arab Rep." if country_name == "Egypt"
replace country_name = "Czech Republic" if country_name == "Czechia"
replace country_name = "Bahamas, The" if country_name == "Bahamas"
replace country_name = "Bolivia" if country_name == "Bolivia (Plurinational State of)"
replace country_name = "Bahamas, The" if country_name == "Bahamas"
replace country_name = "Congo, Rep." if country_name == "Congo"
replace country_name = "Congo, Dem. Rep." if country_name == "Democratic Republic of the Congo"
replace country_name = "Moldova" if country_name == "Republic of Moldova"
replace country_name = "Korea, Rep." if country_name == "Republic of Korea"

merge m:1 country_name using "$datadir/productiongap.dta", nogen keep(match master)


*********************************** Plotting ***********************************

// "At risk countries": Less than 50% self-sufficiency and >50% of imports from one country 
graph set window fontface "Times New Roman"


*** SI Figure 3 ***
{
//LNS
sum importrank if importrank == 1 & foodgroup == "Legumes, nuts and seeds" & importshare > 50 & prodgap_perc_LNS < 50
local Nnote1 = `r(sum)'
count if prodgap_perc_LNS < . &  importshare  < . & importrank == 1 & foodgroup == "Legumes, nuts and seeds"
local Nnote2 = `r(N)'
local Nnote = "`Nnote1' of `Nnote2'"

graph set window fontface "Times New Roman"
twoway (scatter prodgap_perc_LNS importshare if importrank == 1 & foodgroup == "Legumes, nuts and seeds" & ///
	(importshare > 50 & prodgap_perc_LNS < 50 & wbregion == "East Asia and Pacific") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(midblue) mlabcolor(midblue)) ///
	(scatter prodgap_perc_LNS importshare if importrank == 1 & foodgroup == "Legumes, nuts and seeds" & ///
	(importshare > 50 & prodgap_perc_LNS < 50 & wbregion == "Europe and Central Asia") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(orange) mlabcolor(orange)) ///
	(scatter prodgap_perc_LNS importshare if importrank == 1 & foodgroup == "Legumes, nuts and seeds" & ///
	(importshare > 50 & prodgap_perc_LNS < 50 & wbregion == "Latin America and Caribbean") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(gs8) mlabcolor(gs8)) ///
	(scatter prodgap_perc_LNS importshare if importrank == 1 & foodgroup == "Legumes, nuts and seeds" & ///
	(importshare > 50 & prodgap_perc_LNS < 50 & wbregion == "Middle East and North Africa") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(sienna) mlabcolor(sienna)) ///
	(scatter prodgap_perc_LNS importshare if importrank == 1 & foodgroup == "Legumes, nuts and seeds" & ///
	(importshare > 50 & prodgap_perc_LNS < 50 & wbregion == "North America") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(red) mlabcolor(red)) ///
	(scatter prodgap_perc_LNS importshare if importrank == 1 & foodgroup == "Legumes, nuts and seeds" & ///
	(importshare > 50 & prodgap_perc_LNS < 50 & wbregion == "South Asia") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(midgreen) mlabcolor(midgreen)) ///
	(scatter prodgap_perc_LNS importshare if importrank == 1 & foodgroup == "Legumes, nuts and seeds" & ///
	(importshare > 50 & prodgap_perc_LNS < 50 & wbregion == "Sub-Saharan Africa") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(gold) mlabcolor(gold)) ///
	, ytitle("Self-sufficiency gap (in %)", size(small)) ylab(, angle(0)) xtitle("Share of imports from one country (in %)", size(small)) note("n = `Nnote'", size(vsmall) position(2) ring(0)) graphregion(color(white)) plotregion(margin(r+5)) name(g1, replace) title("Legumes, nuts and seeds", color(black) size(medsmall)) nodraw ///
	legend(rows(3) region(lstyle(none)) label(1 "East Asia and Pacific") label(2 "Europe and Central Asia") label(3 "Latin America and Caribbean") label(4 "Middle East and North Africa") label(5 "North America") label(6 "South Asia") label(7 "Sub-Saharan Africa"))

// SS
sum importrank if importrank == 1 & foodgroup == "Starchy staples" & importshare > 50 & prodgap_perc_SS < 50
local Nnote1 = `r(sum)'
count if prodgap_perc_SS < . &  importshare  < . & importrank == 1 & foodgroup == "Starchy staples"
local Nnote2 = `r(N)'
local Nnote = "`Nnote1' of `Nnote2'"

graph set window fontface "Times New Roman"
twoway (scatter prodgap_perc_SS importshare if importrank == 1 & foodgroup == "Starchy staples" & ///
	(importshare > 50 & prodgap_perc_SS < 50 & wbregion == "East Asia and Pacific") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(midblue) mlabcolor(midblue)) ///
	(scatter prodgap_perc_SS importshare if importrank == 1 & foodgroup == "Starchy staples" & ///
	(importshare > 50 & prodgap_perc_SS < 50 & wbregion == "Europe and Central Asia") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(orange) mlabcolor(orange)) ///
	(scatter prodgap_perc_SS importshare if importrank == 1 & foodgroup == "Starchy staples" & ///
	(importshare > 50 & prodgap_perc_SS < 50 & wbregion == "Latin America and Caribbean") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(gs8) mlabcolor(gs8)) ///
	(scatter prodgap_perc_SS importshare if importrank == 1 & foodgroup == "Starchy staples" & ///
	(importshare > 50 & prodgap_perc_SS < 50 & wbregion == "Middle East and North Africa") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(sienna) mlabcolor(sienna)) ///
	(scatter prodgap_perc_SS importshare if importrank == 1 & foodgroup == "Starchy staples" & ///
	(importshare > 50 & prodgap_perc_SS < 50 & wbregion == "North America") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(red) mlabcolor(red)) ///
	(scatter prodgap_perc_SS importshare if importrank == 1 & foodgroup == "Starchy staples" & ///
	(importshare > 50 & prodgap_perc_SS < 50 & wbregion == "South Asia") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(midgreen) mlabcolor(midgreen)) ///
	(scatter prodgap_perc_SS importshare if importrank == 1 & foodgroup == "Starchy staples" & ///
	(importshare > 50 & prodgap_perc_SS < 50 & wbregion == "Sub-Saharan Africa") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(gold) mlabcolor(gold)) ///
	, ytitle("Self-sufficiency gap (in %)", size(small)) ylab(, angle(0)) xtitle("Share of imports from one country (in %)", size(small)) note("n = `Nnote'", size(vsmall) position(5) ring(0)) graphregion(color(white)) plotregion(margin(r+5)) name(g2, replace) title("Starchy staples", color(black) size(medsmall)) nodraw legend(off)

// Dairy
sum importrank if importrank == 1 & foodgroup == "Dairy" & importshare > 50 & prodgap_perc_dairy < 50
local Nnote1 = `r(sum)'
count if prodgap_perc_dairy < . &  importshare  < . & importrank == 1 & foodgroup == "Dairy"
local Nnote2 = `r(N)'
local Nnote = "`Nnote1' of `Nnote2'"

graph set window fontface "Times New Roman"
twoway (scatter prodgap_perc_dairy importshare if importrank == 1 & foodgroup == "Dairy" & ///
	(importshare > 50 & prodgap_perc_dairy < 50 & wbregion == "East Asia and Pacific") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(midblue) mlabcolor(midblue)) ///
	(scatter prodgap_perc_dairy importshare if importrank == 1 & foodgroup == "Dairy" & ///
	(importshare > 50 & prodgap_perc_dairy < 50 & wbregion == "Europe and Central Asia") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(orange) mlabcolor(orange)) ///
	(scatter prodgap_perc_dairy importshare if importrank == 1 & foodgroup == "Dairy" & ///
	(importshare > 50 & prodgap_perc_dairy < 50 & wbregion == "Latin America and Caribbean") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(gs8) mlabcolor(gs8)) ///
	(scatter prodgap_perc_dairy importshare if importrank == 1 & foodgroup == "Dairy" & ///
	(importshare > 50 & prodgap_perc_dairy < 50 & wbregion == "Middle East and North Africa") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(sienna) mlabcolor(sienna)) ///
	(scatter prodgap_perc_dairy importshare if importrank == 1 & foodgroup == "Dairy" & ///
	(importshare > 50 & prodgap_perc_dairy < 50 & wbregion == "North America") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(red) mlabcolor(red)) ///
	(scatter prodgap_perc_dairy importshare if importrank == 1 & foodgroup == "Dairy" & ///
	(importshare > 50 & prodgap_perc_dairy < 50 & wbregion == "South Asia") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(midgreen) mlabcolor(midgreen)) ///
	(scatter prodgap_perc_dairy importshare if importrank == 1 & foodgroup == "Dairy" & ///
	(importshare > 50 & prodgap_perc_dairy < 50 & wbregion == "Sub-Saharan Africa") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(gold) mlabcolor(gold)) ///
	, ytitle("Self-sufficiency gap (in %)", size(small)) ylab(, angle(0)) xtitle("Share of imports from one country (in %)", size(small)) note("n = `Nnote'", size(vsmall) position(2) ring(0)) graphregion(color(white)) plotregion(margin(r+5)) name(g3, replace) title("Dairy", color(black) size(medsmall)) nodraw legend(off)

// Fruits
sum importrank if importrank == 1 & foodgroup == "Fruits" & importshare > 50 & prodgap_perc_fruit < 50
local Nnote1 = `r(sum)'
count if prodgap_perc_fruit < . &  importshare  < . & importrank == 1 & foodgroup == "Fruits"
local Nnote2 = `r(N)'
local Nnote = "`Nnote1' of `Nnote2'"

graph set window fontface "Times New Roman"
twoway (scatter prodgap_perc_fruit importshare if importrank == 1 & foodgroup == "Fruits" & ///
	(importshare > 50 & prodgap_perc_fruit < 50 & wbregion == "East Asia and Pacific") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(midblue) mlabcolor(midblue)) ///
	(scatter prodgap_perc_fruit importshare if importrank == 1 & foodgroup == "Fruits" & ///
	(importshare > 50 & prodgap_perc_fruit < 50 & wbregion == "Europe and Central Asia") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(orange) mlabcolor(orange)) ///
	(scatter prodgap_perc_fruit importshare if importrank == 1 & foodgroup == "Fruits" & ///
	(importshare > 50 & prodgap_perc_fruit < 50 & wbregion == "Latin America and Caribbean") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(gs8) mlabcolor(gs8)) ///
	(scatter prodgap_perc_fruit importshare if importrank == 1 & foodgroup == "Fruits" & ///
	(importshare > 50 & prodgap_perc_fruit < 50 & wbregion == "Middle East and North Africa") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(sienna) mlabcolor(sienna)) ///
	(scatter prodgap_perc_fruit importshare if importrank == 1 & foodgroup == "Fruits" & ///
	(importshare > 50 & prodgap_perc_fruit < 50 & wbregion == "North America") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(red) mlabcolor(red)) ///
	(scatter prodgap_perc_fruit importshare if importrank == 1 & foodgroup == "Fruits" & ///
	(importshare > 50 & prodgap_perc_fruit < 50 & wbregion == "South Asia") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(midgreen) mlabcolor(midgreen)) ///
	(scatter prodgap_perc_fruit importshare if importrank == 1 & foodgroup == "Fruits" & ///
	(importshare > 50 & prodgap_perc_fruit < 50 & wbregion == "Sub-Saharan Africa") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(gold) mlabcolor(gold)) ///
	, ytitle("Self-sufficiency gap (in %)", size(small)) ylab(, angle(0)) xtitle("Share of imports from one country (in %)", size(small)) note("n = `Nnote'", size(vsmall) position(5) ring(0)) graphregion(color(white)) plotregion(margin(r+5)) name(g4, replace) title("Fruits", color(black) size(medsmall)) nodraw legend(off)

// Meat 
sum importrank if importrank == 1 & foodgroup == "Meat" & importshare > 50 & prodgap_perc_meat < 50
local Nnote1 = `r(sum)'
count if prodgap_perc_meat < . &  importshare  < . & importrank == 1 & foodgroup == "Meat"
local Nnote2 = `r(N)'
local Nnote = "`Nnote1' of `Nnote2'"

graph set window fontface "Times New Roman"
twoway (scatter prodgap_perc_meat importshare if importrank == 1 & foodgroup == "Meat" & ///
	(importshare > 50 & prodgap_perc_meat < 50 & wbregion == "East Asia and Pacific") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(midblue) mlabcolor(midblue)) ///
	(scatter prodgap_perc_meat importshare if importrank == 1 & foodgroup == "Meat" & ///
	(importshare > 50 & prodgap_perc_meat < 50 & wbregion == "Europe and Central Asia") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(orange) mlabcolor(orange)) ///
	(scatter prodgap_perc_meat importshare if importrank == 1 & foodgroup == "Meat" & ///
	(importshare > 50 & prodgap_perc_meat < 50 & wbregion == "Latin America and Caribbean") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(gs8) mlabcolor(gs8)) ///
	(scatter prodgap_perc_meat importshare if importrank == 1 & foodgroup == "Meat" & ///
	(importshare > 50 & prodgap_perc_meat < 50 & wbregion == "Middle East and North Africa") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(sienna) mlabcolor(sienna)) ///
	(scatter prodgap_perc_meat importshare if importrank == 1 & foodgroup == "Meat" & ///
	(importshare > 50 & prodgap_perc_meat < 50 & wbregion == "North America") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(red) mlabcolor(red)) ///
	(scatter prodgap_perc_meat importshare if importrank == 1 & foodgroup == "Meat" & ///
	(importshare > 50 & prodgap_perc_meat < 50 & wbregion == "South Asia") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(midgreen) mlabcolor(midgreen)) ///
	(scatter prodgap_perc_meat importshare if importrank == 1 & foodgroup == "Meat" & ///
	(importshare > 50 & prodgap_perc_meat < 50 & wbregion == "Sub-Saharan Africa") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(gold) mlabcolor(gold)) ///
	, ytitle("Self-sufficiency gap (in %)", size(small)) ylab(, angle(0)) xtitle("Share of imports from one country (in %)", size(small)) note("n = `Nnote'", size(vsmall) position(5) ring(0)) graphregion(color(white)) plotregion(margin(r+5)) name(g5, replace) title("Meat", color(black) size(medsmall)) nodraw legend(off)

// Vegetables
sum importrank if importrank == 1 & foodgroup == "Vegetables" & importshare > 50 & prodgap_perc_veg < 50
local Nnote1 = `r(sum)'
count if prodgap_perc_veg < . &  importshare  < . & importrank == 1 & foodgroup == "Vegetables"
local Nnote2 = `r(N)'
local Nnote = "`Nnote1' of `Nnote2'"

graph set window fontface "Times New Roman"
twoway (scatter prodgap_perc_veg importshare if importrank == 1 & foodgroup == "Vegetables" & ///
	(importshare > 50 & prodgap_perc_veg < 50 & wbregion == "East Asia and Pacific") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(midblue) mlabcolor(midblue)) ///
	(scatter prodgap_perc_veg importshare if importrank == 1 & foodgroup == "Vegetables" & ///
	(importshare > 50 & prodgap_perc_veg < 50 & wbregion == "Europe and Central Asia") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(orange) mlabcolor(orange)) ///
	(scatter prodgap_perc_veg importshare if importrank == 1 & foodgroup == "Vegetables" & ///
	(importshare > 50 & prodgap_perc_veg < 50 & wbregion == "Latin America and Caribbean") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(gs8) mlabcolor(gs8)) ///
	(scatter prodgap_perc_veg importshare if importrank == 1 & foodgroup == "Vegetables" & ///
	(importshare > 50 & prodgap_perc_veg < 50 & wbregion == "Middle East and North Africa") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(sienna) mlabcolor(sienna)) ///
	(scatter prodgap_perc_veg importshare if importrank == 1 & foodgroup == "Vegetables" & ///
	(importshare > 50 & prodgap_perc_veg < 50 & wbregion == "North America") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(red) mlabcolor(red)) ///
	(scatter prodgap_perc_veg importshare if importrank == 1 & foodgroup == "Vegetables" & ///
	(importshare > 50 & prodgap_perc_veg < 50 & wbregion == "South Asia") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(midgreen) mlabcolor(midgreen)) ///
	(scatter prodgap_perc_veg importshare if importrank == 1 & foodgroup == "Vegetables" & ///
	(importshare > 50 & prodgap_perc_veg < 50 & wbregion == "Sub-Saharan Africa") ///
	, msize(small) mlab(iso3) mlabposition(12) mcolor(gold) mlabcolor(gold)) ///
	, ytitle("Self-sufficiency gap (in %)", size(small)) ylab(, angle(0)) xtitle("Share of imports from one country (in %)", size(small)) note("n = `Nnote'", size(vsmall) position(5) ring(0)) graphregion(color(white)) plotregion(margin(r+5)) name(g6, replace) title("Vegetables", color(black) size(medsmall)) legend(off) //nodraw

}

// Combine 
graph set window fontface "Times New Roman"
grc1leg2 g4 g6 g3 g1 g5 g2, rows(3) cols(2) imargin(zero) ysize(2.3) xsize(2) graphregion(color(white)) ycommon xcommon xtob1title ytol1title legendfrom(g1) ring(100)
graph export "$workdir/graphs/shockrisk_worldregion.png", replace


*** 2 Importers (not used in paper) ***
bysort country_name foodgroup: egen twoimportshare = total(importshare) if inlist(importrank,1,2)
graph set window fontface "Times New Roman"

twoway (scatter prodgap_perc_LNS twoimportshare if importrank == 1 & twoimportshare > 66.6 & foodgroup == "Legumes, nuts and seeds" & prodgap_perc_LNS < 50, msize(small) mlab(iso3) mcolor(black) mlabcolor(black) ytitle("Self-sufficiency gap") xtitle("Share of imports from one country")), graphregion(color(white)) plotregion(margin(r+5)) ylab(,angle(0)) name(g1, replace) title("Legumes, nuts and seeds", color(black)) nodraw

twoway (scatter prodgap_perc_SS twoimportshare if importrank == 1 & twoimportshare > 66.6 & foodgroup == "Starchy staples" & prodgap_perc_SS < 50, msize(small) mlab(iso3) mcolor(black) mlabcolor(black) ytitle("Self-sufficiency gap") xtitle("Share of imports from one country")), graphregion(color(white)) plotregion(margin(r+5)) ylab(,angle(0)) name(g2, replace) title("Starchy staples", color(black)) nodraw

twoway (scatter prodgap_perc_dairy twoimportshare if importrank == 1 & twoimportshare > 66.6 & foodgroup == "Dairy" & prodgap_perc_dairy < 50, msize(small) mlab(iso3) mcolor(black) mlabcolor(black) ytitle("Self-sufficiency gap") xtitle("Share of imports from one country")), graphregion(color(white)) plotregion(margin(r+5)) ylab(,angle(0)) name(g3, replace) title("Dairy", color(black)) nodraw

twoway (scatter prodgap_perc_fruit twoimportshare if importrank == 1 & twoimportshare > 66.6 & foodgroup == "Fruits" & prodgap_perc_fruit < 50, msize(small) mlab(iso3) mcolor(black) mlabcolor(black) ytitle("Self-sufficiency gap") xtitle("Share of imports from one country")), graphregion(color(white)) plotregion(margin(r+5)) ylab(,angle(0)) name(g4, replace) title("Fruits", color(black)) nodraw

twoway (scatter prodgap_perc_meat twoimportshare if importrank == 1 & twoimportshare > 66.6 & foodgroup == "Meat" & prodgap_perc_meat < 50, msize(small) mlab(iso3) mcolor(black) mlabcolor(black) ytitle("Self-sufficiency gap") xtitle("Share of imports from one country")), graphregion(color(white)) plotregion(margin(r+5)) ylab(,angle(0)) name(g5, replace) title("Meat", color(black)) nodraw

twoway (scatter prodgap_perc_veg twoimportshare if importrank == 1 & twoimportshare > 66.6 & foodgroup == "Vegetables" & prodgap_perc_veg < 50, msize(small) mlab(iso3) mcolor(black) mlabcolor(black) ytitle("Self-sufficiency gap") xtitle("Share of imports from one country")), graphregion(color(white)) plotregion(margin(r+5)) ylab(,angle(0)) name(g6, replace) title("Vegetables", color(black)) nodraw


graph combine g2 g3 g4 g5 g1 g6, rows(3) cols(2) ysize(2) xsize(2) imargin(zero) graphregion(color(white)) /*ycommon xcommon*/
//grc1leg2 g2 g3 g4 g5 g1 g6, rows(3) cols(2) ysize(2) xsize(2) graphregion(color(white)) //ytitlefrom(g2) 
graph export "$workdir/graphs/shockrisk_twoimporters.png", replace




