
/******************************************************************************/
/* 1 - Erase DADS */
/******************************************************************************/
cd ${path}\data\dads
forvalues year=$year_first_dads (1) $year_last_dads {
set more off
erase dads_siren_`year'.zip
erase dads_postes_indiv_`year'.zip
erase dads_tic_`year'.dta
}

/******************************************************************************/
/* 2 - Erase BIC-RN */
/******************************************************************************/
cd ${path}\data\bicrn
erase bicrn_allyears_fi.dta
erase bicrn_allyears_clean.dta
erase bicrn_tic.dta

/******************************************************************************/
/* 3 - Erase ICT survey */
/******************************************************************************/
cd ${path}\data\tic
forvalues year=2014(1)2021{
set more off
erase tic`year'.dta
}
erase tic2016_red.dta
erase tic2018_red.dta
erase tic2019_red.dta
erase tic2020_red.dta
erase tic2021_red.dta
erase tic_red_allyears.dta

/******************************************************************************/
/* 4 - Erase other files */
/******************************************************************************/
cd ${path}\data\other
erase exposure_ai_readyuse.dta
cd ${path}\data
erase dads_bicrn_tic_full_sd.dta
erase dads_bicrn_tic_full_sd_final.dta
erase dads_bicrn_tic_readyreg.dta