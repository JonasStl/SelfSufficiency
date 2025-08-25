********************************************************************************
************************************* Maps *************************************
********************************************************************************

global workdir "./SelfSufficiency/Analysis"
global datadir "./SelfSufficiency/Analysis/data"

cd "$datadir/shapefiles"
//spshape2dta WB_GAD_ADM0, replace saving(_worldmap)

use "$datadir/shapefiles/_worldmap.dta", clear
ren ISO_A3_EH iso3
replace iso3 = "NOR" if WB_A3 == "NOR"
duplicates list iso3

merge m:1 iso3 using "$datadir/productiongap.dta", //nogen

*** Economic Unions ***
encode econunions, gen(unions)
fre unions
graph set window fontface "Times New Roman"
spmap unions using _worldmap_shp, id(_ID) fcolor(red midblue green yellow orange gold midgreen blue sienna purple sand ebblue cranberry erose) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Economic Unions") clmethod(custom) clbreaks(0.5 1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5 14.5)  name(map_unions, replace) legend(off) graphregion(color(white)) title("Economic Unions")


*** Gap for various food groups on country-level ***

* Figure 1: Livewell Diet
graph set window fontface "Times New Roman"

spmap prodgap_perc_fruit using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Fruits production gap (in perc)") clmethod(custom) clbreaks(-40 20 40 60 80 100 1500)  name(map_fruits, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(medium) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Fruits", size(medsmall))
graph export "$workdir/graphs/gap_fruits.png", replace

spmap prodgap_perc_veg using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Vegetables production gap (in perc)") clmethod(custom) clbreaks(-13 20 40 60 80 100 360)  name(map_veg, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Vegetables", size(medsmall))
graph export "$workdir/graphs/gap_veg.png", replace

spmap prodgap_perc_SS using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Starchy staples production gap (in perc)") clmethod(custom) clbreaks(-650 20 40 60 80 100 1005)  name(map_SS, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Starchy Staples", size(medsmall))
graph export "$workdir/graphs/gap_SS.png", replace

spmap prodgap_perc_dairy using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Starchy staples production gap (in perc)") clmethod(custom) clbreaks(-18 20 40 60 80 100 6500)  name(map_dairy, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Dairy", size(medsmall))
graph export "$workdir/graphs/gap_dairy.png", replace

spmap prodgap_perc_fish using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Fish production gap (in perc)") clmethod(custom) clbreaks(-1200 20 40 60 80 100 12000)  name(map_fish, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Fish", size(medsmall))
graph export "$workdir/graphs/gap_fish.png", replace

spmap prodgap_perc_meat using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Meat production gap (in perc)") clmethod(custom) clbreaks(0 20 40 60 80 100 1700)  name(map_meat, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Meat", size(medsmall))
graph export "$workdir/graphs/gap_meat.png", replace

spmap prodgap_perc_LNS using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Legumes, nuts, and seeds" "production gap (in perc)") clmethod(custom) clbreaks(-800 20 40 60 80 100 22000)  name(map_LNS, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Legumes, nuts, and seeds", size(medsmall))
graph export "$workdir/graphs/gap_LNS.png", replace

spmap productdeprv using _worldmap_shp, id(_ID) fcolor(red*1.9 red*1.6 red*1.3 red*1 red*0.7 red*0.4 red*0.1) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Number of food groups self-sufficient at") clmethod(custom) clbreaks(0 1 2 3 4 5 6 7)  name(map_depr, replace) legend(order(1 "No data" 2 "0" 3 "1" 4 "2" 5 "3" 6 "4" 7 "5" 8 "6") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Self-sufficiency", size(small))
graph export "$workdir/graphs/productdpr_map.png", replace

//one large legend
graph set window fontface "Times New Roman"
grc1leg2 map_fruits map_veg map_dairy map_fish map_meat map_LNS map_SS , rows(4) cols(2) graphregion(color(white)) ring(0) position(4) /*lxoffset(-30)*/ imargin(0) xsize(3.3) ysize(3)
graph export "$workdir/graphs/worldmap_FGgaps.png", replace 


* SI Figure 2: EAT-Lancet
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


*** Gaps adjusted for future production (not included in manuscript or SI material) ***
*Livewell Diet
graph set window fontface "Times New Roman"

