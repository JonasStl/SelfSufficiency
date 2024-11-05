********************************************************************************
************************************* Maps *************************************
********************************************************************************

*** Maps 


cd "/Users/jonasstehl/ownCloud/Healthy food poverty/Analysis/data/shapefiles"
//spshape2dta WB_countries_Admin0_10m, replace saving(_worldmap)

use "/Users/jonasstehl/ownCloud/Healthy food poverty/Analysis/data/shapefiles/_worldmap.dta", clear
ren ISO_A3_EH iso3
replace iso3 = "NOR" if WB_A3 == "NOR"
duplicates list iso3
duplicates drop iso3, force

merge 1:1 iso3 using "$datadir/productiongap.dta", //nogen

*** Gap for various food groups on country-level

*Livewell Diet
graph set window fontface "Times New Roman"

spmap prodgap_perc_fruit using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Fruits production gap (in perc)") clmethod(custom) clbreaks(-40 20 40 60 80 100 1500)  name(map_fruits, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(medium) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Fruits", size(medsmall))
graph export "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/graphs/gap_fruits.png", replace

spmap prodgap_perc_veg using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Vegetables production gap (in perc)") clmethod(custom) clbreaks(-13 20 40 60 80 100 360)  name(map_veg, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Vegetables", size(medsmall))
graph export "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/graphs/gap_veg.png", replace

spmap prodgap_perc_SS using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Starchy staples production gap (in perc)") clmethod(custom) clbreaks(-650 20 40 60 80 100 1005)  name(map_SS, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Starchy Staples", size(medsmall))
graph export "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/graphs/gap_SS.png", replace

spmap prodgap_perc_dairy using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Starchy staples production gap (in perc)") clmethod(custom) clbreaks(-18 20 40 60 80 100 6500)  name(map_dairy, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Dairy", size(medsmall))
graph export "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/graphs/gap_dairy.png", replace

spmap prodgap_perc_fish using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Fish production gap (in perc)") clmethod(custom) clbreaks(-1200 20 40 60 80 100 12000)  name(map_fish, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Fish", size(medsmall))
graph export "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/graphs/gap_fish.png", replace

spmap prodgap_perc_meat using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Meat production gap (in perc)") clmethod(custom) clbreaks(0 20 40 60 80 100 1700)  name(map_meat, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Meat", size(medsmall))
graph export "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/graphs/gap_meat.png", replace

spmap prodgap_perc_LNS using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Legumes, nuts, and seeds" "production gap (in perc)") clmethod(custom) clbreaks(-800 20 40 60 80 100 22000)  name(map_LNS, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Legumes, nuts, and seeds", size(medsmall))
graph export "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/graphs/gap_LNS.png", replace

spmap productdeprv using _worldmap_shp, id(_ID) fcolor(red*1.9 red*1.6 red*1.3 red*1 red*0.7 red*0.4 red*0.1) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Number of food groups self-sufficient at") clmethod(custom) clbreaks(0 1 2 3 4 5 6 7)  name(map_depr, replace) legend(order(1 "No data" 2 "0" 3 "1" 4 "2" 5 "3" 6 "4" 7 "5" 8 "6") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Self-sufficiency", size(small))
graph export "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/graphs/productdpr_map.png", replace

//one large legend
graph set window fontface "Times New Roman"
grc1leg2 map_fruits map_veg map_dairy map_fish map_meat map_LNS map_SS , rows(4) cols(2) graphregion(color(white)) ring(0) position(4) /*lxoffset(-30)*/ imargin(0) xsize(3.3) ysize(3)
graph export "$workdir/graphs/worldmap_FGgaps.png", replace 


*EAT-Lancet
graph set window fontface "Times New Roman"

spmap eatgap_perc_fruit using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Fruits production gap (in perc)") clmethod(custom) clbreaks(-30 20 40 60 80 100 1100)  name(map_fruits_eat, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(medium) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Fruits", size(medsmall))

spmap eatgap_perc_veg using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Vegetables production gap (in perc)") clmethod(custom) clbreaks(-11 20 40 60 80 100 300)  name(map_veg_eat, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Vegetables", size(medsmall))

spmap eatgap_perc_SS using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Starchy staples production gap (in perc)") clmethod(custom) clbreaks(-900 20 40 60 80 100 1105)  name(map_SS_eat, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Starchy Staples", size(medsmall))

spmap eatgap_perc_dairy using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Starchy staples production gap (in perc)") clmethod(custom) clbreaks(-18 20 40 60 80 100 6500)  name(map_dairy_eat, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Dairy", size(medsmall))

