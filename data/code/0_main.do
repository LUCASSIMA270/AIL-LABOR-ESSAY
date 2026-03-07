/******************************************************************************/
/* Replication package for AEA Papers and Proceedings article */
/* How Different Uses of AI Shape Labor Demand: Evidence from France */
/* Main file */
/* Author: Simon Bunel - Banque de France - January 2025 */
/******************************************************************************/
clear all
set max_memory 100g
set matsize 11000
set maxvar 11000
set rmsg on, perm
global path "C:\Users\Public\Documents\replication_abjmrs_aeapp"
cd ${path}\code

/******************************************************************************/
/* 0 - Install Packages  */
/******************************************************************************/
//ssc install reghdfe
//ssc install saswrapper
//ssc install rscript
//ssc install mylabels

/******************************************************************************/
/* 1.0.0 - Define quarters of AI exposure using data from Bergeaud (2024) */
/******************************************************************************/
global exposure_phigh 90
global safe_tasks_sh_plow 25
run 1_0_0_import_exposure_ai.do

/******************************************************************************/
/* 1.1 - Import matched employer-employee data (DADS) */
/******************************************************************************/
saswrapper using "1_1_0_export_DADS_postes_indiv_2014_2015.sas" 
saswrapper using "1_1_1_export_DADS_postes_indiv_2016_2017.sas" 
saswrapper using "1_1_2_export_DADS_postes_indiv_2018_2019.sas" 
saswrapper using "1_1_3_export_DADS_postes_indiv_2020.sas" 
saswrapper using "1_1_4_export_DADS_postes_indiv_2021.sas" 
rscript using 1_1_5_import_DADS_post_indiv_parquet_2022.R, rpath("C:\Program Files\R\R-4.3.1\bin\Rscript.exe")
run 1_1_6_export_DADS_postes_indiv_2022.do
cd ${path}\code
run 1_1_7_DADS_postes_agreg_allyears.do
run 1_1_8_DADS_zipfiles.do

/******************************************************************************/
/* 1.2 - Import balance sheet data (BIC-RN) */
/******************************************************************************/
cd ${path}\code
saswrapper using "1_2_0_export_bic_all.sas" 
run 1_2_1_clean_bic_all.do

/******************************************************************************/
/* 1.3 - Import ICT survey */
/******************************************************************************/
global path_src "\\casd.fr\casdfs\Projets\AUTOTRA\Data"
run 1_3_0_import_ict_survey.do
run 1_3_1_clean_ict_survey.do

/******************************************************************************/
/* 2 - Merge TIC & DADS & BIC-RN */
/******************************************************************************/
global year_first_dads 2014
global year_last_dads 2022
/* */
global cleaning_plow 1
global cleaning_phigh 99
/* */
run 2_merge_dads_bicrn_ict.do

/******************************************************************************/
/* 3 - Descriptive statistics */
/******************************************************************************/
global year_ref_cloud 2018
global year_adopt_cloud 2021
/* */
global year_ref_ia 2019
global year_adopt_ia 2021
/* */
global industry_level_sd sect_act_10 /* sect_act_8 sect_act_9 sect_act_10 ape_gr ape_2d_gr */
/* */
cd ${path}\code
run 3_0_0_desc_adopters_ready.do
/* Table 1 - Characteristics of Firms Adopting AI */
global table_fmt txt
cd ${path}\code
run 3_0_1_desc_adopters_characteristics.do
/* Figure 1 - AI adoption across sectors */
cd ${path}\code
run 3_0_2_desc_adopters_sector_share.do
graph export ${path}\results\figure1.pdf, replace
graph export ${path}\results\figure1.eps, replace

/******************************************************************************/
/* 4 - Diff-in-Diff */
/******************************************************************************/
global year_first 2014
global year_last 2022
global year_base 2017
/* */
global weight sqrt_etp${year_first} /* 1 / sqrt_etp${year_first} */
global industry_level_fe sect_act_10 /* sect_act_8 sect_act_9 sect_act_10 ape_gr ape_2d_gr */
/* */
global cloud_us_nb_min 1
global cloud_us_nb_max 7
global ia_us_nb_min 1
global ia_us_nb_max 7
/* */
global ia_us admin
global cloud_us courriel

/* Figure 2 - The response of firm employment and sales to AI */
global yscmin -0.3
global yscdelta 0.05
global yscmax 0.3
global var_reg1 log_etp
global var_reg2 log_sales
cd ${path}\code
global treated_var adopt_ia_${year_ref_ia}_${year_adopt_ia}
run 4_0_0_did_ai_reg_2var.do
graph export ${path}\results\figure2.pdf, replace
graph export ${path}\results\figure2.eps, replace

/* Figure 3 - The response of firm employment to AI adoption, occupations with high exposure and high substituability */
global var_reg log_etp_expai4
cd ${path}\code
global treated_var adopt_ia_${year_ref_ia}_${year_adopt_ia}
run 4_0_1_did_ai_reg_1var.do
graph export ${path}\results\figure3.pdf, replace
graph export ${path}\results\figure3.eps, replace

/* Figure 4 - The response of firm employment to AI adoption for ICT security and administrative processes */
global var_reg log_etp_expai4
cd ${path}\code
global ia_us secu
global treated_var1 adopt_ia_${year_ref_ia}_${year_adopt_ia}_${ia_us}
global ia_us admin
global treated_var2 adopt_ia_${year_ref_ia}_${year_adopt_ia}_${ia_us}
run 4_0_2_did_ai_reg_uses.do
graph export ${path}\results\figure4.pdf, replace
graph export ${path}\results\figure4.eps, replace

/******************************************************************************/
/* 5 - Erase remaining files */
/******************************************************************************/
cd ${path}\code
run 5_clean.do




