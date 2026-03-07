

/******************************************************************************/
/* 0 - Import to Stata */
/******************************************************************************/
/* 2014-2016 */
forvalues year=14(1)16{
clear all
import sas using "${path_src}\TIC_TIC Entreprises_20`year'\tic`year'diff"
rename *, lower
/* */
gen siren_strlen=strlen(siren)
tab siren_strlen
replace siren="00"+siren if siren_strlen==7
replace siren="0"+siren if siren_strlen==8
drop siren_strlen
gen siren_strlen=strlen(siren)
tab siren_strlen
drop siren_strlen
/* */
save ${path}\data\tic\tic20`year'.dta, replace
}

/* 2017-2019 */
forvalues year=17(1)19{
clear all
import sas using "${path_src}\TIC_TIC Entreprises_20`year'\tic`year'_diff"
rename *, lower
/* */
gen siren_strlen=strlen(siren)
tab siren_strlen
replace siren="00"+siren if siren_strlen==7
replace siren="0"+siren if siren_strlen==8
drop siren_strlen
gen siren_strlen=strlen(siren)
tab siren_strlen
drop siren_strlen
/* */
save ${path}\data\tic\tic20`year'.dta, replace
}

/* 2020 */
clear all
import delimited using "${path_src}\TIC_TIC Entreprises_2020\TIC20_DIFF_20210915"
/* */
gen siren_strlen=strlen(siren)
tab siren_strlen
replace siren="00"+siren if siren_strlen==7
replace siren="0"+siren if siren_strlen==8
drop siren_strlen
gen siren_strlen=strlen(siren)
tab siren_strlen
drop siren_strlen
/* */
save ${path}\data\tic\tic2020.dta, replace

/* 2021 */
clear all
import delimited using "${path_src}\TIC_TIC Entreprises_2021\TIC21_DIFF_20220915"
/* */
gen siren_strlen=strlen(siren)
tab siren_strlen
replace siren="00"+siren if siren_strlen==7
replace siren="0"+siren if siren_strlen==8
drop siren_strlen
gen siren_strlen=strlen(siren)
tab siren_strlen
drop siren_strlen
/* */
save ${path}\data\tic\tic2021.dta, replace


