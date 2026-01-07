/* Code : Simon Bunel - BdF 26/01/21 */
/* A partir de 2012, le fichier région 11 (Ile de France) n'existe plus. Il est remplacé par des fichiers départements
Il faut donc créer une macro SAS spéciale département */

/* 2018 */
%macro post18(reg=,annee=);
libname coffre "\\casd.fr\casdfs\Projets\AUTOTRA\Data\DADS_DADS Postes_20&annee." ;
	data t_&annee._&reg. ; set coffre.POST_&reg.
		(/*obs=2000*/
		rename=(eqtp=etp eqtp_1=etp_1)
    	keep= siren nic apet apet_1 pcs pcs_1 filt filt_1 duree duree_1 ind_3112 eff_3112_et comt comt_1 domempl domempl_1 
		REGT REGT_1 sexe age s_brut eqtp eqtp_1 nbheur nbheur_1 datfin 
		where =( ((filt='1' & filt_1='1') | (filt='1' & filt_1='') | (filt='' & filt_1='1')) 
			& (domempl not in ('1','2','3','7')  & domempl_1 not in ('1','2','3','7') )		  
			)
	)
 	;

	cs=substr(pcs,1,2);
	cs_1=substr(pcs_1,1,2);
	
	r_nbheur_duree=nbheur/duree;
	if (nbheur>0 /* Non nul */ & filt='1' /* Non annexe en N */ 
	& (duree>30 & nbheur>120 & r_nbheur_duree>1.5) /* Non annexe en N sur critère d'heures */) then salh=s_brut/nbheur;

	if (filt='1' & filt_1='') then crea=etp ; else crea=0;

	if (filt='' & filt_1='1') then dest=etp_1 ; else dest=0;
	if (cs='' | cs='00') then cs=cs_1 ;
	if (cs='' | cs='00') then delete;
	if (pcs='' | pcs='00000') then pcs=pcs_1 ;

	if (filt='1' & filt_1='1') then cont = etp ; else cont=0;
	if (duree=360 | datfin=360) & filt='1' then ind_3112_na=1; else ind_3112_na=0;

	siret=siren!!nic;

	run;

	data t_&annee._&reg. ; set t_&annee._&reg.
	(rename=(PCS=pcs PCS_1=pcs_1 cs=cs2 cs_1=cs2_1)
	keep= siret apet comt pcs pcs_1 cs cs_1 sexe age s_brut etp nbheur crea dest cont salh	
	)
	;
	run;

%mend;

%post18(reg=1,annee=18); %post18(reg=2,annee=18); %post18(reg=3,annee=18); %post18(reg=4,annee=18);

/* 2019 */
%macro post19(reg=,annee=);
libname coffre "\\casd.fr\casdfs\Projets\AUTOTRA\Data\DADS_DADS Postes_20&annee." ;
	data t_&annee._&reg. ; set coffre.POST_&reg.
		(/*obs=2000*/
		rename=(eqtp=etp eqtp_1=etp_1)
    	keep= siret apet apet_1 pcs pcs_1 filt filt_1 duree duree_1 ind_3112 eff_3112_et comt comt_1 domempl domempl_1 
		REGT REGT_1 sexe age s_brut eqtp eqtp_1 nbheur nbheur_1 datfin 
		where =( ((filt='1' & filt_1='1') | (filt='1' & filt_1='') | (filt='' & filt_1='1')) 
			& (domempl not in ('1','2','3','7')  & domempl_1 not in ('1','2','3','7') )		  
			)
	)
 	;

	cs=substr(pcs,1,2);
	cs_1=substr(pcs_1,1,2);
	
	r_nbheur_duree=nbheur/duree;
	if (nbheur>0 /* Non nul */ & filt='1' /* Non annexe en N */ 
	& (duree>30 & nbheur>120 & r_nbheur_duree>1.5) /* Non annexe en N sur critère d'heures */) then salh=s_brut/nbheur;

	if (filt='1' & filt_1='') then crea=etp ; else crea=0;

	if (filt='' & filt_1='1') then dest=etp_1 ; else dest=0;
	if (cs='' | cs='00') then cs=cs_1 ;
	if (cs='' | cs='00') then delete;
	if (pcs='' | pcs='00000') then pcs=pcs_1 ;

	if (filt='1' & filt_1='1') then cont = etp ; else cont=0;
	if (duree=360 | datfin=360) & filt='1' then ind_3112_na=1; else ind_3112_na=0;

	run;

	data t_&annee._&reg. ; set t_&annee._&reg.
	(rename=(PCS=pcs PCS_1=pcs_1 cs=cs2 cs_1=cs2_1)
	keep= siret apet comt pcs pcs_1 cs cs_1 sexe age s_brut etp nbheur crea dest cont salh	
	)
	;
	run;

%mend;

/* 2019 */
%post19(reg=1,annee=19); %post19(reg=2,annee=19); %post19(reg=3,annee=19); %post19(reg=4,annee=19);

/* Attention, à partir de 2014, l'empilement est différent */
%macro empil(annee);
	data siret_unif_&annee.; set t_&annee._1 t_&annee._2 t_&annee._3 t_&annee._4
					   ; 
	if dest>0 then delete; /* Car APET manquant */
	if missing(apet) then delete; /* Car APET manquant */
	if missing(comt) then delete; /* Car APET manquant */
	run;
	data siret_unif_&annee.; set siret_unif_&annee. (keep= siret apet comt); 
	run;
	/* Suppression des doublons */
	proc sort data=siret_unif_&annee. nodupkey out=siret_unif_&annee.; by siret; run ;
	/* Empilement avant export */
	data empil_&annee.; set t_&annee._1 t_&annee._2 t_&annee._3 t_&annee._4 
					; 
	year = 2000+&annee. ;
	run;
	data empil_&annee.; set empil_&annee.; drop apet comt; run;
	/* Merge pour code APET */
	proc sort data=empil_&annee.;
	   by siret;
	run;
	proc sort data=siret_unif_&annee.;
	   by siret;
	run;
	data t_&annee.;
	    merge empil_&annee. siret_unif_&annee.;
	    by siret;
	run;
	/* Suppression des doublons - Sans APET dans la liste pour éviter les Siret avec deux APET */
	proc sort data=t_&annee. nodupkey out=t_&annee.; by siret apet comt cs2 sexe age s_brut etp nbheur crea dest cont salh ; run ;
	/* Export */
	PROC EXPORT DATA = t_&annee. OUTFILE = "C:\Users\Public\Documents\replication_abjmrs_aeapp\data\dads\dads_postes_indiv_20&annee." DBMS = dta replace; 
	RUN ;
	/* Suppression DB */
	proc datasets library = work ; 
	delete t_&annee._1 t_&annee._2 t_&annee._3 t_&annee._4
		   empil_&annee. siret_unif_&annee. t_&annee.;
	run;
%mend;

%empil(18); %empil(19); 
