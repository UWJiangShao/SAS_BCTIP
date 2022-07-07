* project path;
%let proj = C:\Users\js1015\Desktop\js1015\BCTIP-SAS-2\;
%put &proj.;

* data directory;
libname data "&proj.Example\";

* Mayo table macro to create descriptive statistics table;
%include "&proj.Example\mayotable.sas";
* transposing multiple variables;
%include "&proj.Example\MultiTranspose.sas";

* import data;
PROC IMPORT datafile = "&proj.Example\metabolites.xlsx" out = metab_dat
	dbms = xlsx replace;
RUN;


PROC FORMAT;
	value cases_control 1 = 'Cases' 2 = 'Control';
RUN;

DATA ana_metab;
	set metab_dat;
	format case_control cases_control.;
	label case_control = 'Case/control status';
RUN;


DATA v1_only;
	set ana_metab;
	where Time_Point = 'T1';
RUN;

%macro logi(var);
ODS TRACE ON;
 proc logistic data = v1_only descending;
 model preterm = &var;
 ODS OUTPUT OddsRatios = oddsratio;
 ODS OUTPUT ParameterEstimates = pvalue;
run;
%mend;


%macro tablecreate(oddsratio, pvalue);
data Pvalueresult;
 set pvalue;
 if variable = "Intercept" then delete;
 keep ProbChisq;
run;
proc sql;
 select * 
 from oddsratio as OddsRatio
 left join Pvalueresult as P_Value
 on OddsRatio.Effect;
quit;
%mend;

%logi(_334_48_5);
%tablecreate(oddsratio, pvalue);

/*proc sql;*/
/*create table result_table(label= 'Metabolites preterm') as*/
/*select **/
/*from oddsratio, Pvalueresult*/
/*where oddsratio.Effect;*/
/*quit; */




/*%logi(_334_48_5);*/
/*%logi(_3025_96_5);*/
/*%logi(_5746_90_7);*/
/*%logi(_80_69_3);*/
/*%logi(_7664_38_2);*/
/*%logi(_542_44_9);*/
/*%logi(_57_88_5);*/
/*%logi(_495_69_2);*/
/*%logi(_99_50_3);*/
/*%logi(_102_32_9);*/


/*data Pvalueresult;*/
/* set pvalue;*/
/* if variable = "Intercept" then delete;*/
/* keep ProbChisq;*/
/*run;*/
/**/
/*proc print data = Pvalueresult;*/
/*run;*/
/*	*/
/*proc sql;*/
/*select * */
/*from oddsratio as OddsRatio*/
/*left join Pvalueresult as P_Value*/
/*on OddsRatio.Effect;*/
/*quit;*/

	
	