spmap prodgap_perc_cap_SS using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Starchy staples production gap (in perc)") clmethod(custom) clbreaks(-650 20 40 60 80 100 1005)  name(map_SS, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Starchy Staples", size(medsmall))
graph export "$workdir/graphs/gap_cap_SS.png", replace

spmap prodgap_perc_cap_dairy using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Starchy staples production gap (in perc)") clmethod(custom) clbreaks(-18 20 40 60 80 100 6500)  name(map_dairy, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Dairy", size(medsmall))
graph export "$workdir/graphs/gap_cap_dairy.png", replace

spmap prodgap_perc_cap_fish using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Fish production gap (in perc)") clmethod(custom) clbreaks(-1200 20 40 60 80 100 12000)  name(map_fish, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Fish", size(medsmall))
graph export "$workdir/graphs/gap_cap_fish.png", replace

spmap prodgap_perc_cap_meat using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Meat production gap (in perc)") clmethod(custom) clbreaks(0 20 40 60 80 100 1700)  name(map_meat, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Meat", size(medsmall))
graph export "$workdir/graphs/gap_cap_meat.png", replace

spmap prodgap_perc_cap_LNS using _worldmap_shp, id(_ID) fcolor(red*1.5 red*1.2 red*0.9 red*0.6 red*0.3 midblue*0.3) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Legumes, nuts, and seeds" "production gap (in perc)") clmethod(custom) clbreaks(-800 20 40 60 80 100 22000)  name(map_LNS, replace) legend(order(1 "No data" 2 "0   - <20%" 3 "20 - <40%" 4 "40 - <60%" 5 "60 - <80%" 6 "80 - <100%" 7 "Sufficient production (≥100%)") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Legumes, nuts, and seeds", size(medsmall))
graph export "$workdir/graphs/gap_cap_LNS.png", replace

