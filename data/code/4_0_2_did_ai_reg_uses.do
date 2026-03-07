
use ${path}\data\dads_bicrn_tic_readyreg.dta, replace
/* IA type d'usage */
foreach ia_us in admin gestion grh logistiq marketing product secu {
gen adopt_ia_${year_ref_ia}_${year_adopt_ia}_`ia_us'=.
replace adopt_ia_${year_ref_ia}_${year_adopt_ia}_`ia_us'=0 if ia${year_ref_ia}==0 & ia${year_adopt_ia}==0
replace adopt_ia_${year_ref_ia}_${year_adopt_ia}_`ia_us'=1 if ia${year_ref_ia}==0 & ia${year_adopt_ia}==1 & ia_us_`ia_us'${year_adopt_ia}==1
	
}
/* */
egen secteur_gr=group(${industry_level_fe})
gen treated1 = ${treated_var1}
gen treated2 = ${treated_var2}
/* */
drop if ${var_reg}==.
/* */
keep if inrange(year,${year_first},${year_last})
/* */
gen obs=1
bys siren : egen nb_obs=sum(obs)
egen nb_obs_max=max(nb_obs)
keep if nb_obs==nb_obs_max
/* */
egen siren_gr=group(siren)
xtset siren_gr year
sort siren_gr year
/* */
gen treated1_delta_year=treated1*year
gen treated2_delta_year=treated2*year
/* */
gen sqrt_etp${year_first}=sqrt(etp) if year==${year_first}
sort siren sqrt_etp${year_first}
by siren : replace sqrt_etp${year_first}=sqrt_etp${year_first}[1]
/* */
gen w=${weight}
/* */
rename treated1_delta_year treated_delta_year
reghdfe ${var_reg} ib${year_base}.treated_delta_year [aw=w], absorb(siren secteur_gr#year) cluster(siren) keepsingleton
eststo r_${var_reg}_treated1
rename treated_delta_year treated1_delta_year
rename treated2_delta_year treated_delta_year
reghdfe ${var_reg} ib${year_base}.treated_delta_year [aw=w], absorb(siren secteur_gr#year) cluster(siren) keepsingleton
eststo r_${var_reg}_treated2
rename treated_delta_year treated2_delta_year
/* */
matrix coef=e(b)
matrix list coef
/* */
if("${industry_level_fe}"=="ape_gr"){
local note_fe = "Controlling for 5d-Industry*Year + Firm F.E." 
} 
if("${industry_level_fe}"=="ape_2d_gr"){
local note_fe = "Controlling for 2d-Industry*Year + Firm F.E." 
} 
if("${industry_level_fe}"=="sect_act_10"){
local note_fe = "Controlling for 1d-Industry*Year + Firm F.E." 
} 
local xline=${year_base}-${year_first}+1.5
local xlineplus1=${year_base}-${year_first}+3.5
/* */
foreach treated_var_nb in 1 2 {
if("${treated_var`treated_var_nb'}"=="adopt_ia_${year_ref_ia}_${year_adopt_ia}_admin"){
global treated_var`treated_var_nb'_txt "Administrative processes"
}
if("${treated_var`treated_var_nb'}"=="adopt_ia_${year_ref_ia}_${year_adopt_ia}_gestion"){
global treated_var`treated_var_nb'_txt "Management of Enterprises"
}
if("${treated_var`treated_var_nb'}"=="adopt_ia_${year_ref_ia}_${year_adopt_ia}_grh"){
global treated_var`treated_var_nb'_txt "HR Management"
}
if("${treated_var`treated_var_nb'}"=="adopt_ia_${year_ref_ia}_${year_adopt_ia}_logistiq"){
global treated_var`treated_var_nb'_txt "Logistics"
}
if("${treated_var`treated_var_nb'}"=="adopt_ia_${year_ref_ia}_${year_adopt_ia}_marketing"){
global treated_var`treated_var_nb'_txt "Marketing or Sales"
}
if("${treated_var`treated_var_nb'}"=="adopt_ia_${year_ref_ia}_${year_adopt_ia}_product"){
global treated_var`treated_var_nb'_txt "Production Processes"
}
if("${treated_var`treated_var_nb'}"=="adopt_ia_${year_ref_ia}_${year_adopt_ia}_secu"){
global treated_var`treated_var_nb'_txt "ICT Security"
}
}
/* */
mylabels $yscmin($yscdelta)$yscmax, local(ylabel) format(%03.2f) clean
coefplot (r_${var_reg}_treated1, label("$treated_var1_txt") offset(-0.05)) (r_${var_reg}_treated2, label("$treated_var2_txt") offset(0.05)), omitted baselevels bylabel(All) ///
vertical graphregion(color(white)) keep(20*treated_delta_year)  ///
xline(`xline',lpattern(dash)) yline(0) recast(connected) level(95) ciopts(recast(rcap)) ///
coeflabels(2014.treated_delta_year = "2014" 2015.treated_delta_year = "2015" 2016.treated_delta_year = "2016" 2017.treated_delta_year = "2017" 2018.treated_delta_year = "2018" 2019.treated_delta_year = "2019" 2020.treated_delta_year = "2020" 2021.treated_delta_year = "2021" 2022.treated_delta_year = "2022" 2023.treated_delta_year = "2023") ytitle("Estimated Semi-Elasticity") xtitle("Year") note(`note_fe') addplot(scatteri $yscmin `xline' $yscmin `xlineplus1' $yscmax `xlineplus1' $yscmax `xline', recast(area) color(gs10%50) lwidth(none)) ylabel(`ylabel', angle(0)) yscale(range($yscmin $yscmax)) 
/* */