spmap eatgap_perc_fish using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Fish production gap (in perc)") clmethod(custom) clbreaks(-1600 20 40 60 80 100 13500)  name(map_fish_eat, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Fish", size(medsmall))

spmap eatgap_perc_meat using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Meat production gap (in perc)") clmethod(custom) clbreaks(0 20 40 60 80 100 1600)  name(map_meat_eat, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Meat", size(medsmall))

spmap eatgap_perc_LNS using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Legumes, nuts, and seeds" "production gap (in perc)") clmethod(custom) clbreaks(-190 20 40 60 80 100 22000)  name(map_LNS_eat, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Legumes, nuts and seeds", size(medsmall))

spmap productdeprv_eat using _worldmap_shp, id(_ID) fcolor(red*1.9 red*1.6 red*1.3 red*1 red*0.7 red*0.4 red*0.1) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Number of food groups self-sufficient at") clmethod(custom) clbreaks(0 1 2 3 4 5 6 7)  name(map_depr_eat, replace) legend(order(1 "No data" 2 "0" 3 "1" 4 "2" 5 "3" 6 "4" 7 "5" 8 "6") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Self-sufficiency", size(small))


//one large legend
grc1leg2 map_fruits_eat map_veg_eat map_dairy_eat map_fish_eat map_meat_eat map_LNS_eat map_SS_eat, rows(4) cols(2) graphregion(color(white)) ring(0) position(4) /*lxoffset(-30)*/ imargin(0) xsize(3.3) ysize(3)
graph export "$workdir/graphs/worldmap_FGgaps_EAT.png", replace 


*** Gaps adjusted for future production ***
*Livewell Diet
graph set window fontface "Times New Roman"

spmap prodgap_perc_cap_SS using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Starchy staples production gap (in perc)") clmethod(custom) clbreaks(-650 20 40 60 80 100 1005)  name(map_SS, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Starchy Staples", size(medsmall))
graph export "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/graphs/gap_cap_SS.png", replace

spmap prodgap_perc_cap_dairy using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Starchy staples production gap (in perc)") clmethod(custom) clbreaks(-18 20 40 60 80 100 6500)  name(map_dairy, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Dairy", size(medsmall))
graph export "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/graphs/gap_cap_dairy.png", replace

spmap prodgap_perc_cap_fish using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Fish production gap (in perc)") clmethod(custom) clbreaks(-1200 20 40 60 80 100 12000)  name(map_fish, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Fish", size(medsmall))
graph export "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/graphs/gap_cap_fish.png", replace

spmap prodgap_perc_cap_meat using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Meat production gap (in perc)") clmethod(custom) clbreaks(0 20 40 60 80 100 1700)  name(map_meat, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Meat", size(medsmall))
graph export "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/graphs/gap_cap_meat.png", replace

spmap prodgap_perc_cap_LNS using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Legumes, nuts, and seeds" "production gap (in perc)") clmethod(custom) clbreaks(-800 20 40 60 80 100 22000)  name(map_LNS, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Legumes, nuts, and seeds", size(medsmall))
graph export "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/graphs/gap_cap_LNS.png", replace

spmap productdeprv_cap using _worldmap_shp, id(_ID) fcolor(red*1.9 red*1.6 red*1.3 red*1 red*0.7 red*0.4 red*0.1) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Number of food groups self-sufficient at") clmethod(custom) clbreaks(0 1 2 3 4 5 6 7)  name(map_depr, replace) legend(order(1 "No data" 2 "0" 3 "1" 4 "2" 5 "3" 6 "4" 7 "5" 8 "6") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Self-sufficiency", size(small))
graph export "/Users/jonasstehl/ownCloud/Tandem/Healthy Diet Gap/Analysis/graphs/productdpr_cap_map.png", replace

//one large legend
graph set window fontface "Times New Roman"
grc1leg2 map_dairy map_fish map_meat map_LNS map_SS , rows(4) cols(2) graphregion(color(white)) ring(0) position(4) /*lxoffset(-30)*/ imargin(0) xsize(3.3) ysize(2.5)
graph export "$workdir/graphs/worldmap_FGgaps_cap.png", replace 


*EAT-Lancet
graph set window fontface "Times New Roman"

spmap eatgap_perc_cap_SS using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Starchy staples production gap (in perc)") clmethod(custom) clbreaks(-900 20 40 60 80 100 1105)  name(map_SS_eat, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Starchy Staples", size(medsmall))

spmap eatgap_perc_cap_dairy using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Starchy staples production gap (in perc)") clmethod(custom) clbreaks(-18 20 40 60 80 100 6500)  name(map_dairy_eat, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Dairy", size(medsmall))

