**Project title:** Assessing self-sufficiency: analyzing the gap between national food production and food-based dietary guidance


**Project description:**
This project aims to assess national capacities to achieve dietary guidelines based on domestic food production. It explores past and futures trends of self-sufficiency and identifies countries where low self-sufficiency is couples with overdependence on few countries for imports.
The findings shed light on countries' reliance on food trade and their capabilities to respond to global shocks.


## 1. Introduction

Project team: Jonas Stehl, Alexander Vonderschmidt, Sebastian Vollmer, Peter Alexander, and Lindsay M Jaacks.



## 2. Data sources

All data used in this project is publicly available:
  - FAOSTAT Food Balance Sheets: https://www.fao.org/faostat/en/#data/FBS
  - FAOSTAT Trade Data: https://www.fao.org/faostat/en/#data/TM
  - United Nations World Population Estimates: https://population.un.org/wpp/
  - World Wildlife Fund’s 2023 ‘Eating for Net Zero’ Technical Report: https://www.wwf.org.uk/sites/default/files/2023-05/Eating_For_Net_Zero_Technical_Report.pdf
  - OECD-FAO Agricultural Outlook Data: https://www.oecd-ilibrary.org/agriculture-and-food/data/oecd-agriculture-statistics/oecd-fao-agricultural-outlook-edition-2023_3f870a2b-en
  - Food waste at the household and edible portions: https://openknowledge.fao.org/server/api/core/bitstreams/10388b16-5f1a-45d0-b690-e89bb78d33bb/content


## 3. Installation and setup

Install the following STATA packages: wbopendata, spmap, kountry, grc1leg2

## 4. Usage

Run the STATA do.files in the following order:
1. 0.1_projections.do
2. 0.2_Production Gap_240826.do
3. 1.2_analysis.do
4. 2.1_timetrends_projections.do
5. 2.2_timetrends_processing.do
6. 2.3_timetrends_analysis.do
7. 3.1_trade.do
8. 4.1_maps.do

