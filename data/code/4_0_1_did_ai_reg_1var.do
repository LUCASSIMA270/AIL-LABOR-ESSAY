
use ${path}\data\dads_bicrn_tic_readyreg.dta, replace
/* IA 0/1 */
gen adopt_ia_${year_ref_ia}_${year_adopt_ia}=.
replace adopt_ia_${year_ref_ia}_${year_adopt_ia}=0 if ia${year_ref_ia}==0 & ia${year_adopt_ia}==0
replace adopt_ia_${year_ref_ia}_${year_adopt_ia}=1 if ia${year_ref_ia}==0 & ia${year_adopt_ia}==1
/* IA type d'usage */
gen adopt_ia_${year_ref_ia}_${year_adopt_ia}_${ia_us}=.
replace adopt_ia_${year_ref_ia}_${year_adopt_ia}_${ia_us}=0 if ia${year_ref_ia}==0 & ia${year_adopt_ia}==0
replace adopt_ia_${year_ref_ia}_${year_adopt_ia}_${ia_us}=1 if ia${year_ref_ia}==0 & ia${year_adopt_ia}==1 & ia_us_${ia_us}${year_adopt_ia}==1
/* */
egen secteur_gr=group(${industry_level_fe})
gen treated = ${treated_var}
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
order siren treated
tab year treated
/* */
egen siren_gr=group(siren)
xtset siren_gr year
sort siren_gr year
/* */
gen treated1_delta_year=treated*year
/* */
gen sqrt_etp${year_first}=sqrt(etp) if year==${year_first}
sort siren sqrt_etp${year_first}
by siren : replace sqrt_etp${year_first}=sqrt_etp${year_first}[1]
/* */
gen w=${weight}
/* */
reghdfe ${var_reg} ib${year_base}.treated1_delta_year [aw=w], absorb(siren secteur_gr#year) cluster(siren) keepsingleton
eststo r_${var_reg}
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
if("${treated_var}"=="adopt_ia_${year_ref_ia}_${year_adopt_ia}"){
global treated_var_txt "AI adoption"
}
if("${treated_var}"=="adopt_ia_${year_ref_ia}_${year_adopt_ia}_admin"){
global treated_var_txt "AI adoption for Administrative processes"
}
if("${treated_var}"=="adopt_ia_${year_ref_ia}_${year_adopt_ia}_gestion"){
global treated_var_txt "AI adoption for Management of Enterprises"
}
if("${treated_var}"=="adopt_ia_${year_ref_ia}_${year_adopt_ia}_grh"){
global treated_var_txt "AI adoption for HR Management"
}
if("${treated_var}"=="adopt_ia_${year_ref_ia}_${year_adopt_ia}_logistiq"){
global treated_var_txt "AI adoption for Logistics"
}
if("${treated_var}"=="adopt_ia_${year_ref_ia}_${year_adopt_ia}_marketing"){
global treated_var_txt "AI adoption for Marketing or Sales"
}
if("${treated_var}"=="adopt_ia_${year_ref_ia}_${year_adopt_ia}_product"){
global treated_var_txt "AI adoption for Production Processes"
}
if("${treated_var}"=="adopt_ia_${year_ref_ia}_${year_adopt_ia}_secu"){
global treated_var_txt "AI adoption for ICT Security"
}
/* */
if("${var_reg}"=="log_etp"){
global var_reg_label "Total Employment"
}
if("${var_reg}"=="log_sales"){
global var_reg_label "Total Sales"
}
if("${var_reg}"=="log_etp_expai3"){
global var_reg_label "Employment - High exposure to AI & Complementarity"
}
if("${var_reg}"=="log_etp_expai4"){
global var_reg_label "Employment - High exposure to AI & Substituability"
}
if("${var_reg}"=="log_etp_expai1_2"){
global var_reg_label "Employment - Low exposure to AI"
}
if("${var_reg}"=="etp_expai3_sh"){
global var_reg_label "Employment share - High exposure to AI & Complementarity"
}
if("${var_reg}"=="etp_expai4_sh"){
global var_reg_label "Employment share - High exposure to AI & Substituability"
}
if("${var_reg}"=="etp_expai1_2_sh"){
global var_reg_label "Employment share - Low exposure to AI"
}
/* */
mylabels $yscmin($yscdelta)$yscmax, local(ylabel) format(%03.2f) clean
coefplot r_${var_reg}, omitted baselevels bylabel(All) ///
vertical graphregion(color(white)) keep(20*treated1_delta_year)  ///
xline(`xline',lpattern(dash)) yline(0) recast(connected) level(95) ciopts(recast(rcap)) ///
coeflabels(2014.treated1_delta_year = "2014" 2015.treated1_delta_year = "2015" 2016.treated1_delta_year = "2016" 2017.treated1_delta_year = "2017" 2018.treated1_delta_year = "2018" 2019.treated1_delta_year = "2019" 2020.treated1_delta_year = "2020" 2021.treated1_delta_year = "2021" 2022.treated1_delta_year = "2022" 2023.treated1_delta_year = "2023") ytitle("Estimated Semi-Elasticity") xtitle("Year") note(`note_fe') addplot(scatteri $yscmin `xline' $yscmin `xlineplus1' $yscmax `xlineplus1' $yscmax `xline', recast(area) color(gs10%50) lwidth(none)) ylabel(`ylabel', angle(0)) yscale(range($yscmin $yscmax))
/* */
tab year treated


