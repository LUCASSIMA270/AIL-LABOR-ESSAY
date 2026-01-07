/*=================================================
Chargement des données comptables des entreprises
===================================================*/

%macro charge_bicrn;
%let debut = 1998;
%let fin = 2016;

%do annee = &debut. %to &fin.;
			libname libbic "\\casd.fr\casdfs\Projets\AUTOTRA\Data\DECFISCPRO_BIC-RN_&annee.";

%if %eval(&annee.)<=1998 %then %do; data bicrn_&annee. (rename=(naf=nafbicrn) keep = siren year naf datcrea KS KU MK MJ ML PZ QC FL FM FN FO FQ FS FT FU FV FW FX FY FZ FY FZ FK KI KL KO KR KX LA LD LG LY MB ME MH MN MQ MT MW PL PQ PU PY QG QK QO QT); %end;
%else %if %eval(&annee.)<=2000 %then %do; data bicrn_&annee. (rename=(naffrp=nafbicrn) keep = siren year naffrp datcrea KS KU MK MJ ML PZ QC FL FM FN FO FQ FS FT FU FV FW FX FY FZ GE FK KI KL KO KR KX LA LD LG LY MB ME MH MN MQ MT MW PL PQ PU PY QG QK QO QT); %end;
%else %if %eval(&annee.)<=2001 %then %do; data bicrn_&annee. (rename=(naffrp=nafbicrn sirenfrp=siren) keep = sirenfrp year naffrp datcrea KS KU MK MJ ML PZ QC FL FM FN FO FQ FS FT FU FV FW FX FY FZ GE FK KI KL KO KR KX LA LD LG LY MB ME MH MN MQ MT MW PL PQ PU PY QG QK QO QT); %end;
%else %if %eval(&annee.)<=2002 %then %do; data bicrn_&annee. (rename=(naf=nafbicrn sirenfrp=siren) keep = sirenfrp year naf datcrea KS KU MK MJ ML PZ QC FL FM FN FO FQ FS FT FU FV FW FX FY FZ GE FY FZ FK KI KL KO KR KX LA LD LG LY MB ME MH MN MQ MT MW PL PQ PU PY QG QK QO QT); %end;
%else %if %eval(&annee.)<=2007 %then %do; data bicrn_&annee. (rename=(naf=nafbicrn) keep = siren year naf datcrea KS KU MK MJ ML PZ QC FL FM FN FO FQ FS FT FU FV FW FX FY FZ GE FY FZ FK KI KL KO KR KX LA LD LG LY MB ME MH MN MQ MT MW PL PQ PU PY QG QK QO QT); %end;
%else %if %eval(&annee.)<=2008 %then %do; data bicrn_&annee. (rename=(apenrev2=nafbicrn dcren=datcrea) keep = siren year apenrev2 dcren KS KU MK MJ ML PZ QC FL FM FN FO FQ FS FT FU FV FW FX FY FZ GE FY FZ FK KI KL KO KR KX LA LD LG LY MB ME MH MN MQ MT MW PL PQ PU PY QG QK QO QT); %end;
%else %do; data bicrn_&annee. (rename=(nafrev2=nafbicrn dcren=datcrea) keep = siren year nafrev2 dcren KS KU MK MJ ML PZ QC FL FM FN FO FQ FS FT FU FV FW FX FY FZ GE FY FZ FK KI KL KO KR KX LA LD LG LY MB ME MH MN MQ MT MW PL PQ PU PY QG QK QO QT); %end;
%if %eval(&annee.)<2000 %then %do;	set libbic.bicrn_&annee.; %end;
%else %do; set libbic.bicrn_ex_%substr(&annee.,3,2)_complet; %end;
year=&annee.;
run;

