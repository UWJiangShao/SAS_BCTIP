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
* check the number of subjects and observations in the dataset;
proc sql; select count(*) as total_obs, count(distinct(subj_id)) as unique_pat from metab_dat; quit;

/* Note about the data: subjects were identified as case or control and lab samples were taken at two timepoints during the study.
There samples underwent targeted metabolomic analysis and a subset of the metabolites are included in this dataset. 
	- subj_ID: unique subject identifier
	- lab_ID: unique identifier for each individual lab sample
	- case_control: case/control status for each subject, 1 = case and 2 = control
	- time_point: T1 = visit 1, T2 = visit 2
	- setnum: observations with the same number are matched case and control
*/

PROC FORMAT;
	value cases_control 1 = 'Cases' 2 = 'Control';
RUN;

DATA ana_metab;
	set metab_dat;
	format case_control cases_control.;
	label case_control = 'Case/control status';
RUN;



/***********************************************/
/***             	VISIT 1                  ***/
/***********************************************/

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



%logi(_334_48_5);
%logi(_3025_96_5);
%logi(_5746_90_7);
%logi(_80_69_3);
%logi(_7664_38_2);
%logi(_542_44_9);
%logi(_57_88_5);
%logi(_495_69_2);
%logi(_99_50_3);
%logi(_102_32_9);

%TABLE(dsn = oddsratio, 
		var = OddsRatioEst,
		type = 1, 
		outdoc = &proj.Example\Table_v3, TTITLE1 = Visit 1);

proc tabulate data = oddsratio;
	var OddsRatioEst;
	table OddsRatioEst;
	title 'Table 4';
run;
	
	
