/* Code : Simon Bunel - BdF 26/01/21 */


/*************************************************************************************/
/*************************************************************************************/
/*************************************************************************************/
/* A partir de 2012, le fichier région 11 (Ile de France) n'existe plus. Il est remplacé par des fichiers départements
Il faut donc créer une macro SAS spéciale département */

%macro reg12(reg=,annee=);
%if %eval(&annee.)<=13 %then %do;
	libname coffre "\\casd.fr\casdfs\Projets\AUTOTRA\Data\DADS_DADS Postes_20&annee." ;
%end;
%else %do;
	libname coffre "\\casd.fr\casdfs\Projets\AUTOTRA\Data\DADS_DADS Postes_20&annee.\Régions" ;
%end;
	data t_&annee._&reg. ; set coffre.POST&reg.
		(/*obs=2000*/
    	keep= siren nic apet apet_1 pcs pcs_1 duree duree_1 filt filt_1 ind_3112 eff_3112_et comt comt_1 domempl domempl_1 
		REGT REGT_1 sexe age s_brut etp etp_1 nbheur nbheur_1
		where =( ((filt='1' & filt_1='1') | (filt='1' & filt_1='') | (filt='' & filt_1='1'))	 
			& (domempl not in ('1','2','3','7')  & domempl_1 not in ('1','2','3','7') )	
			/* Toute exploitation nécessitant de mobiliser plusieurs fichiers régionaux devra éliminer les doubles-comptes entre ces fichiers. 
			Pour les éviter, il faut utiliser le filtre suivant, lors de la lecture des fichiers régionaux, avant de les agréger en un seul fichier :*/
			& (REGT = "&reg." or (REGT = '' and REGT_1 = "&reg."))			  
			)
	)
 	;
	
	cs=substr(pcs,1,2);
	cs_1=substr(pcs_1,1,2);

	r_nbheur_duree=nbheur/duree;
	if (nbheur>0 /* Non nul */ & filt='1' /* Non annexe en N */ 
	& (duree>30 & nbheur>120 & r_nbheur_duree>1.5) /* Non annexe en N sur critère d'heures */) then salh=s_brut/nbheur;
	
	/* Correction de quelques valeurs etp missing malgré un nbheur>0 */
	etp_bis=nbheur/1820;
	etp_bis=min(etp_bis,1);
	if (etp=. & nbheur^=.) then etp=etp_bis;
	etp_1_bis=nbheur_1/1820;
	etp_1_bis=min(etp_1_bis,1);
	if (etp_1=. & nbheur_1^=.) then etp_1=etp_1_bis;

	if (filt='1' & filt_1='') then crea=etp ; else crea=0;

	if (filt='' & filt_1='1') then dest=etp_1 ; else dest=0;
	if (cs='' | cs='00') then cs=cs_1 ;
	if (cs='' | cs='00') then delete;
	if (pcs='' | pcs='00000') then pcs=pcs_1 ;

	if (filt='1' & filt_1='1') then cont = etp ; else cont=0;
	if ind_3112=1 & filt='1' then ind_3112_na=1; else ind_3112_na=0;

	siret=siren!!nic;

	run;

	data t_&annee._&reg. ; set t_&annee._&reg. 
	(rename=(SIRET=siret APET=apet COMT=comt PCS=pcs PCS_1=pcs_1 cs=cs2 cs_1=cs2_1 SEXE=sexe AGE=age S_BRUT=s_brut ETP=etp NBHEUR=nbheur)
	keep= siret apet comt pcs pcs_1 cs cs_1 sexe age s_brut etp nbheur crea dest cont salh
	)
	;
	run;

%mend;


/* Attention: pour 2014 et 2015, il y a les nouvelles régions*/

%reg12(reg=24,annee=14); %reg12(reg=27,annee=14); %reg12(reg=28,annee=14);
%reg12(reg=32,annee=14); %reg12(reg=44,annee=14); %reg12(reg=52,annee=14); %reg12(reg=53,annee=14);
%reg12(reg=75,annee=14); %reg12(reg=76,annee=14); %reg12(reg=84,annee=14); %reg12(reg=93,annee=14);
%reg12(reg=94,annee=14); %reg12(reg=97,annee=14); %reg12(reg=99,annee=14);

%reg12(reg=24,annee=15); %reg12(reg=27,annee=15); %reg12(reg=28,annee=15);
%reg12(reg=32,annee=15); %reg12(reg=44,annee=15); %reg12(reg=52,annee=15); %reg12(reg=53,annee=15);
%reg12(reg=75,annee=15); %reg12(reg=76,annee=15); %reg12(reg=84,annee=15); %reg12(reg=93,annee=15);
%reg12(reg=94,annee=15); %reg12(reg=97,annee=15); %reg12(reg=99,annee=15);