/* Missing -> 0 / Calcul valeur ajoutée / Keep */
data bicrn_&annee. (keep = siren nafbicrn datcrea year KS KU MK MJ ML PZ QC FL vaht ebe FY FZ FK KI KL KO KR KX LA LD LG LY MB ME MH MN MQ MT MW PL PQ PU PY QG QK QO QT);
set bicrn_&annee.;
if KS=. then KS=0; 
if KU=. then KU=0;
if MK=. then MK=0;
if MJ=. then MJ=0;
if ML=. then ML=0;
if PZ=. then PZ=0;
if QC=. then QC=0;
if FL=. then FL=0;
if FM=. then FM=0;
if FN=. then FN=0;
if FO=. then FO=0;
if FQ=. then FQ=0;
if FS=. then FS=0;
if FT=. then FT=0;
if FU=. then FU=0;
if FV=. then FV=0;
if FW=. then FW=0;
if FX=. then FX=0;
if GE=. then GE=0;
if FY=. then FY=0;
if FZ=. then FZ=0;
if FK=. then FK=0;
if KI=. then KI=0;
if KL=. then KL=0;
if KO=. then KO=0;
if KR=. then KR=0;
if KX=. then KX=0;
if LA=. then LA=0;
if LD=. then LD=0;
if LG=. then LG=0;
if LY=. then LY=0;
if MB=. then MB=0;
if ME=. then ME=0;
if MH=. then MH=0;
if MN=. then MN=0;
if MQ=. then MQ=0;
if MT=. then MT=0;
if MW=. then MW=0;
if PL=. then PL=0;
if PQ=. then PQ=0;
if PU=. then PU=0;
if PY=. then PY=0;
if QG=. then QG=0;
if QK=. then QK=0;
if QO=. then QO=0;
if QT=. then QT=0;
vaht=FL+FM+FN+FQ-FS-FT-FU-FV-FW-GE;
ebe=FL+FM+FN+FO+FQ-FS-FT-FU-FV-FW-FX-FY-FZ-GE;
run;

%if %eval(&annee.)=1998 %then %do;
data bicrn_&annee.;
set bicrn_&annee.;
KS=round(KS/6.55957,1);
KU=round(KU/6.55957,1);
MK=round(MK/6.55957,1);
MJ=round(MJ/6.55957,1);
ML=round(ML/6.55957,1);
PZ=round(PZ/6.55957,1);
QC=round(QC/6.55957,1);
FL=round(FL/6.55957,1);
vaht=round(vaht/6.55957,1);
ebe=round(ebe/6.55957,1);
FY=round(FY/6.55957,1);
FZ=round(FZ/6.55957,1);
FK=round(FK/6.55957,1);
KI=round(KI/6.55957,1);
KL=round(KL/6.55957,1);
KO=round(KO/6.55957,1);
KR=round(KR/6.55957,1);
KX=round(KX/6.55957,1);
LA=round(LA/6.55957,1);
LD=round(LD/6.55957,1);
LG=round(LG/6.55957,1);
LY=round(LY/6.55957,1);
MB=round(MB/6.55957,1);
ME=round(ME/6.55957,1);
MH=round(MH/6.55957,1);
MN=round(MN/6.55957,1);
MQ=round(MQ/6.55957,1);
MT=round(MT/6.55957,1);
MW=round(MW/6.55957,1);
PL=round(PL/6.55957,1);
PQ=round(PQ/6.55957,1);
PU=round(PU/6.55957,1);
PY=round(PY/6.55957,1);
QG=round(QG/6.55957,1);
QK=round(QK/6.55957,1);
QO=round(QO/6.55957,1);
QT=round(QT/6.55957,1);
run;
%end;

%end;
%mend;

%charge_bicrn;


/* To import data for years 2017-2022 */
%macro charge_bicis;
%let debut = 2017;
%let fin = 2023;

%do annee = &debut. %to &fin.;
			libname libbic "\\casd.fr\casdfs\Projets\AUTOTRA\Data\DECFISCPRO_BIC-IS_&annee.";

data bicis_&annee. 
(keep = siren year regime nafrev2 dtImatt _300656 _300658 _300719 _300718 _300720 _300859 _300862 _300506 _300508 _300510 _300512 _300516 _300520 _300522 _300524 _300526 _300528
_300542 _300530 _300532 _300505 _300646 _300649 _300652 _300655 _300661 _300664 _300667 _300670 _300703 _300707 _300711 _300715 _300723 _300727 _300731 _300735
_300847 _300851 _300855 _300858 _300866 _300870 _300874 _300878  _304790
rename=(
nafrev2=nafbicrn 
dtImatt=datcrea
_300656=KS
_300658=KU
_300719=MK
_300718=MJ
_300720=ML
_300859=PZ
_300862=QC
_300506=FL
_300508=FM
_300510=FN
_300512=FO
_300516=FQ
_300520=FS
_300522=FT
_300524=FU
_300526=FV
_300528=FW
_304790=FX
_300542=GE
_300530=FY
_300532=FZ
_300505=FK
_300646=KI
_300649=KL
_300652=KO
_300655=KR
_300661=KX
_300664=LA
_300667=LD
_300670=LG
_300703=LY
_300707=MB
_300711=ME
_300715=MH
_300723=MN
_300727=MQ
_300731=MT
_300735=MW
_300847=PL
_300851=PQ
_300855=PU
_300858=PY
_300866=QG
_300870=QK
_300874=QO
_300878=QT
) 
);
%if %eval(&annee.)<=2017 %then %do;
	set libbic.bicis_&annee._def;