spmap eatgap_perc_cap_fish using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Fish production gap (in perc)") clmethod(custom) clbreaks(-1600 20 40 60 80 100 13500)  name(map_fish_eat, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Fish", size(medsmall))

spmap eatgap_perc_cap_meat using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Meat production gap (in perc)") clmethod(custom) clbreaks(0 20 40 60 80 100 1600)  name(map_meat_eat, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Meat", size(medsmall))

spmap eatgap_perc_cap_LNS using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Legumes, nuts, and seeds" "production gap (in perc)") clmethod(custom) clbreaks(-190 20 40 60 80 100 22000)  name(map_LNS_eat, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Legumes, nuts and seeds", size(medsmall))

spmap productdeprv_cap_eat using _worldmap_shp, id(_ID) fcolor(red*1.9 red*1.6 red*1.3 red*1 red*0.7 red*0.4 red*0.1) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Number of food groups self-sufficient at") clmethod(custom) clbreaks(0 1 2 3 4 5 6 7)  name(map_depr_eat, replace) legend(order(1 "No data" 2 "0" 3 "1" 4 "2" 5 "3" 6 "4" 7 "5" 8 "6") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Self-sufficiency", size(small))


//one large legend
grc1leg2 map_dairy_eat map_fish_eat map_meat_eat map_LNS_eat map_SS_eat, rows(4) cols(2) graphregion(color(white)) ring(0) position(4) /*lxoffset(-30)*/ imargin(0) xsize(3.3) ysize(2.5)
graph export "$workdir/graphs/worldmap_FGgaps_EAT_cap.png", replace 


*** Change in gaps adjusted for future production ***

* Create new variable
foreach group in LNS SS dairy fish meat {
	gen prodgap_change_`group' = prodgap_cap_change_`group'
	replace prodgap_change_`group' = 150 if prodgap_perc_cap_`group' >= 100 & prodgap_perc_cap_`group' < . & prodgap_perc_`group' < 100 // before not SS but now
	replace prodgap_change_`group' = 250 if prodgap_perc_cap_`group' >= 100 & prodgap_perc_cap_`group' < . & prodgap_perc_`group' >= 100 & prodgap_perc_`group' < . // before and now SS
	replace prodgap_change_`group' = 350 if prodgap_perc_cap_`group' < 100 & prodgap_perc_`group' >= 100 & prodgap_perc_`group' < . // before yes but now not SS
}

foreach group in LNS SS dairy fish meat {
	tab coverage_`group' coverage_cap_`group'
	bysort REGION_WB: sum prodgap_perc_cap_`group' if coverage_`group' == 0
}


*Livewell Diet
graph set window fontface "Times New Roman"

// Starchy staples
spmap prodgap_change_SS using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Starchy staples production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_SS, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(large) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Starchy Staples", size(medsmall))

fre prodgap_change_SS
bysort REGION_WB: fre prodgap_change_SS
sum prodgap_cap_change_SS if prodgap_perc_SS < 100
bysort REGION_WB: sum prodgap_cap_change_SS if prodgap_perc_SS < 100
/*
World:
-  High SS at beginning
- Only in 5 countries the gap is expected to increase
- 10 countries achieve SS
- Countries not SS in 2020 could close the gap by 7 p.p. on average
- In SSA, these countries can expect an increase of 16%, around twice as much as the average self-insufficient country
*/


// Dairy
spmap prodgap_change_dairy using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Dairy production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_dairy, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(large) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Dairy", size(medsmall))

fre prodgap_change_dairy
bysort REGION_WB: fre prodgap_change_dairy
sum prodgap_perc_dairy if prodgap_perc_dairy < 100
sum prodgap_cap_change_dairy if prodgap_perc_dairy < 100
bysort REGION_WB: sum prodgap_cap_change_dairy if prodgap_perc_dairy < 100

/*
World:
- 6 countries can achieve SS
- Countries not SS in 2020 could close gap by 6.28 p.p.
- Growth here is particularly high in South Asia with growth of 14 p.p. and SSA with 9 p.p.
- Low growth in East Asia and Pacific with only 1 p.p.
*/

// Fish
spmap prodgap_change_fish using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Fish production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_fish, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Fish", size(medsmall))

fre prodgap_change_fish
bysort REGION_WB: fre prodgap_change_fish
sum prodgap_cap_change_fish if prodgap_perc_fish < 100
bysort REGION_WB: sum prodgap_cap_change_fish if prodgap_perc_fish < 100

