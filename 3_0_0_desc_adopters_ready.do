

use ${path}\data\dads_bicrn_tic_full_sd.dta, replace
/* */
gen sect_act_10_label=""
replace sect_act_10_label="Manufacturing" if sect_act_10=="CDE"
replace sect_act_10_label="Construction" if sect_act_10=="F__"
replace sect_act_10_label="Online Retail" if sect_act_10=="G_1"
replace sect_act_10_label="Retail" if sect_act_10=="G_2"
replace sect_act_10_label="Wholesale Trade" if sect_act_10=="G_3"
replace sect_act_10_label="Transportation and storage" if sect_act_10=="H__"
replace sect_act_10_label="Accomodation" if sect_act_10=="I__"
replace sect_act_10_label="Information & Communication" if sect_act_10=="J_s"
replace sect_act_10_label="Professional, Scientific and Technical Activities" if sect_act_10=="M__"
replace sect_act_10_label="Admnistrative and Support Service Activities" if sect_act_10=="N_L"
gen sect_act_10_sorting=.
replace sect_act_10_sorting=1 if sect_act_10=="CDE"
replace sect_act_10_sorting=2 if sect_act_10=="F__"
replace sect_act_10_sorting=3 if sect_act_10=="G_1"
replace sect_act_10_sorting=4 if sect_act_10=="G_2"
replace sect_act_10_sorting=5 if sect_act_10=="G_3"
replace sect_act_10_sorting=6 if sect_act_10=="H__"
replace sect_act_10_sorting=7 if sect_act_10=="I__"
replace sect_act_10_sorting=8 if sect_act_10=="J_s"
replace sect_act_10_sorting=9 if sect_act_10=="M__"
replace sect_act_10_sorting=10 if sect_act_10=="N_L"
/* */
foreach var in etp {
foreach i in 1 2 3 21 22 23 31 33 34 35 37 38 42 43 44 45 46 47 48 52 53 54 55 56 62 63 64 65 67 68 69 {
	gen `var'`i'_sh=`var'`i'/`var'
}
foreach i in 2 3 4 5 6 {
	gen `var'_1d_`i'_sh=`var'_1d_`i'/`var'
}
}
/* */
gen export_sh=caexport/catotal
gen cap_int_etp=immo_corp_raw/etp*10^(-3)
gen cap_int_vaht=immo_corp_raw/vaht
replace catotal=catotal*10^(-3)
replace lp=lp*10^(-3)
replace sales_etp=sales_etp*10^(-3)
gen age=year-year_crea
/* */
gen fw${year_ref_ia}=round(poids_cal${year_ref_ia},1)
gen fw${year_adopt_ia}=round(poids_cal${year_adopt_ia},1)
/* */
save ${path}\data\dads_bicrn_tic_full_sd_final.dta, replace
