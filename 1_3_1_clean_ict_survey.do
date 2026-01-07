
/* Cloud 
COURRIEL	Services achetés : courriel
LOGICIELS	Services achetés : logiciels de bureautique
COMPTA	Services achetés : logiciels de comptabilité
REL_CLIENT	Services achetés : gestion de la relation client
BASES	Services achetés : hébergement de base(s) de données de l'entreprise
STOCKAGE	Services achetés : stockage de fichiers
CALCUL	Services achetés : puissance de calcul pour faire fonctionner les logiciels de l'entreprised'applications
*/
global cloud_us_var_list cloud_us_courriel cloud_us_logiciels cloud_us_bases cloud_us_stockage cloud_us_compta cloud_us_rel_client cloud_us_calcul 
/*** 1 - IA : Technology ***/
/*
IA_TECH_TEXTMIN	Technologie d'analyse du langage écrit
IA_TECH_PAROLE	Technologie de reconnaissance automatique de la parole
IA_TECH_GAT	Technologie générant du langage parlé ou écrit
IA_TECH_IMAGES	Technologie identifiant des objets ou des personnes à partir d'images
IA_TECH_AAAD	Apprentissage automatique pour analyse de données
IA_TECH_DECIS	Technologie automatisant différentes taches
IA_TECH_MVT	Technologie permettant le mouvement physique de machines par décisions autonomes
*/
global ia_tech_var_list ia_tech_textmin ia_tech_parole ia_tech_gat ia_tech_images ia_tech_aaad ia_tech_decis ia_tech_mvt
/*** 2 - IA : Use ***/
/*
IA_US_MARKETING	marketing ou ventes
IA_US_PRODUCT processus de production
IA_US_ADMIN	processus d'administration des entreprises
IA_US_GESTION gestion des entreprises
IA_US_LOGISTIQ logistique
IA_US_SECU sécurité informatique
IA_US_GRH gestion des ressources humaines et le recrutement
*/
global ia_us_var_list ia_us_marketing ia_us_product ia_us_admin ia_us_gestion ia_us_logistiq ia_us_secu ia_us_grh
/*** 3 - IA : Acquisition ***/
/*
IA_AQ_DEVINTERN	Acquisition des logiciels d'IA par développement interne
IA_AQ_COMMODIF	Acquisition des logiciels d'IA par le commerce et modifiés en interne
IA_AQ_OSMODIF	Acquisition des logiciels d'IA par open source modifiés en internet
IA_AQ_COMPRETS	Acquisition des logiciels d'IA par achat de système prêts à l'emploi
IA_AQ_PRESTA	Acquisition des logiciels d'IA par contrats avec des sous-traitants
*/
global ia_aq_var_list ia_aq_devintern ia_aq_commodif ia_aq_osmodif ia_aq_comprets ia_aq_presta

/* 2016 - cloud */
use ${path}\data\tic\tic2016.dta, replace
rename apel ape
rename (d1_cloud d2a_courriel d2b_logiciels d2c_bases d2d_stockage d2e_compta d2f_rel_client d2g_calcul) (cloud cloud_us_courriel cloud_us_logiciels cloud_us_bases cloud_us_stockage cloud_us_compta cloud_us_rel_client cloud_us_calcul)
keep siren ape sect_act_* depcom poids_cal /*
Cloud */ cloud ${cloud_us_var_list}
destring cloud ${cloud_us_var_list}, replace
gen year=2016
save ${path}\data\tic\tic2016_red.dta, replace

/* 2018 - cloud */
use ${path}\data\tic\tic2018.dta, replace
rename apel ape
rename (courriel logiciels bases stockage compta rel_client calcul) (cloud_us_courriel cloud_us_logiciels cloud_us_bases cloud_us_stockage cloud_us_compta cloud_us_rel_client cloud_us_calcul)
keep siren ape sect_act_* depcom poids_cal /*
Cloud */ cloud ${cloud_us_var_list}
destring cloud ${cloud_us_var_list}, replace
gen year=2018
save ${path}\data\tic\tic2018_red.dta, replace

