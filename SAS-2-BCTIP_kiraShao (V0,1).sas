/*BCTIP SAS Homework II	  */
/*	   By Kira Shao		  */
/*V.0.1 (Still unfinished)*/
/*						  */
/*						  */
/*						  */


/*Part.I Data Cleaning Part (Reference: example_code.sas)*/


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






/*Part.II Macro for Logistics regression*/


/*Here I made a macro to fit the logistics, just like R functions, the logi() requires an variable to be passed into it.*/
/*Once the var is passed. we dont need to call the whole proc logistics every time; just call logi(var)*/
/*ODS trace is used to save the variable in the logistics analysis*/

%macro logi(var);
ODS TRACE ON;
 proc logistic data = v1_only descending;
 model preterm = &var;
 ODS OUTPUT OddsRatios = oddsratio;
 ODS OUTPUT ParameterEstimates = pvalue;
run;
%mend;




/*Part.II Macro for generating rows and tables*/



/*Here is another macro to create the "right" table. Since ODS trace on still have some information we dont want*/
/*We use delete and keep to maintain what we need*/

%macro tablecreate(oddsratio, pvalue);
ODS TRACE ON;
data Pvalueresult;
 set pvalue;
 if variable = "Intercept" then delete;
 keep ProbChisq;
run;
proc sql _row;
 select * 
 from oddsratio as OddsRatio
 left join Pvalueresult as P_Value
 on OddsRatio.Effect;
/* ODS OUTPUT SQL_Results = results;*/
quit;
%mend;





/*I stopped here because I cannot access the SQL_Results*/







%logi(_334_48_5);
%tablecreate(oddsratio, pvalue);


%logi(_3025_96_5);
%tablecreate(oddsratio, pvalue);


ods rtf file="C:\Users\js1015\Desktop\js1015\BCTIP-SAS-2\result_SAS_II.rtf";
proc print data = %tablecreate(oddsratio, pvalue);
run;
ods rtf close; 


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

	
	