spmap productdeprv_cap using _worldmap_shp, id(_ID) fcolor(red*1.9 red*1.6 red*1.3 red*1 red*0.7 red*0.4 red*0.1) osize(vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Number of food groups self-sufficient at") clmethod(custom) clbreaks(0 1 2 3 4 5 6 7)  name(map_depr, replace) legend(order(1 "No data" 2 "0" 3 "1" 4 "2" 5 "3" 6 "4" 7 "5" 8 "6") size(vsmall) symxsize(2) symysize(2) position(8)) graphregion(color(white)) title("Self-sufficiency", size(small))
graph export "$workdir/graphs/productdpr_cap_map.png", replace

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


* SI Figure 4: Livewell Diet
graph set window fontface "Times New Roman"

// Starchy staples
spmap prodgap_change_SS using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Starchy staples production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_SS, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(large) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Starchy Staples", size(medsmall))

fre prodgap_change_SS
bysort REGION_WB: fre prodgap_change_SS
sum prodgap_cap_change_SS if prodgap_perc_SS < 100
bysort REGION_WB: sum prodgap_cap_change_SS if prodgap_perc_SS < 100


// Dairy
spmap prodgap_change_dairy using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Dairy production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_dairy, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(large) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Dairy", size(medsmall))

fre prodgap_change_dairy
bysort REGION_WB: fre prodgap_change_dairy
sum prodgap_perc_dairy if prodgap_perc_dairy < 100
sum prodgap_cap_change_dairy if prodgap_perc_dairy < 100
bysort REGION_WB: sum prodgap_cap_change_dairy if prodgap_perc_dairy < 100


// Fish
spmap prodgap_change_fish using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Fish production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_fish, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Fish", size(medsmall))

fre prodgap_change_fish
bysort REGION_WB: fre prodgap_change_fish
sum prodgap_cap_change_fish if prodgap_perc_fish < 100
bysort REGION_WB: sum prodgap_cap_change_fish if prodgap_perc_fish < 100


// Meat
spmap prodgap_change_meat using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Meat production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_meat, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Meat", size(medsmall))

fre prodgap_change_meat
bysort REGION_WB: fre prodgap_change_meat
sum prodgap_cap_change_meat if prodgap_perc_meat < 100
bysort REGION_WB: sum prodgap_cap_change_meat if prodgap_perc_meat < 100


// LNS
spmap prodgap_change_LNS using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Legumes, nuts, and seeds production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_LNS, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Legumes, nuts, and seeds", size(medsmall))

fre prodgap_change_LNS
bysort REGION_WB: fre prodgap_change_LNS
sum prodgap_cap_change_LNS if prodgap_perc_LNS < 100
bysort REGION_WB: sum prodgap_cap_change_LNS if prodgap_perc_LNS < 100


//one large legend
graph set window fontface "Times New Roman"
grc1leg2 map_dairy map_fish map_meat map_LNS map_SS , rows(4) cols(2) graphregion(color(white)) ring(0) position(4) /*lxoffset(-30)*/ imargin(0) xsize(3) ysize(2)
graph export "$workdir/graphs/worldmap_FGgaps_capchange.png", replace 


*** Change in gaps with 2032 projections ***
cd "$datadir/shapefiles"
//spshape2dta WB_countries_Admin0_10m, replace saving(_worldmap)

use "$datadir/shapefiles/_worldmap.dta", clear
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


* SI Figure 6: Livewell Diet
graph set window fontface "Times New Roman"

// Starchy staples
spmap prodgap_change_SS using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Starchy staples production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_SS, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(large) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Starchy Staples", size(medsmall))

fre prodgap_change_SS
bysort REGION_WB: fre prodgap_change_SS
sum prodgap_change_SS2032 if SS_2020_SS == 0
bysort REGION_WB: sum prodgap_change_SS2032 if SS_2020_SS == 0


// Dairy
spmap prodgap_change_dairy using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Dairy production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_dairy, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(large) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Dairy", size(medsmall))

fre prodgap_change_dairy
bysort REGION_WB: fre prodgap_change_dairy
sum prodgap_change_dairy2032 if SS_2020_dairy == 0
bysort REGION_WB: sum prodgap_change_dairy2032 if SS_2020_dairy == 0


// Fish
spmap prodgap_change_fish using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Fish production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_fish, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Fish", size(medsmall))

fre prodgap_change_fish
bysort REGION_WB: fre prodgap_change_fish
sum prodgap_change_fish2032 if SS_2020_fish == 0
bysort REGION_WB: sum prodgap_change_fish2032 if SS_2020_fish == 0


// Meat
spmap prodgap_change_meat using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Meat production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_meat, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Meat", size(medsmall))

fre prodgap_change_meat
bysort REGION_WB: fre prodgap_change_meat
sum prodgap_change_meat2032 if SS_2020_meat == 0
bysort REGION_WB: sum prodgap_change_meat2032 if SS_2020_meat == 0


// LNS
spmap prodgap_change_LNS using _worldmap_shp, id(_ID) fcolor(red*0.5 sand*0.5 midgreen*0.5 midgreen*1 blue*0.6 midblue*0.3 cranberry) osize( vvthin vvthin vvthin vvthin vvthin vvthin vvthin) ndfcolor(gs12) ndsize(vvthin) legtitle("Legumes, nuts, and seeds production gap change (in percentage points)") clmethod(custom) clbreaks( -50 -.000001 .000001 20 100 200 300 400)  name(map_LNS, replace) legend(order(1 "No data" 2 "No self-sufficiency: Change of -50 - <0 p.p." 3 "No production" 4 "No self-sufficiency: Change of 0 - <20 p.p." 5 "No self-sufficiency: Change of >30 p.p." 6 "Achieved self-sufficiency (≥100%)" 7 "Maintained self-sufficiency (≥100%)" 8 "Lost self-sufficiency") size(medlarge) symxsize(4) symysize(4) position(8)) graphregion(color(white)) title("Legumes, nuts, and seeds", size(medsmall))

fre prodgap_change_LNS
bysort REGION_WB: fre prodgap_change_LNS
sum prodgap_change_LNS2032 if SS_2020_LNS == 0
bysort REGION_WB: sum prodgap_change_LNS2032 if SS_2020_LNS == 0


//one large legend
graph set window fontface "Times New Roman"
grc1leg2 map_dairy map_fish map_meat map_LNS map_SS , rows(4) cols(2) graphregion(color(white)) ring(0) position(4) /*lxoffset(-30)*/ imargin(0) xsize(3) ysize(2)
graph export "$workdir/graphs/worldmap_FGgaps_2032change.png", replace 


