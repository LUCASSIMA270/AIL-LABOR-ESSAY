
use ${path}\data\dads_bicrn_tic_full_sd_final.dta, replace

/* Employment */
matrix A1 = J(1,2,.)
summarize etp if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==1) [fw=fw${year_adopt_ia}], d
matrix A1[1,1] = r(mean)
summarize etp if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==0) [fw=fw${year_adopt_ia}], d
matrix A1[1,2] = r(mean) 
esttab matrix(A1, fmt(%12.0fc)) using ${path}\results\table1.${table_fmt}, replace ///
plain noobs nomtitles nonumbers varwidth(38) collabels("Adopters" "Non adopters") ///
varlabels(r1 "Employment (FTE)")
/* Sales */
matrix A2 = J(1,2,.)
summarize catotal if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==1) [fw=fw${year_adopt_ia}], d
matrix A2[1,1] = r(mean)
summarize catotal if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==0) [fw=fw${year_adopt_ia}], d
matrix A2[1,2] = r(mean) 
esttab matrix(A2, fmt(%12.0fc)) using ${path}\results\table1.${table_fmt}, append ///
plain noobs nomtitles nonumbers varwidth(38) collabels(none) ///
varlabels(r1 "Sales (k€)")
/* Labor Productivity */
matrix A3 = J(1,2,.)
summarize lp if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==1) [fw=fw${year_adopt_ia}], d
matrix A3[1,1] = r(mean)
summarize lp if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==0) [fw=fw${year_adopt_ia}], d
matrix A3[1,2] = r(mean) 
esttab matrix(A3, fmt(%12.0fc)) using ${path}\results\table1.${table_fmt}, append ///
plain noobs nomtitles nonumbers varwidth(38) collabels(none) ///
varlabels(r1 "Labor Productivity (k€ per worker)")
/* Capital Intensity */
matrix A4 = J(1,2,.)
summarize cap_int_etp if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==1) [fw=fw${year_adopt_ia}], d
matrix A4[1,1] = r(mean)
summarize cap_int_etp if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==0) [fw=fw${year_adopt_ia}], d
matrix A4[1,2] = r(mean) 
esttab matrix(A4, fmt(%12.0fc)) using ${path}\results\table1.${table_fmt}, append ///
plain noobs nomtitles nonumbers varwidth(38) collabels(none) ///
varlabels(r1 "Capital Intensity (k€ per worker)")
/* Labor Share in Value Added */
matrix A5 = J(1,2,.)
summarize ls if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==1) [fw=fw${year_adopt_ia}], d
matrix A5[1,1] = r(mean)
summarize ls if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==0) [fw=fw${year_adopt_ia}], d
matrix A5[1,2] = r(mean) 
esttab matrix(A5, fmt(%12.2fc)) using ${path}\results\table1.${table_fmt}, append ///
plain noobs nomtitles nonumbers varwidth(38) collabels(none) ///
varlabels(r1 "Labor Share in Value Added")
/* Low Skilled Workers (Share) */
matrix A6 = J(1,2,.)
summarize etp1_sh if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==1) [fw=fw${year_adopt_ia}], d
matrix A6[1,1] = r(mean)
summarize etp1_sh if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==0) [fw=fw${year_adopt_ia}], d
matrix A6[1,2] = r(mean) 
esttab matrix(A6, fmt(%12.2fc)) using ${path}\results\table1.${table_fmt}, append ///
plain noobs nomtitles nonumbers varwidth(38) collabels(none) ///
varlabels(r1 "Low Skilled Workers (Share)")
/* High Skilled Workers (Share) */
matrix A7 = J(1,2,.)
summarize etp3_sh if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==1) [fw=fw${year_adopt_ia}], d
matrix A7[1,1] = r(mean)
summarize etp3_sh if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==0) [fw=fw${year_adopt_ia}], d
matrix A7[1,2] = r(mean) 
esttab matrix(A7, fmt(%12.2fc)) using ${path}\results\table1.${table_fmt}, append ///
plain noobs nomtitles nonumbers varwidth(38) collabels(none) ///
varlabels(r1 "High Skilled Workers (Share)")
/* Engineers (Share) */
matrix A8 = J(1,2,.)
summarize etp38_sh if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==1) [fw=fw${year_adopt_ia}], d
matrix A8[1,1] = r(mean)
summarize etp38_sh if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==0) [fw=fw${year_adopt_ia}], d
matrix A8[1,2] = r(mean) 
esttab matrix(A8, fmt(%12.2fc)) using ${path}\results\table1.${table_fmt}, append ///
plain noobs nomtitles nonumbers varwidth(38) collabels(none) ///
varlabels(r1 "Engineers (Share)")
/* Export Share */
matrix A9 = J(1,2,.)
summarize export_sh if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==1) [fw=fw${year_adopt_ia}], d
matrix A9[1,1] = r(mean)
summarize export_sh if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==0) [fw=fw${year_adopt_ia}], d
matrix A9[1,2] = r(mean) 
esttab matrix(A9, fmt(%12.2fc)) using ${path}\results\table1.${table_fmt}, append ///
plain noobs nomtitles nonumbers varwidth(38) collabels(none) ///
varlabels(r1 "Export Share")
/* Age (Years) */
matrix A10 = J(1,2,.)
summarize age if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==1) [fw=fw${year_adopt_ia}], d
matrix A10[1,1] = r(mean)
summarize age if year==${year_ref_ia} & (ia${year_ref_ia}==0 & ia${year_adopt_ia}==0) [fw=fw${year_adopt_ia}], d
matrix A10[1,2] = r(mean) 
esttab matrix(A10, fmt(%12.0fc)) using ${path}\results\table1.${table_fmt}, append ///
plain noobs nomtitles nonumbers varwidth(38) collabels(none) ///
varlabels(r1 "Age (Years)")


