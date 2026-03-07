
/******************************************************************************/
/* 1 - Zipper les files DADS (Siret, Siren) */
/******************************************************************************/

/* 1a - DADS Postes Indiv - dads_postes_indiv_xxxx.dta */
/* 2014-2022 */
cd ${path}\data\dads
forvalues year=2014(1)2022{
set more off
zipfile dads_postes_indiv_`year'.dta, saving(dads_postes_indiv_`year', replace)
erase dads_postes_indiv_`year'.dta
}

/* 1c - DADS Siren - dads_siren_xxxx.dta */
/* 2014-2022 */
cd ${path}\data\dads
forvalues year=2014(1)2022{
set more off
zipfile dads_siren_`year'.dta, saving(dads_siren_`year', replace)
erase dads_siren_`year'.dta
}
