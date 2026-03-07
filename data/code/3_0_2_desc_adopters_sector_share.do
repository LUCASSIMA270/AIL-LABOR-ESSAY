

use ${path}\data\dads_bicrn_tic_full_sd_final.dta, replace

graph hbar ia${year_adopt_ia} if year==${year_adopt_ia}  [fw=fw${year_adopt_ia}], graphregion(color(white)) over(${industry_level_sd}_label, sort(${industry_level_sd}_sorting) label(labsize(vsmall))) yscale(r(0 0.3)) ylabel(0(0.05)0.3) ytitle("Share") 