%end;
%else %if %eval(&annee.)>2017 %then %do;
	set libbic.bicis_&annee.;
%end;
year=&annee.;

/* Missing -> 0 / Calcul valeur ajoutée / Keep */
data bicis_&annee. (keep = siren regime nafbicrn datcrea year KS KU MK MJ ML PZ QC FL vaht ebe FY FZ FK KI KL KO KR KX LA LD LG LY MB ME MH MN MQ MT MW PL PQ PU PY QG QK QO QT); 
set bicis_&annee.; 
if KS=. then KS=0; 
if KU=. then KU=0;
if MK=. then MK=0;
if MJ=. then MJ=0;
if ML=. then ML=0;
if PZ=. then PZ=0;
if QC=. then QC=0;
if FL=. then FL=0;
if FM=. then FM=0;
if FN=. then FN=0;
if FO=. then FO=0;
if FQ=. then FQ=0;
if FS=. then FS=0;
if FT=. then FT=0;
if FU=. then FU=0;
if FV=. then FV=0;
if FW=. then FW=0;
if FX=. then FX=0;
if GE=. then GE=0;
if FY=. then FY=0;
if FZ=. then FZ=0;
if FK=. then FK=0;
if KI=. then KI=0;
if KL=. then KL=0;
if KO=. then KO=0;
if KR=. then KR=0;
if KX=. then KX=0;
if LA=. then LA=0;
if LD=. then LD=0;
if LG=. then LG=0;
if LY=. then LY=0;
if MB=. then MB=0;
if ME=. then ME=0;
if MH=. then MH=0;
if MN=. then MN=0;
if MQ=. then MQ=0;
if MT=. then MT=0;
if MW=. then MW=0;
if PL=. then PL=0;
if PQ=. then PQ=0;
if PU=. then PU=0;
if PY=. then PY=0;
if QG=. then QG=0;
if QK=. then QK=0;
if QO=. then QO=0;
if QT=. then QT=0;
vaht=FL+FM+FN+FQ-FS-FT-FU-FV-FW-GE;
ebe=FL+FM+FN+FO+FQ-FS-FT-FU-FV-FW-FX-FY-FZ-GE;
run;
%end;
%mend;

%charge_bicis;

/**** Empilement de toutes les années ****/
data bicrn_allyears;
	length nafbicrn $5;
    set 
	/* 1998-2016 */
	bicrn_1998 bicrn_1999
	bicrn_2000 bicrn_2001 bicrn_2002 bicrn_2003 
	bicrn_2004 bicrn_2005 bicrn_2006 bicrn_2007 
	bicrn_2008 bicrn_2009 bicrn_2010 bicrn_2011
	bicrn_2012 bicrn_2013 bicrn_2014 bicrn_2015 
	bicrn_2016;
run;

data bicis_allyears (drop = Regime);
	length nafbicrn $5; 
    set 
	/* 2017-2023 */
	bicis_2017 bicis_2018 bicis_2019 
	bicis_2020 bicis_2021 bicis_2022 bicis_2023;
	if Regime ^= 'RSI'; /* To get rid of RSI */
run;

data bicrn_allyears_fi;
	length nafbicrn $5;
	/* 1998-2023 */
	set bicrn_allyears bicis_allyears;
run;

proc sort data = bicrn_allyears_fi NODUPKEY;by siren year;
run;

PROC EXPORT DATA = bicrn_allyears_fi OUTFILE = "C:\Users\Public\Documents\replication_abjmrs_aeapp\data\bicrn\bicrn_allyears_fi" DBMS = dta replace; 
RUN ;

