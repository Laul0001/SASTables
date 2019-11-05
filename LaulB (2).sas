*Q1);

TITLE ' By Bhanu Laul';


*Q2;
data Q2;
title 'Bhanu Laul';
TITLE2 'Q2';
call streaminit(123);

Do samples = 1 to 1000;
	DO N = 1 TO 10;
	Normal = rand('norm', 2, 1.414);
	ContDist = rand('unif', 1, 3);
	Exponen = rand('EXPONENTIAL', 2);
	BERNL2 = RAND('BERNOULLI', 0.5);
		IF BERNL2 = 1
		THEN BERNLLI = BERNL2*3;
		if BERNL2 = 0 then BERNLLI= 0 ;
		
	POISSON= RAND('POIS', 2);
	ChiSq= RAND('CHISQUARE', 2);
	Cauchy = sum(RAND('CAUCHY'), 2);
	Multinom = rand('table', 0.4, 0.3, 0.2, 0.1);
	T1 = sum (rand('t', 1), 2);
	T2 = sum (rand('t', 2), 2);
	T3 = sum (rand('t', 3), 2);
	OUTPUT;
	
end;
END;
drop BERNL2 ;
RUN;

*2B;
DATA Q2B;
SET Q2;
PROC UNIVARIATE DATA= Q2;
VAR NORMAL EXPONEN BERNLLI POISSON CHISQ  CAUCHY T1 T2 T3 contdist multinom;
HIST / NORMAL (W=3 COLOR = BLUE) KERNEL (W=3 COLOR = BLUE);
RUN;

*2C;
DATA Averages;
SET Q2;
proc means data=Q2 NOPRINT Mean  lclm  uclm alpha= 0.025 nway ;
OUTPUT OUT= AVERAGES (drop = samples _type_ _freq_ ) mean= lclm=  uclm= /autoname ;

class samples;
var NORMAL EXPONEN BERNLLI POISSON CHISQ  CAUCHY T1 T2 T3 contdist multinom ;

run;


*2D);
Data Aver_plot; 
set averages;
proc univariate data = averages plot;
histogram/ normal (color= red) kernel (color= blue);
run;

*/ the averages for the following distributions look normal: Uniform, Exponential, Poisson, Chi-Square, Multinomail;

*2E);
data Aver_test;
SEt Averages;
ARRAY VAR_NAM (*) _NUMERIC_;
ARRAY RESULT(*) NORMALCI EXPONENCI BERNLLICI POISSONCI CHISQCI  CAUCHYCI T1CI T2CI T3CI contdistCI multinomCI ;
DO I = 1 TO 11;
	IF VAR_NAM(11+I)<2 AND VAR_NAM(22+I)>2 
	THEN RESULT(I) = 1;
	ELSE RESULT(I) = 0;
	OUTPUT ;
END;

RUN;


*f;
PROC FREQ DATA=averages;
table NORMALCI / nocum;
table EXPONENCI / nocum;
table BERNLLICI / nocum;
table POISSONCI / nocum;
table CHISQCI / nocum;
table CAUCHYCI / nocum;
table T1CI / nocum;
table T2CI / nocum;
table T3CI / nocum;
table CONTDISTCI / nocum;
table MULTINOMCI / nocum;
RUN;


*Q3;
FILENAME REFFILE '/folders/myfolders/STAT466/ExerciseRCT.xlsx';

PROC IMPORT DATAFILE=REFFILE replace
	DBMS=XLSX
	OUT=WORK.Q3;

RUN;

data EXERCISE;
SET Q3  ;
title ' Bhanu Laul';
title2 ' Q3';
dVO2MAX04= VO2MAXV00- VO2MAXV04;
dVO2MAX08= VO2MAXV00- VO2MAXV08;
dVO2MAX16=VO2MAXV00- VO2MAXV16;
dVO2MAX24= VO2MAXV00-VO2MAXV24;
run;

*B;
filename original '/folders/myfolders/ExerciseRCT.xlsx';
PROC IMPORT DATAFILE=original replace
	DBMS=XLSX
	OUT=E_DATA;
	GETNAMES=YES;
RUN;



PROC TABULATE data=exercise format=comma10.;
	title 'Bhanu Laul';
	title2 'Question 3';
	class Group Sex;
	var VO2maxV00 dVO2max04 dVO2max08 dVO2max16 dVO2max24;
	table (all='Overall' Sex = 'By Sex')*
	(VO2maxV00='Baseline' dVO2max04='Change at 4 weeks' 
	dVO2max08='Change at 8 weeks' dVO2max16='Change at 16 weeks' 
	dVO2max24='Change at 24 weeks'), 
	(N='Total' Group='Treatment Group'*(N Mean StdErr)) /box='VO2max (L/min)' misstext= [label='NA'];

RUN;


*Q3C);
PROC SGPLOT data=exercise(where=(group in ('Control' 'LALI' 'HALI' 'HAHI')));
	title 'By Bhanu Laul';
	title2 'Question 3';
	vbox dVO2max24 / category=sex group=group groupdisplay=cluster
		lineattrs=(pattern=solid) whiskerattrs=(pattern=solid);
	xaxis;
	yaxis;
	keylegend / location=outside position=bottom;
RUN;


*Q4;
title ' Bhanu Laul';
TITLE2 'Q4';
data Q4;
F1=0;
F2=1;
ARRAY FibSer (*) F1-F20;
DO I = 1 TO 18;
	FibSer (i+2) = FibSer(i+1)+ FibSer(i);
	end;
G1 = .;
G2 = .;
array GolRat (*) G1-g20;
DO i = 3 TO 20;
	GolRat(i) = FibSer(i)/FibSer(i-1);
	end;
run;



