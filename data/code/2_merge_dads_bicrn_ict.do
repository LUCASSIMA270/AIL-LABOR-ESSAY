
/******************************************************************************/
/* 1 - Merge TIC & DADS */
/******************************************************************************/
global year_first_dads_plus1 = ${year_first_dads}+1
/* */
cd ${path}\data\dads
forvalues year=$year_first_dads (1) $year_last_dads {
unzipfile ${path}\data\dads\dads_siren_`year', replace
use ${path}\data\dads\dads_siren_`year'.dta, replace
erase ${path}\data\dads\dads_siren_`year'.dta
merge m:1 siren using ${path}\data\tic\tic_red_allyears.dta
keep if _merge==3
drop _merge
save ${path}\data\dads\dads_tic_`year'.dta, replace
}

/******************************************************************************/
/* 2 - Merge TIC & BIC-RN */
/******************************************************************************/
use ${path}\data\bicrn\bicrn_allyears_clean.dta, replace
keep if year>=${year_first_dads}
merge m:1 siren using ${path}\data\tic\tic_red_allyears.dta
keep if _merge==3
drop _merge
save ${path}\data\bicrn\bicrn_tic.dta, replace

/******************************************************************************/
/* 3 - Merge TIC & DADS & BIC-RN */
/******************************************************************************/
use ${path}\data\dads\dads_tic_${year_first_dads}.dta, replace
forvalues year=$year_first_dads_plus1 (1) $year_last_dads {
append using ${path}\data\dads\dads_tic_`year'.dta
}
/* */
merge 1:1 siren year using ${path}\data\bicrn\bicrn_tic.dta
drop _merge
/* */
gen lp=vaht/etp
gen log_lp=log(lp)
gen sales_etp=catotal/etp
gen log_sales_etp=log(sales_etp)
gen ls=wagebill/vaht
gen log_ls=log(ls)
gen log_vaht=log(vaht)
gen log_sales=log(catotal)
gen log_profit=log(ebe)
gen log_inv_corp_it=log(inv_corp_it)
gen log_caexport=log(caexport)
/* */
foreach var in etp crea lp sales_etp ebe {
	su `var', d
	_pctile `var', p(${cleaning_plow})	
	gen `var'_plow=`r(r1)'
	_pctile `var', p(${cleaning_phigh})	
	gen `var'_phigh=`r(r1)'     	
}

/* */
keep if inrange(etp,etp_plow,etp_phigh) | etp==.
keep if inrange(lp,lp_plow,lp_phigh) | lp==.
keep if inrange(sales_etp,sales_etp_plow,sales_etp_phigh) | etp==.
/* */
order siren year sect_act_10 ia2019 ia2021
sort siren year
/* */
gen cd=(crea+dest)/2
foreach i in 1 2 3 21 22 23 31 33 34 35 37 38 42 43 44 45 46 47 48 52 53 54 55 56 62 63 64 65 67 68 69 h f _expai1 _expai2 _expai3 _expai4 _superexpai {
	gen cd`i'=(crea`i'+dest`i')/2
}
/* */
foreach var in etp crea dest cont salh cd {
	gen log_`var'=log(`var')
foreach i in 1 2 3 21 22 23 31 33 34 35 37 38 42 43 44 45 46 47 48 52 53 54 55 56 62 63 64 65 67 68 69 {
	gen log_`var'`i'=log(`var'`i')
}
foreach i in h f {
	gen log_`var'`i'=log(`var'`i')
}
foreach i in 1 2 3 4 {
	gen log_`var'_expai`i'=log(`var'_expai`i')
	gen `var'_expai`i'_sh=`var'_expai`i'/`var'
}
	gen log_`var'_expai1_2=log(`var'_expai1+`var'_expai2)
	gen `var'_expai1_2_sh=(`var'_expai1+`var'_expai2)/`var'
	gen log_`var'_expai3_4=log(`var'_expai3+`var'_expai4)
	gen log_`var'_superexpai=log(`var'_superexpai)
}
/* */
foreach var in etp crea dest cont cd {
gen `var'_1d_2=`var'21+`var'22+`var'23
gen `var'_1d_3=`var'31+`var'33+`var'34+`var'35+`var'37+`var'38
gen `var'_1d_4=`var'42+`var'43+`var'44+`var'45+`var'46+`var'47+`var'48
gen `var'_1d_5=`var'52+`var'53+`var'54+`var'55+`var'56
gen `var'_1d_6=`var'62+`var'63+`var'64+`var'65+`var'67+`var'68+`var'69
}
foreach var in etp crea dest cont cd {
foreach i in 2 3 4 5 6 {
gen log_`var'_1d_`i'=log(`var'_1d_`i')
}
}
/* */
foreach var in etp crea dest cont cd {
gen log_`var'38_47=log(`var'38 + `var'47)
gen log_`var'63_65_67=log(`var'63+`var'65+`var'67)
gen log_`var'65_67_68=log(`var'65+`var'67+`var'68)
gen log_`var'62_63=log(`var'62+`var'63)
gen log_`var'47_48=log(`var'47+`var'48)
gen log_`var'48_62_63=log(`var'48+`var'62+`var'63)
gen log_`var'38_47_48=log(`var'38+`var'47+`var'48)
}
/* */
gen ape_2d=substr(ape,1,2)
/* */
egen ape_gr=group(ape)
egen ape_2d_gr=group(ape_2d)
/* */
save ${path}\data\dads_bicrn_tic_full_sd.dta, replace
use ${path}\data\dads_bicrn_tic_full_sd.dta, replace
/* */
gen obs=1
bys siren : egen nb_obs=sum(obs)
tab nb_obs
egen nb_obs_max=max(nb_obs)
keep if nb_obs==nb_obs_max
tab year
drop obs nb_obs nb_obs_max
/* */
save ${path}\data\dads_bicrn_tic_readyreg.dta, replace

tabstat etp_expai4_sh etp_expai3_sh etp_expai1_2_sh









