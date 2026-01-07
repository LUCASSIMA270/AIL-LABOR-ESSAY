
/******************************************************************************/
/* 1 - Homogénéisation code NAF + Deflate BICRN */
/******************************************************************************/
use ${path}\data\bicrn\bicrn_allyears_fi.dta, replace
/* */
rename *, lower
order siren year
sort siren year
/* 0 - Correction code APE */
rename nafbicrn ape
gen strlen_ape = strlen(ape)
set more off
tab year strlen_ape 
gen naf1=ape if strlen_ape==4
merge m:1 naf1 using ${path}\data\source\passage_naf1_naf2_maj.dta
replace naf2 = ape if strlen_ape==5 /* APE déjà à 5 chiffres */
drop strlen_ape
bys siren naf2 : egen nb_year_naf2 = count(year)
/* pour les quelques cas où l'on n'a pas de correspondance naf1 naf2 à la base */
gen strlen_naf2=strlen(naf2)
tab strlen_naf2
replace nb_year_naf2=0 if strlen_naf2==4 /* Dans ce cas, on préfère garder le naf2 le plus fréquent */
replace nb_year_naf2=0 if naf2=="" /* pour ne pas conserver les missing majoritaires */
drop strlen_naf2
bys siren : egen max_nb_year_naf2 = max(nb_year_naf2)
bys siren : egen max_nb_year_naf2_year = max(year) if max_nb_year_naf2==nb_year_naf2
order year ape naf1 naf2 nb_year_naf2 max_nb_year_naf2 max_nb_year_naf2_year
/* Condition ci-dessous : on veut (1) la plus grande fréquence de code APE */
/* et (2) si il y a égalité, le maximum de codes APE le plus récent */
gen naf2_maj_siren = naf2 if nb_year_naf2==max_nb_year_naf2 & year==max_nb_year_naf2_year 
order year ape naf1 naf2 naf2_maj_siren nb_year_naf2 max_nb_year_naf2 max_nb_year_naf2_year
gsort siren -naf2_maj_siren
bys siren : replace naf2_maj_siren=naf2_maj_siren[1]
sort siren year
drop ape naf1 naf2 nb_year_naf2 max_nb_year_naf2 max_nb_year_naf2_year _merge
rename naf2_maj_siren ape
order siren year ape
gen strlen_ape = strlen(ape)
tab strlen_ape
drop if strlen_ape==0
drop strlen_ape
rename ape nafbicrn
/* */
foreach var in "datcrea" {
bys siren : egen `var'_mode=mode(`var'), maxmode
drop `var'
rename `var'_mode `var'
}
gen year_crea=substr(datcrea,1,4)
destring year_crea, replace
/* 1 - Construction des variables */
gen amor_it = qc
gen immo_corp_raw_it = mk
gen immo_corp_net_it = mk - qc
gen inv_corp_it = ku
gen amor_ter = pl
gen immo_corp_raw_ter = ly
gen immo_corp_net_ter = ly - pl
gen inv_corp_ter = ki
gen amor_con = pq + pu + py
gen immo_corp_raw_con = mb + me + mh
gen immo_corp_net_con = (mb + me + mh) - (pq + pu + py)
gen inv_corp_con = kl + ko +kr
gen amor_aut = qg + qk + qo + qt
gen immo_corp_raw_aut = mn + mq + mt + mw
gen immo_corp_net_aut = (mn + mq + mt + mw) - (qg + qk + qo + qt)
gen inv_corp_aut = kx + la + ld + lg
gen immo_corp_raw_noit = immo_corp_raw_ter + immo_corp_raw_con + immo_corp_raw_aut
gen immo_corp_net_noit = immo_corp_net_ter + immo_corp_net_con + immo_corp_net_aut
gen immo_corp_raw = immo_corp_raw_it + immo_corp_raw_ter + immo_corp_raw_con + immo_corp_raw_aut
gen immo_corp_net = immo_corp_net_it + immo_corp_net_ter + immo_corp_net_con + immo_corp_net_aut
gen catotal = fl
gen caexport = fk
gen wagebill = fy+fz
gen test = (ml - ks) - ku + mj + qc
su test, d
drop test
/* Keep des variables */
global list_var siren year nafbicrn year_crea /*
*/ amor_it immo_corp_raw_it immo_corp_net_it inv_corp_it /*
*/ immo_corp_net_ter immo_corp_net_con immo_corp_net_aut immo_corp_net_noit immo_corp_net /*
*/ immo_corp_raw_ter immo_corp_raw_con immo_corp_raw_aut immo_corp_raw_noit immo_corp_raw /*
*/ catotal caexport vaht ebe wagebill
keep ${list_var}
/* Cleaning */
su immo_corp_net_it, d
keep if inrange(immo_corp_net_it,0,10^100) | immo_corp_net_it==.
su immo_corp_net_it, d
/* */
egen gr_siren=group(siren)
xtset gr_siren year
sort gr_siren year
/* */
save ${path}\data\bicrn\bicrn_allyears_clean.dta, replace