/*
World:
- Only two countries can achieve SS, although many have not yet
- Negative growth in Latin America and the Caribbean expected
- Growth in SSA in all but one country
- Potential is comparatively low with only 2.34 p.p. expected gap closure for self-insufficient countries
- In SSA highest with around 5 p.p., but still comapratively low to other food groups
- Gap for insufficient countries will increase by around 2.1 p.p. in Latin America
*/

// Meat
spmap prodgap_change_meat using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Meat production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_meat, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Meat", size(medsmall))

fre prodgap_change_meat
bysort REGION_WB: fre prodgap_change_meat
sum prodgap_cap_change_meat if prodgap_perc_meat < 100
bysort REGION_WB: sum prodgap_cap_change_meat if prodgap_perc_meat < 100

/*
World:
- 9 more countries are able to achieve SS, of which 5 are in Middle East & North Africa
- Pos. change in all countries in SSA
- Self.insufficient countries close the gap by 12 p.p. on average, larger than for all other food groups
- This is driven by insufficient countries in Middle East & North Africa which are able to close the gap by 28 p.p. on average 
- Also high growth in SSA with 13 p.p.
*/

// LNS
spmap prodgap_change_LNS using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Legumes, nuts, and seeds production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_LNS, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Legumes, nuts, and seeds", size(medsmall))

fre prodgap_change_LNS
bysort REGION_WB: fre prodgap_change_LNS
sum prodgap_cap_change_LNS if prodgap_perc_LNS < 100
bysort REGION_WB: sum prodgap_cap_change_LNS if prodgap_perc_LNS < 100

/*
World:
- 15 countries can close the gap and become self.sufficient
- Pos. change in all regions but Middle East and North Africa
- Self-sufficient countries close the gap by on average 19 p.p., even more than for meat
- This is driven by high growth in Europe and Central Asia (+32 p.p.) and East Asia & Pacific (+ 22 p.p.) and SSA (+ 22 p.p.)
*/

//one large legend
graph set window fontface "Times New Roman"
grc1leg2 map_dairy map_fish map_meat map_LNS map_SS , rows(4) cols(2) graphregion(color(white)) ring(0) position(4) /*lxoffset(-30)*/ imargin(0) xsize(3) ysize(2)
graph export "$workdir/graphs/worldmap_FGgaps_capchange.png", replace 


*** Economic Unions ***
encode econunions, gen(unions)
fre unions
graph set window fontface "Times New Roman"
spmap unions using _worldmap_shp, id(_ID) fcolor(red midblue green yellow orange gold midgreen blue sienna purple sand ebblue cranberry erose) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Economic Unions") clmethod(custom) clbreaks(0.5 1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5 14.5)  name(map_unions, replace) legend(off) graphregion(color(white)) title("Economic Unions")




*** Change in gaps with 2032 projections ***
cd "/Users/jonasstehl/ownCloud/Healthy food poverty/Analysis/data/shapefiles"
//spshape2dta WB_countries_Admin0_10m, replace saving(_worldmap)

use "/Users/jonasstehl/ownCloud/Healthy food poverty/Analysis/data/shapefiles/_worldmap.dta", clear
ren ISO_A3_EH iso3
replace iso3 = "NOR" if WB_A3 == "NOR"
duplicates list iso3
duplicates drop iso3, force

merge 1:1 iso3 using "$datadir/timetrends_productiongap_2032.dta", //nogen



