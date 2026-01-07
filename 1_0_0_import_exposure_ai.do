
use ${path}\data\source\bergeaud_2024_exposure_ai_final.dta, replace
rename safe_tasks safe_tasks_sh
drop type
/* */
gen type=.
replace type=1 if inrange(exposure,-10^8,0) & inrange(safe_tasks_sh,0,50)
replace type=2 if inrange(exposure,-10^8,0) & inrange(safe_tasks_sh,50.001,100)
replace type=3 if inrange(exposure,0.0001,10^8) & inrange(safe_tasks_sh,50.001,100)
replace type=4 if inrange(exposure,0.0001,10^8) & inrange(safe_tasks_sh,0,50)
/* Ajout des techniciens informatiques : exposés et complémentaires - type=3 */
/* PCS 478A */
insobs 1
replace pcs="478A" if pcs==""
replace fap="M1Z80" if fap==""
replace type=3 if type==.
/* PCS 478B */
insobs 1
replace pcs="478B" if pcs==""
replace fap="M1Z81" if fap==""
replace type=3 if type==.
/* PCS 478C */
insobs 1
replace pcs="478C" if pcs==""
replace fap="M1Z81" if fap==""
replace type=3 if type==.
/* PCS 478D */
insobs 1
replace pcs="478D" if pcs==""
replace fap="M1Z81" if fap==""
replace type=3 if type==.
/* Ajout des militaires et syndicalistes - type=1 */
/* PCS 334A */
insobs 1
replace pcs="334A" if pcs==""
replace fap="P2Z92" if fap==""
replace type=1 if type==.
/* PCS 335A */
insobs 1
replace pcs="335A" if pcs==""
replace fap="X0Z00" if fap==""
replace type=1 if type==.
/* */
_pctile exposure, p(${exposure_phigh})	
gen exposure_phigh=`r(r1)'  
_pctile safe_tasks_sh, p(${safe_tasks_sh_plow})	
gen safe_tasks_sh_plow=`r(r1)'   
gen super_exposed=(inrange(exposure,exposure_phigh,10^8) & inrange(safe_tasks_sh,0,safe_tasks_sh_plow))
tab exposure_phigh safe_tasks_sh_plow
drop exposure_phigh safe_tasks_sh_plow
tab type super_exposed
/* */
keep pcs type super_exposed
duplicates drop
/* */
save ${path}\data\other\exposure_ai_readyuse.dta, replace