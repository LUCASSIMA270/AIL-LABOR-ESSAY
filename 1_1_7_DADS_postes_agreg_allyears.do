

forvalues year=2014(1)2022{	
/******************************************************************************/
/* 1 - Passage des bases individuelles en lowercase des noms de variables  */
/******************************************************************************/
use ${path}\data\dads\dads_postes_indiv_`year'.dta, replace
	rename *, lower
save ${path}\data\dads\dads_postes_indiv_`year'.dta, replace

/******************************************************************************/
/* 2 - Agrégation au niveau SIREN  */
/******************************************************************************/
/* 2.A - Agrégation siren*sexe */
use ${path}\data\dads\dads_postes_indiv_`year'.dta, replace
gen siren=substr(siret,1,9)
collapse (sum) etp s_brut crea dest cont (mean) salh, by(siren year sexe)
gen gender="h" if sexe=="1"
replace gender="f" if sexe=="2"
drop sexe
rename gender sexe
save ${path}\data\dads\dads_postes_siren_sexe_`year'.dta, replace
/* 2.B - Agrégation siren*CS2 */
use ${path}\data\dads\dads_postes_indiv_`year'.dta, replace
gen siren=substr(siret,1,9)
collapse (sum) etp s_brut crea dest cont (mean) salh, by(siren year cs2)
save ${path}\data\dads\dads_postes_siren_cs2_`year'.dta, replace
/* 2.C - Agrégation siren */
use ${path}\data\dads\dads_postes_indiv_`year'.dta, replace
gen siren=substr(siret,1,9)
collapse (sum) etp s_brut crea dest cont (mean) salh, by(siren year)
save ${path}\data\dads\dads_postes_siren_`year'.dta, replace
/* 2.D - Agrégation siren*level_3 */
use ${path}\data\dads\dads_postes_siren_cs2_`year'.dta, replace
merge m:1 cs2 using ${path}\data\source\occupation_level_2digit.dta
collapse (sum) etp s_brut crea dest cont (mean) salh, by(siren year level_3)
drop if level_3==.
reshape wide etp s_brut crea dest cont salh, i(siren year) j(level_3)
recode etp* s_brut* crea* dest* cont* salh* (missing=0)
save ${path}\data\dads\dads_postes_siren_3l_`year'_wide.dta, replace
/* 2.E - Reshape siren*CS2 */
use ${path}\data\dads\dads_postes_siren_cs2_`year'.dta, replace
drop if cs2==""
reshape wide etp s_brut crea dest cont salh, i(siren year) j(cs2) string
recode etp* s_brut* crea* dest* cont* salh* (missing=0)
save ${path}\data\dads\dads_postes_siren_cs2_`year'_wide.dta, replace
/* 2.F - Reshape siren*sexe */
use ${path}\data\dads\dads_postes_siren_sexe_`year'.dta, replace
drop if sexe==""
reshape wide etp s_brut crea dest cont salh, i(siren year) j(sexe) string
recode etp* s_brut* crea* dest* cont* salh* (missing=0)
save ${path}\data\dads\dads_postes_siren_sexe_`year'_wide.dta, replace
/* 2.G - Reshape siren*AIexposure*/
use ${path}\data\dads\dads_postes_indiv_`year'.dta, replace
gen siren=substr(siret,1,9)
merge m:1 pcs using ${path}\data\other\exposure_ai_readyuse.dta
keep if _merge==3
drop _merge
drop if type==.
preserve
collapse (sum) etp s_brut crea dest cont (mean) salh, by(siren year type)
reshape wide etp s_brut crea dest cont salh, i(siren year) j(type)
recode etp* s_brut* crea* dest* cont* salh* (missing=0)
rename (etp* s_brut* crea* dest* cont* salh*) (etp_expai* s_brut_expai* crea_expai* dest_expai* cont_expai* salh_expai*)
save ${path}\data\dads\dads_postes_siren_expai_`year'_wide.dta, replace
restore
keep if super_exposed==1
collapse (sum) etp s_brut crea dest cont (mean) salh, by(siren year)
rename (etp s_brut crea dest cont salh) (etp_superexpai s_brut_superexpai crea_superexpai dest_superexpai cont_superexpai salh_superexpai)
save ${path}\data\dads\dads_postes_siren_superexpai_`year'_wide.dta, replace
/* 2.F - Merge des Reshape totaux */ 
use ${path}\data\dads\dads_postes_siren_`year'.dta, replace
merge 1:1 siren year using ${path}\data\dads\dads_postes_siren_sexe_`year'_wide.dta
drop _merge
merge 1:1 siren year using ${path}\data\dads\dads_postes_siren_cs2_`year'_wide.dta
drop _merge
merge 1:1 siren year using ${path}\data\dads\dads_postes_siren_3l_`year'_wide.dta
drop _merge
merge 1:1 siren year using ${path}\data\dads\dads_postes_siren_expai_`year'_wide.dta
drop _merge
merge 1:1 siren year using ${path}\data\dads\dads_postes_siren_superexpai_`year'_wide.dta
drop _merge
drop if siren==""
save ${path}\data\dads\dads_siren_`year'.dta, replace
/* 2.H - Erase base de données intermédiaires */
erase ${path}\data\dads\dads_postes_siren_sexe_`year'.dta
erase ${path}\data\dads\dads_postes_siren_cs2_`year'.dta
erase ${path}\data\dads\dads_postes_siren_`year'.dta
erase ${path}\data\dads\dads_postes_siren_3l_`year'_wide.dta
erase ${path}\data\dads\dads_postes_siren_cs2_`year'_wide.dta
erase ${path}\data\dads\dads_postes_siren_sexe_`year'_wide.dta	
erase ${path}\data\dads\dads_postes_siren_expai_`year'_wide.dta
erase ${path}\data\dads\dads_postes_siren_superexpai_`year'_wide.dta
}