/* Departements  - 2013 2014 2015 */
%macro dep(dep=,annee=);
%if %eval(&annee.)<=13 %then %do;
	libname coffre "\\casd.fr\casdfs\Projets\AUTOTRA\Data\DADS_DADS Postes_20&annee.\Ile de France" ;
%end;
%else %do;
	libname coffre "\\casd.fr\casdfs\Projets\AUTOTRA\Data\DADS_DADS Postes_20&annee.\Départements" ;
%end;
	data t_&annee._D&dep. ; set coffre.POST&dep.
		(/*obs=200*/
    	 keep= siren nic apet apet_1 pcs pcs_1 duree duree_1 filt filt_1 ind_3112 eff_3112_et comt comt_1 domempl domempl_1 
		DEPT DEPT_1 sexe age s_brut etp etp_1 nbheur nbheur_1
		 where =( ((filt='1' & filt_1='1') | (filt='1' & filt_1='') | (filt='' & filt_1='1'))			
			& (domempl not in ('1','2','3','7') & domempl_1 not in ('1','2','3','7'))	 
			/* Toute exploitation nécessitant de mobiliser plusieurs fichiers régionaux devra éliminer les doubles-comptes entre ces fichiers. 
			Pour les éviter, il faut utiliser le filtre suivant, lors de la lecture des fichiers régionaux, avant de les agréger en un seul fichier :*/
			& (DEPT = "&dep." or (DEPT = '' and DEPT_1 = "&dep."))					  
			)
		)
 		;

		dep= &dep.;
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
		if ind_3112=1 & filt='1' then ind_3112_na=1; else ind_3112_na=0;

		siret=siren!!nic;

		run;

		data t_&annee._D&dep. ; set t_&annee._D&dep. 
		(rename=(SIRET=siret APET=apet COMT=comt PCS=pcs PCS_1=pcs_1 cs=cs2 cs_1=cs2_1 SEXE=sexe AGE=age S_BRUT=s_brut ETP=etp NBHEUR=nbheur)
		keep= siret apet comt pcs pcs_1 cs cs_1 sexe age s_brut etp nbheur crea dest cont salh
		)
		;
		run;

	%mend;

%dep(dep=75,annee=14); %dep(dep=77,annee=14); %dep(dep=78,annee=14); %dep(dep=91,annee=14); 
%dep(dep=92,annee=14); %dep(dep=93,annee=14); %dep(dep=94,annee=14); %dep(dep=95,annee=14);

%dep(dep=75,annee=15); %dep(dep=77,annee=15); %dep(dep=78,annee=15); %dep(dep=91,annee=15); 
%dep(dep=92,annee=15); %dep(dep=93,annee=15); %dep(dep=94,annee=15); %dep(dep=95,annee=15);

/* Base IDF sur 2012-2015 à partir des départements */
data t_14_11; set t_14_D75 t_14_D77 t_14_D78 t_14_D91 t_14_D92 t_14_D93 t_14_D94 t_14_D95 ; reg=11; run;
data t_15_11; set t_15_D75 t_15_D77 t_15_D78 t_15_D91 t_15_D92 t_15_D93 t_15_D94 t_15_D95 ; reg=11; run;


/* attention, à partir de 2014, l'empilement est différent */
%macro empil14(annee);
	data siret_unif_&annee.; set t_&annee._11 t_&annee._24 t_&annee._27 t_&annee._28 t_&annee._32 
								 t_&annee._44 t_&annee._52 t_&annee._53 t_&annee._75 t_&annee._76
								 t_&annee._84 t_&annee._93 t_&annee._94 t_&annee._97 t_&annee._99
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
	data empil_&annee.; set t_&annee._11 t_&annee._24 t_&annee._27 t_&annee._28 t_&annee._32 
							t_&annee._44 t_&annee._52 t_&annee._53 t_&annee._75 t_&annee._76
							t_&annee._84 t_&annee._93 t_&annee._94 t_&annee._97 t_&annee._99 
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
	delete t_&annee._11 t_&annee._24 t_&annee._27 t_&annee._28 t_&annee._32 
		   t_&annee._44 t_&annee._52 t_&annee._53 t_&annee._75 t_&annee._76
		   t_&annee._84 t_&annee._93 t_&annee._94 t_&annee._97 t_&annee._99
		   empil_&annee. siret_unif_&annee. t_&annee.;
	run;
%mend;

%empil14(14); %empil14(15); 