* Create new variable
foreach group in LNS SS dairy fish meat {
	gen prodgap_change_`group' = prodgap_change_`group'2032
	replace prodgap_change_`group' = 150 if prodgap_perc_`group'2032 >= 100 & prodgap_perc_`group'2032 < . & SS_2020_`group' == 0 // before not SS but now
	replace prodgap_change_`group' = 250 if prodgap_perc_`group'2032 >= 100 & prodgap_perc_`group'2032 < . & SS_2020_`group' == 1 // before and now SS
	replace prodgap_change_`group' = 350 if prodgap_perc_`group'2032 < 100 & prodgap_perc_`group'2032 >= 100 & SS_2020_`group' == 0 // before yes but now not SS
}


*Livewell Diet
graph set window fontface "Times New Roman"

// Starchy staples
spmap prodgap_change_SS using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Starchy staples production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_SS, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(large) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Starchy Staples", size(medsmall))

fre prodgap_change_SS
bysort REGION_WB: fre prodgap_change_SS
sum prodgap_change_SS2032 if SS_2020_SS == 0
bysort REGION_WB: sum prodgap_change_SS2032 if SS_2020_SS == 0
/*
World:
-  -17.83581 to +35.80469
- Pos. trends in most countries in SSA
- 4 countries achieve self.sufficiency

- SS gap closure at 2 p.p. on average
- Greates in Europe at Central Asia with a reduction of 8 p.p.
- While the gap increases Middle East & North Africa and South Asia 
- For SSA the gap has reduced down to 2 p.p.
*/

// Dairy
spmap prodgap_change_dairy using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Dairy production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_dairy, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(large) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Dairy", size(medsmall))

fre prodgap_change_dairy
bysort REGION_WB: fre prodgap_change_dairy
sum prodgap_change_dairy2032 if SS_2020_dairy == 0
bysort REGION_WB: sum prodgap_change_dairy2032 if SS_2020_dairy == 0
/*
World:
- -9.33947 to +12.56126
- No country achieves self-sufficiency
- High levels already in Europe
- Pos. trends in most countries in Latin America & Caribbean and SSA

- SS gap closure only at 1 p.p.
- Gap closure in South Asia still the highest, but reduced down to 4 p.p.
- Also SSA still manages to reduce this gap, but by less than 1 p.p.
*/

// Fish
spmap prodgap_change_fish using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Fish production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_fish, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Fish", size(medsmall))

fre prodgap_change_fish
bysort REGION_WB: fre prodgap_change_fish
sum prodgap_change_fish2032 if SS_2020_fish == 0
bysort REGION_WB: sum prodgap_change_fish2032 if SS_2020_fish == 0
/*
World:
- -40.08727 to +11.47012
- starts at low levels of self-sufficiency
- Only 1 country achieves self-sufficiency
- positive change in almost all countries in Europe and Central Asia
- Negative change in almost all other world regions: Latin America & Caribbean (decrease in production expected), Middle East & North Africa (increase in pop.), Sub-Saharan Africa (increase in pop.)
- In SSA poulation growth will outgrow increase in production
- Self-sufficiency gap in Australia increases by -.0761528 percentage points due to small increases in their population, e.g. remains more or less constant (-> check expected growth)

- SS gap for fish and seafood of not SS countries in 2020 is expected to increase by more than 1 p.p.
- Only countries in Europe & Central Asia and South Asia (not SS) are expected to reduce their gap by 2 p.p., respectively
- All other regions experience an increase, Latin America & the Caribbean even by 5 p.p.
*/

// Meat
spmap prodgap_change_meat using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Meat production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_meat, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Meat", size(medsmall))

fre prodgap_change_meat
bysort REGION_WB: fre prodgap_change_meat
sum prodgap_change_meat2032 if SS_2020_meat == 0
bysort REGION_WB: sum prodgap_change_meat2032 if SS_2020_meat == 0
/*
World:
- -11.33776 to +16.86659
- only 3 countries are expected to become self-sufficient (many are already), of which two are in Asia
- positive changes are rather low (already at high levels)
- Negative changes in most countriess in SSA, although they underconsume already --> will become potentially more dependent on imports without structural change in the production of meat -> growth insufficient
- Gap closure has halved to 6 p.p. of countries not SS in 2020
- For Middle East and North Africa, where potentnial was at 28 p.p., it has reduced substantially to only 5 p.p.
- For SSA the gap is even expected to increase by 2 p.p. for these countries (from previously + 13 p.p.)
*/

// LNS
spmap prodgap_change_LNS using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Legumes, nuts, and seeds production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_LNS, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Legumes, nuts, and seeds", size(medsmall))

fre prodgap_change_LNS
bysort REGION_WB: fre prodgap_change_LNS
sum prodgap_change_LNS2032 if SS_2020_LNS == 0
bysort REGION_WB: sum prodgap_change_LNS2032 if SS_2020_LNS == 0
/*
World:
- -26.58421 p.p. to +65.30365
- 13 countries achieve self-sufficiency, of which 7 are in Europe & Central Asia
- Negative changes are expected in Middle East and North Africa
- In sub-saharan Africa changes are mixed
- 15 p.p. gap closure of 102 countries
- Driven by Europe and Central Asia with 33 p.p.
- East Asia and Pacific also reduces the gap by 17 p.p.
- For SSA, the gap closure is reduced down to 6 p.p. (from 22 p.p.)
*/

//one large legend
graph set window fontface "Times New Roman"
grc1leg2 map_dairy map_fish map_meat map_LNS map_SS , rows(4) cols(2) graphregion(color(white)) ring(0) position(4) /*lxoffset(-30)*/ imargin(0) xsize(3) ysize(2)
graph export "$workdir/graphs/worldmap_FGgaps_2032change.png", replace 


