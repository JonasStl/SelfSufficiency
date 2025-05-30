**Project title:** Gap between national food production and food-based dietary guidance highlights lack of national self-sufficiency

Published in Nature Food: https://www.nature.com/articles/s43016-025-01173-4 (DOI: 10.1038/s43016-025-01173-4)

**Project description:**
This project aims to assess national capacities to achieve dietary guidelines based on domestic food production. It explores past and futures trends of self-sufficiency and identifies countries where low self-sufficiency is couples with overdependence on few countries for imports.
The findings shed light on countries' reliance on food trade and their capabilities to respond to global shocks.


## 1. Introduction

Project team: Jonas Stehl, Alexander Vonderschmidt, Sebastian Vollmer, Peter Alexander, and Lindsay M Jaacks.



## 2. Data sources

All data used in this project is publicly available or provided in this repository:

Public datasets:
  - FAOSTAT Food Balance Sheets (accessed on 24.07.2024): https://www.fao.org/faostat/en/#data/FBS
  - FAOSTAT Trade Data (accessed on 18.06.2024): https://www.fao.org/faostat/en/#data/TM
  - United Nations World Population Estimates 2024 (accessed on 23.07.2024): https://population.un.org/wpp/
  - World Wildlife Fund’s 2023 ‘Eating for Net Zero’ Technical Report (accessed on 07.06.2024): https://www.wwf.org.uk/sites/default/files/2023-05/Eating_For_Net_Zero_Technical_Report.pdf
  - OECD-FAO Agricultural Outlook 2023-2032 Data (accessed on 01.07.2024): https://www.oecd-ilibrary.org/agriculture-and-food/data/oecd-agriculture-statistics/oecd-fao-agricultural-outlook-edition-2023_3f870a2b-en
  - Food waste at the household and edible portions (04.07.2023): https://openknowledge.fao.org/server/api/core/bitstreams/10388b16-5f1a-45d0-b690-e89bb78d33bb/content

Other data available in "SelfSufficiency/data":
  - Food group recommendations: foodgroups_wwf.xlsx
  - Agricultural Outlook FAO FBS matching data: Outlook_FAOFBS matching.xls
  - Conversion factors from Gustavsson: conversionfactors.dta
  - Shapefiles: _worldmap.dta

## 3. Installation and setup

Install the following STATA packages: wbopendata, spmap, kountry, grc1leg2

## 4. Usage
Change the file paths accordingly.

Run the STATA do.files in the following order:
1. 0.1_projections.do

   Uses:
   - Agricultural Outlook Database: HIGH_AGLINK_2023-2023-1-EN-20240109T100123.csv

3. 0.2_processing.do

   Uses:
   - Food group recommendations: foodgroups_wwf.xlsx
   - Population data: WPP2024_POP_F01_1_POPULATION_SINGLE_AGE_BOTH_SEXES.xlsx
   - Agricultural Outlook FAO FBS matching data: Outlook_FAOFBS matching.xls
   - FAO Food Balance Sheets: FoodBalanceSheets_E_All_Data_(Normalized)/FoodBalanceSheets_E_All_Data_(Normalized).csv
   - Conversion factors: conversionfactors.dta

4. 1.2_analysis.do

5. 2.1_timetrends_projections.do

   Uses:
   - Agricultural Outlook Database: HIGH_AGLINK_2023-2023-1-EN-20240109T100123.csv

6. 2.2_timetrends_processing.do

   Uses:
   - Food group recommendations: foodgroups_wwf.xlsx
   - Population data: WPP2024_POP_F01_1_POPULATION_SINGLE_AGE_BOTH_SEXES.xlsx
   - FAO Food Balance Sheets: FoodBalanceSheets_E_All_Data_(Normalized)/FoodBalanceSheets_E_All_Data_(Normalized).csv
   - Conversion factors: conversionfactors.dta

7. 2.3_timetrends_analysis.do

8. 3.1_trade.do

   Uses:
   - FAO Trade Data: Trade_DetailedTradeMatrix_E_All_Data_(Normalized).csv

10. 4.1_maps.do

  Uses:
   - Shapefiles: _worldmap.dta

## 5. Contact
For any questions or concerns, please contact Jonas Stehl (jonas.stehl@uni-goettingen.de)
