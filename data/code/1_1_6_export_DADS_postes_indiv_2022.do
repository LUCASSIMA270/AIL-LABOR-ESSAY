
/******************************************************************************/
/* 1 - Append des composantes des DADS 2022 - Année n */
/******************************************************************************/
/* 2022 - Année n */
use ${path}\data\dads\post_2022_1_0.dta, replace
cd ${path}\data\dads
foreach post_db in post_2022_2_0 post_2022_3_0 post_2022_4_0 post_2022_5_0 post_2022_6_0 post_2022_7_0 post_2022_8_0 post_2022_9_AZ_0 post_2022_9_BE_0 post_2022_9_FZ_0 post_2022_9_GI_0 post_2022_9_JU_0 post_2022_9_OQ_0 post_2022_NA_0 {
	append using "`post_db'"
}
save ${path}\data\dads\dads_postes_2022_n.dta, replace

/******************************************************************************/
/* 2 - Append des composantes des DADS 2022 - Année n-1 */
/******************************************************************************/
use ${path}\data\dads\post_2021_1_0.dta, replace
cd ${path}\data\dads
foreach post_db in post_2021_2_0 post_2021_3_0 post_2021_4_0 post_2021_5_0 post_2021_6_0 post_2021_7_0 post_2021_8_0 post_2021_9_AZ_0 post_2021_9_BE_0 post_2021_9_FZ_0 post_2021_9_GI_0 post_2021_9_JU_0 post_2021_9_OQ_0 post_2021_NA_0 {
	append using "`post_db'"
}
rename (apet pcs filt duree comt domempl regt eqtp nbheur) (apet_1 pcs_1 filt_1 duree_1 comt_1 domempl_1 regt_1 eqtp_1 nbheur_1)
keep ident_s siren siret *_1
save ${path}\data\dads\dads_postes_2022_n_1.dta, replace

/******************************************************************************/
/* 3 - Merge n/n-1 & Cleaning  */
/******************************************************************************/
use ${path}\data\dads\dads_postes_2022_n.dta, replace
merge 1:1 ident_s siret using ${path}\data\dads\dads_postes_2022_n_1
/* */
gen etp=min(nbheur/1820,1)
gen etp_1=min(nbheur_1/1820,1)
corr eqtp etp
corr eqtp_1 etp_1
drop eqtp eqtp_1
/* */
keep if (filt=="1" & filt_1=="1") | (filt=="1" & filt_1=="") | (filt=="" & filt_1=="1")
keep if (domempl!="1" &  domempl!="2" &  domempl!="3" &  domempl!="7") & (domempl_1!="1" &  domempl_1!="2" &  domempl_1!="3" &  domempl_1!="7")
/* */
gen age=2022-annee_naiss
gen cs=substr(pcs,1,2)
gen cs_1=substr(pcs_1,1,2)
drop if cs=="" | cs=="00"
/* */
gen r_nbheur_duree=nbheur/duree
gen salh=s_brut/nbheur if (nbheur>0 /* Non nul */ & filt=="1" /* Non annexe en N */ & (duree>30 & nbheur>120 & r_nbheur_duree>1.5) /* Non annexe en N sur critère d'heures */)
/* */
gen crea=etp if (filt=="1" & filt_1=="")
gen dest=etp_1 if (filt=="" & filt_1=="1")
gen cont=etp if (filt=="1" & filt_1=="1")
recode crea dest cont (.=0)
/* */
gen ind_3112_na=1 if (duree==360 | datfin==360) & filt=="1"
recode ind_3112_na (.=0)
/* */
rename (cs cs_1) (cs2 cs2_1)
/* */
keep siret apet comt pcs pcs_1 cs2 cs2_1 sexe age s_brut etp nbheur crea dest cont salh	
/* */
save ${path}\data\dads\t_2022.dta, replace

/******************************************************************************/
/* 4 - Base des APET/COMT au niveau SIRET  */
/******************************************************************************/
use ${path}\data\dads\t_2022.dta, replace
/* */
drop if dest>0
drop if apet==""
drop if comt==""
/* */
keep siret apet comt
/* */
duplicates drop siret, force
/* */
sort siret
/* */
save siret_unif_2022, replace

/******************************************************************************/
/* 5 - Unification des APET/COMT au niveau SIRET et finalisation  */
/******************************************************************************/
use ${path}\data\dads\t_2022.dta, replace
/* */
gen year=2022
drop apet comt
/* */
merge m:1 siret using siret_unif_2022
drop _merge
/* */
duplicates drop siret apet comt cs2 sexe age s_brut etp nbheur crea dest cont salh, force
order siret apet comt cs2 sexe age s_brut etp nbheur crea dest cont salh
sort siret apet comt cs2 sexe age s_brut etp nbheur crea dest cont salh
/* */
save ${path}\data\dads\dads_postes_indiv_2022.dta, replace

/******************************************************************************/
/* 6 - Erase base de données intermédiaires  */
/******************************************************************************/
forvalues year=2021(1)2022{
	forvalues db=1(1)8{
	erase ${path}\data\dads\post_`year'_`db'_0.dta 	
	}
	foreach db in AZ BE FZ GI JU OQ {
	erase ${path}\data\dads\post_`year'_9_`db'_0.dta 	
	}
	erase ${path}\data\dads\post_`year'_NA_0.dta 
}
erase ${path}\data\dads\dads_postes_2022_n.dta
erase ${path}\data\dads\dads_postes_2022_n_1.dta
erase ${path}\data\dads\t_2022.dta
erase ${path}\data\dads\siret_unif_2022.dta