/* 2019 - IA red */
use ${path}\data\tic\tic2019.dta, replace
rename apel ape
destring ia_dev_empl ia_dev_presta ia_dev_fournisseur, replace
egen ia=rowmax(ia_dev_empl ia_dev_presta ia_dev_fournisseur)
order ia*
keep siren ape sect_act_* depcom poids_cal /*
IA */ ia
gen year=2019
save ${path}\data\tic\tic2019_red.dta, replace

/* 2020 - cloud*/
use ${path}\data\tic\tic2020.dta, replace
rename apel ape
rename (courriel logiciels bases stockage compta rel_client calcul) (cloud_us_courriel cloud_us_logiciels cloud_us_bases cloud_us_stockage cloud_us_compta cloud_us_rel_client cloud_us_calcul)
keep siren ape sect_act_* depcom poids_cal /*
Cloud */ cloud ${cloud_us_var_list}
destring cloud ${cloud_us_var_list}, replace
gen year=2020
save ${path}\data\tic\tic2020_red.dta, replace

/* 2021 - cloud & IA*/
use ${path}\data\tic\tic2021.dta, replace
rename apel ape
rename depcom2 depcom
rename (courriel logiciels bases stockage compta rel_client calcul) (cloud_us_courriel cloud_us_logiciels cloud_us_bases cloud_us_stockage cloud_us_compta cloud_us_rel_client cloud_us_calcul)
destring cloud ${cloud_us_var_list} ${ia_tech_var_list} ${ia_us_var_list}, replace
egen ia=rowmax(${ia_tech_var_list})
keep siren ape sect_act_* depcom poids_cal /*
Cloud */ cloud ${cloud_us_var_list} /*
IA */ ia ${ia_tech_var_list} ${ia_us_var_list} ${ia_aq_var_list}
gen year=2021
save ${path}\data\tic\tic2021_red.dta, replace

/* Append all years */
use ${path}\data\tic\tic2016_red.dta, replace
append using ${path}\data\tic\tic2018_red.dta
append using ${path}\data\tic\tic2019_red.dta
append using ${path}\data\tic\tic2020_red.dta
append using ${path}\data\tic\tic2021_red.dta
/* */
order siren year
sort siren year
/* */
foreach var in ape sect_act_10 sect_act_9 sect_act_8 depcom {
bys siren : egen `var'_mode=mode(`var'), maxmode
drop `var'
rename `var'_mode `var'
}
order siren ape sect_act_10 sect_act_9 sect_act_8 depcom
/* */
tab year if cloud!=.
tab year if cloud==.
drop if cloud==. & (year==2016 | year==2018 | year==2020 | year==2021)
/* */
tab year ia
tab year if ia!=.
tab year if ia==.
drop if ia==. & (year==2019 | year==2021)
/* */
egen cloud_us_nb=rowtotal(${cloud_us_var_list})
egen cloud_us_support=rowmax(cloud_us_courriel cloud_us_logiciels)
egen cloud_us_prod=rowmax(cloud_us_bases cloud_us_calcul)
gen cloud_us_noprod=(cloud_us_nb>0 & cloud_us_prod==0)
gen cloud_us_nosupp=(cloud_us_nb>0 & cloud_us_support==0)
egen ia_us_nb=rowtotal(${ia_us_var_list})
egen ia_us_support=rowmax(ia_us_admin ia_us_marketing)
gen ia_us_support_allus=(ia_us_admin==1 & ia_us_marketing==1)
egen ia_us_prod=rowmax(ia_us_product ia_us_secu)
gen ia_us_noprod=(ia_us_nb>0 & ia_us_prod==0)
gen ia_us_nosupp=(ia_us_nb>0 & ia_us_support==0)
/* */
reshape wide poids_cal cloud cloud_us_nb cloud_us_support cloud_us_prod cloud_us_nosupp cloud_us_noprod ${cloud_us_var_list} ia ia_us_nb ia_us_support ia_us_support_allus ia_us_prod ia_us_nosupp ia_us_noprod ${ia_tech_var_list} ${ia_us_var_list} ${ia_aq_var_list}, i(siren) j(year)
/* */
order siren ape sect_act_10 sect_act_9 sect_act_8 depcom
/* */
save ${path}\data\tic\tic_red_allyears.dta, replace
