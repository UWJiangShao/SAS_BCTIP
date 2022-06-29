*********************************************************************************************;
*																							 ;
*																							 ;
*		Email your program to tracy.truong@duke.edu by 12:00pm Wednesday, February 9         ;
*																							 ;
*																							 ;
*		INSTRUCTIONS: THIS ENTIRE ASSIGNMENT SHOULD BE DONE ONLY USING PROC SQL. YOU MAY	 ;
*		USE PROC FORMAT TO CREATE FORMATS IF ASKED/DESIRED, BUT DO NOT USE A DATA STEP		 ;
*		OR PROC MEANS, FREQ, ETC. TO ANSWER THE QUESTIONS OR PERFORM CALCULATIONS			 ;
*																							 ;
*																							 ;
*																							 ;
*********************************************************************************************;

******* Question 1: Write a header for this program detailing your name, title of the program,
	   	date, purpose of the program, and any other relevant information. *******************;

*********************************************************************************************;
*	Name: Kira Shao																			 ;
*	Title: BCTIP SAS coding HW																 ;
*	Purpose: HW practise																	 ;
*	version: V1.0																			 ;
*																							 ;
*********************************************************************************************;



******* Question 2: Perform an inner join on ID and EmpID using these two datasets. Select the age 
		variable from duke_university_employee_demo in the final dataset. Give 
		duke_university_employee_demo the alias "demo" and duke_university_payroll_info 
		the alias "payroll" *****************************************************************;

data duke_university_employee_demo;
input ID age sex $;
datalines;
1	24	F
2	35	M
3	65	M
5	42	F
7	50	M
;
run;

data duke_university_payroll_info;
input EmpID age income;
datalines;
1	23	72000
2	35	40000
4	56	95000
7	18	18000
8	31	45000
;
run;


/*
Answer:
Perform a Inner Join for ID and EmpID
select 
*/
title 'Question 2 Answer';
proc sql;
select*      /*Not sure how selecting age works in this case*/
from duke_university_employee_demo as demo 
inner join duke_university_payroll_info as payroll
on demo.ID = payroll.EmpID
;
quit; 
















******* Question 3: Perform a left join using the two datasets above. 
		Consider duke_university_employee_demo as the left dataset and
		duke_university_payroll_info as the right dataset.
		Select age from duke_university_employee_demo again. *********************;

/*https://www.listendata.com/2014/06/proc-sql-merging.html*/

title 'Question 3 Answer';
proc sql;
select* 
from duke_university_employee_demo as demo
left join duke_university_payroll_info as payroll
on demo.ID = payroll.EmpID;
quit;



























******* Question 4: Write an in-line view to identify the makes with an average cost greater
		than $40,000. Format the average cost variable to have the dollar9.2 format. 
		Order the average cost from lowest to highest. ************************;
data cars;
set sashelp.cars;
run;

/*reference: https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/sqlproc/n0zncz0umdx2tdn1m6k5tvdqwzed.htm
from (select lname, s.idnum, city, flight, date
               from proclib.schedule2 s, proclib.staff2 t
               where s.idnum=t.idnum)

https://v8doc.sas.com/sashtml/proc/zsqlex11.htm*/

title 'Question 4 Answer';
proc sql;
select make, MSRP
format = dollar9.2
from (select make, avg(MSRP) as MSRP from cars group by make)
where MSRP > 40000
order by MSRP;
quit;



















******* Question 5: Select the records from dataset A where flag = 1 in dataset B. 
		The only variables that should be in the final dataset are ID and weight. ;
data A;
input ID weight @@;
datalines;
1	180	1	175	1	178	2	190	3	150	3	150	3	151	4	250	4	230	5	100	5	105
6	280	7	120	8	235	8	230
;
run;	

data B;
input ID flag V1 V2;
datalines;
1	1	5	0
2	0	2	-1
3	1	3	-5
4	1	2	2
5	1	1	1
6	0	0	3
7	0	5	8
8	1	3	10
;
run;

title 'Question 5 Answer';
proc sql;
select * from A 
where ID in (select ID from B where flag = 1);
quit;




























******* Question 6: Use the LIKE operator with PROC SQL
		(documentation: https://documentation.sas.com/?docsetId=sqlproc&docsetTarget=n1ege2983n6h0vn1s1uj1459phr9.htm&docsetVersion=9.4&locale=en)
		to query all records where the resident lives on an AVENUE that starts with "D"
		(e.g. 17 DOG AVENUE and 18 DUCK AVENUE should be queried, but not 4 DOLPHIN PLACE or 91 CAT AVENUE);





data residency;
input name $ 1-9 address $ 17-32;
datalines;
ANDREW			17 DOG AVENUE
KYLE			91 CAT AVENUE
SAMANTHA		4 DOLPHIN PLACE
ALLISON			18 DUCK AVENUE
TINA			91 FROG STREET
SHAUN			30 DINGO AVENUE
PARKER			1 PARK STREET
;
run;


/*reference: https://sascrunch.com/like-operator/*/


title 'Question 6 Answer';
proc sql;
select * from residency
where address like "%D%";
quit;





























******* Question 7: The demo dataset below provides basic demographic information of several employees and
					the payroll dataset contains their salary information. Some employees erroneously
					have multiple salary values in payroll. Identify the patients with duplicate
					salary information and pull their rows from the demo dataset USING ONE PROC SQL
					CALL. Do not do this in two separate PROC SQLs. ************************;
data demo;
input ID age sex $ @@;
datalines;
1 23 F	2 46 F	3 24 M	5 35 F	6 42 M	7 37 M
;
run;

data payroll;
input ID salary @@;
format salary dollar11.2;
datalines;
1 84130	1 80000	2 71520	3 97410	4 84000	6 78490 6 75600	7 98500
;
run;


/*ref: https://stackoverflow.com/questions/17149784/keeping-only-the-duplicates*/

title 'Question 7 Answer';
proc sql;
select * from demo
where ID in (select ID from payroll having count(ID) > 1);
quit;






























******* Question 8: Group the MSRP variable in the cars dataset into 
		<20,000, 20,000 - <40,000, 40,000 - <60,000, and 60,000+. 
		Apply a readable format to the grouped MSRP variable ***************;
data cars;
set sashelp.cars;
run;

title 'Question 8 Answer';
**proc sql;
**select MSRP from cars
**group by MSRP;
**quit;
******* Question 9: Using the dataset you created in Question 8, report the number 
		of cars in each MSRP group **********************************************;


************Not Sure How to do these two!************

























******* Question 10: Using the cars dataset, create a variable that indicates 
		if the car has efficient gas mileage on the highway (defined as MPG_Highway > 35). 
		Only keep cars that meet that criteria. DO THIS ALL IN ONE PROC SQL. *********;
data cars;
set sashelp.cars;
run;
title 'Question 10 Answer';
proc sql;
select Make, Model, MPG_Highway from cars 
where MPG_Highway > 35
group by MPG_Highway;
quit;




******* Question 11:  Using the dataset you created in Question 10, 
		select the unique makes that have at least one car that is fuel efficient. ;
title 'Question 11 Answer';
proc sql;
select distinct Make from (select Make, Model, MPG_Highway from cars 
where MPG_Highway > 35
group by MPG_Highway);
quit;






******* Question 12: How long did it take you to complete this assignment? ********************;

********About 3 hours********


******* Question 13: With 1 being the easiest and 10 being the hardest, how difficult did you
		find this assignment? ****************************************************************;

********10 and 11 easy (similar as previous), 8 and 9 hard********
********SAS skill got rusty now, take some times to recap********


******* Question 14: Any other additional feedback? *******************************************;
