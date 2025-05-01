*Student: Yurii Hehediush
Instructor: Nandhini Gulasingam
DSC 323
Final Project: Seoul Bike Sharing Demand Analysis
Linear Regression
May 31 2024;

*Part A:  "The Begining" 
It is crucial to note that methodology includes all meanings such as Celsius for Temperature
and other forms of measurements for variables


Importing data;

proc import datafile="SeoulBikeSharing.csv"
    out=bike_data
    dbms=csv
    replace;
    getnames=yes;
    delimiter=',';
run;

title "Initial Data Sample";
proc print data=bike_data (obs=10);
run;

*Part B;
title "Data Cleaning and Preparation";
data bike_data;
    set bike_data;
    * Creating dummy variables for warm and cold easons;
    if Seasons in ("Summer", "Spring") then d_Warm_Season = 1; else d_Warm_Season = 0;
    if Seasons in ("Winter", "Autumn") then d_Cold_Season = 1; else d_Cold_Season = 0;

    * Creating Dummy Variables for Holiday and Functioning Day;
    if Holiday = "Holiday" then d_Holiday_Flag = 1; else d_Holiday_Flag = 0;
    if Functioning_Day = "Yes" then d_Functioning_Flag = 1; else d_Functioning_Flag = 0;
run;


title "Data with Dummy Variables";
proc print data=bike_data (obs=10);
run;
*Part C;
title "Summary Statistics";
proc means data=bike_data n mean std min max;
    var Temperature Humidity Wind_speed Visibility Dew_point_temperature Solar_Radiation Rainfall Snowfall;
run;

*Part D Exploring Data;
* Excluding dummy variables to avoid any confusinns with data;
title "Correlation Analysis";
proc corr data=bike_data;
    var Rented_Bike_Count Temperature Humidity Wind_speed Visibility Dew_point_temperature Solar_Radiation Rainfall Snowfall;
run;

title "Histogram of Rented Bike Count";
proc sgplot data=bike_data;
    histogram Rented_Bike_Count;
    density Rented_Bike_Count / type=normal;
run;

title "Scatter Plot Matrix";
proc sgscatter data=bike_data;
    matrix Rented_Bike_Count Temperature Humidity Wind_speed Visibility Dew_point_temperature Solar_Radiation Rainfall Snowfall;
run;

*Part E;
title "Initial Regression Model";
proc reg data=bike_data;
    model Rented_Bike_Count = Temperature Humidity Wind_speed Visibility Dew_point_temperature Solar_Radiation Rainfall Snowfall d_Warm_Season d_Cold_Season d_Holiday_Flag d_Functioning_Flag;
run;

*Part F;
title "Multicollinearity Check";
proc reg data=bike_data;
    model Rented_Bike_Count = Temperature Humidity Wind_speed Visibility Dew_point_temperature Solar_Radiation Rainfall Snowfall d_Warm_Season d_Cold_Season d_Holiday_Flag d_Functioning_Flag / vif tol;
run;

title "Influential Points and Diagnostics";
proc reg data=bike_data;
    model Rented_Bike_Count = Temperature Humidity Wind_speed Visibility Dew_point_temperature Solar_Radiation Rainfall Snowfall d_Warm_Season d_Cold_Season d_Holiday_Flag d_Functioning_Flag / vif influence r;
    output out=residuals p=predicted r=resid student=student_resid cookd=cookd h=leverage;
run;

title "Studentized Residuals vs. Predicted Values";
proc sgplot data=residuals;
    scatter x=predicted y=student_resid;
    refline 0 / axis=y;
run;

title "Normal Q-Q Plot of Studentized Residuals";
proc univariate data=residuals normal;
    qqplot student_resid / normal;
run;

title "Identifying Influential Points and Outliers";
proc sql noprint;
    select count(*) into :n from residuals;
quit;

data influential_points;
    set residuals;
    if cookd > 4/&n or abs(student_resid) > 3 or leverage > 2*(13/&n);
run;

title "Influential Points and Outliers";
proc print data=influential_points;
    var Rented_Bike_Count cookd student_resid leverage;
run;

**Part G: Removing Insignificant Predictors;
* Based on the anylisis output, removing 'Visibility', 'Dew_point_temperature', and 'Snowfall' as they have p-values > 0.05;
title "Refined Regression Model without Insignificant Predictors";
proc reg data=bike_data;
    model Rented_Bike_Count = Temperature Humidity Wind_speed Solar_Radiation Rainfall d_Warm_Season d_Holiday_Flag d_Functioning_Flag / vif influence r;
    output out=residuals_refined p=predicted r=resid student=student_resid cookd=cookd h=leverage;
run;

title "Studentized Residuals vs. Predicted Values for Refined Model";
proc sgplot data=residuals_refined;
    scatter x=predicted y=student_resid;
    refline 0 / axis=y;
run;

title "Normal Q-Q Plot of Studentized Residuals for Refined Model";
proc univariate data=residuals_refined normal;
    qqplot student_resid / normal;
run;


* Adding a unique identifier to each observation;
data bike_data;
    set bike_data;
    obs_id = _n_;
run;

proc reg data=bike_data;
    model Rented_Bike_Count = Temperature Humidity Wind_speed Visibility Dew_point_temperature Solar_Radiation Rainfall Snowfall d_Warm_Season d_Cold_Season d_Holiday_Flag d_Functioning_Flag / vif influence r;
    output out=residuals p=predicted r=resid student=student_resid cookd=cookd h=leverage;
run;


title "Identifying Influential Points and Outliers";
proc sql noprint;
    select count(*) into :n from residuals;
quit;

data influential_points;
    set residuals;
    if cookd > 4/&n or abs(student_resid) > 3 or leverage > 2*(13/&n);
run;

title "Influential Points and Outliers";
proc print data=influential_points;
    var Rented_Bike_Count cookd student_resid leverage obs_id;
run;


title "Removing Influential Points and Outliers";
proc sql;
    create table bike_data_clean as
    select * from bike_data
    where obs_id not in (select obs_id from influential_points);
quit;


title "Cleaned Data without Influential Points and Outliers";
proc print data=bike_data_clean (obs=10);
run;

* Re-runing Refined Model;
title "Refined Regression Model without Outliers and Influential Points";
proc reg data=bike_data_clean;
    model Rented_Bike_Count = Temperature Humidity Wind_speed Solar_Radiation Rainfall d_Warm_Season d_Holiday_Flag d_Functioning_Flag ;
run;
quit;
*Part H Model Selectios / Checking for the Most Sutable Model;

title "Model Selection using Stepwise";
proc reg data=bike_data_clean;
    model Rented_Bike_Count = Temperature Humidity Wind_speed Solar_Radiation Rainfall d_Warm_Season d_Holiday_Flag d_Functioning_Flag / selection=stepwise;
run;

title "Model Selection using Mallow's CP";
proc reg data=bike_data_clean;
    model Rented_Bike_Count = Temperature Humidity Wind_speed Solar_Radiation Rainfall d_Warm_Season d_Holiday_Flag d_Functioning_Flag / selection=cp;
run;

title "Studentized Residuals vs. Predicted Values for Final Model";
proc sgplot data=final_model_residuals;
    scatter x=predicted y=student_resid;
    refline 0 / axis=y;
run;

*Part I: Final Model after Selection Methods;
*Selcting only significant varibles that would improve ourmodel accourding to STEPWISE METHOD;
title "Final Model with STEPWISE Method";
proc reg data=bike_data_clean;
    model Rented_Bike_Count = Temperature Humidity Wind_speed Solar_Radiation Rainfall d_Holiday_Flag d_Warm_Season / vif influence r;
    output out=final_model p=predicted r=residuals;
run;

*Part J: Train-Test Split and Model Training;
title "Train-Test Split for Model Validation";
proc surveyselect data=bike_data_clean out=train_data samprate=0.7 outall seed=2121654;
run;

data train_data test_data;
    set train_data;
    if selected then output train_data;
    else output test_data;
run;

title "Training Data Sample";
proc print data=train_data (obs=10);
run;

title "Testing Data Sample";
proc print data=test_data (obs=10);
run;

title "Model Training on Training Set using Stepwise Selection";
proc reg data=train_data;
    model Rented_Bike_Count = Temperature Humidity Wind_speed Solar_Radiation Rainfall d_Holiday_Flag d_Warm_Season / selection=stepwise;
    output out=train_results p=predicted r=residuals;
run;

*Part K Model Validation;
title "Model Validation on Testing Set";
proc reg data=test_data;
    model Rented_Bike_Count = Temperature Humidity Wind_speed Solar_Radiation Rainfall d_Holiday_Flag d_Warm_Season;
    output out=test_results p=predicted r=residuals;
run;

title "Training Set Performance";
proc means data=train_results mean;
    var predicted;
run;

title "Testing Set Performance";
proc means data=test_results mean;
    var predicted;
run;

title "Studentized Residuals vs. Predicted Values for Training Set";
proc sgplot data=train_results;
    scatter x=predicted y=residuals;
    refline 0 / axis=y;
run;

title "Studentized Residuals vs. Predicted Values for Testing Set";
proc sgplot data=test_results;
    scatter x=predicted y=residuals;
    refline 0 / axis=y;
run;

title "Normal Q-Q Plot of Studentized Residuals for Training Set";
proc univariate data=train_results normal;
    qqplot residuals / normal;
run;

title "Normal Q-Q Plot of Studentized Residuals for Testing Set";
proc univariate data=test_results normal;
    qqplot residuals / normal;
run;

*Part L;
* Final Model using Stepwise;
title "Final Model using Stepwise Selection on Entire Dataset";
proc reg data=bike_data_clean;
    model Rented_Bike_Count = Temperature Humidity Wind_speed Solar_Radiation Rainfall d_Holiday_Flag d_Warm_Season / selection=stepwise;
    output out=final_model p=predicted r=residuals;
run;

* Predictions with Confidence Intervals;
title "Predictions with Confidence Intervals";
data new_data;
    input Temperature Humidity Wind_speed Solar_Radiation Rainfall d_Holiday_Flag d_Warm_Season;
    datalines;
    25 60 3 1.2 0 0 1
    30 55 2 1.8 0 0 1
    ;
run;

proc reg data=bike_data_clean outest=estimates;
    model Rented_Bike_Count = Temperature Humidity Wind_speed Solar_Radiation Rainfall d_Holiday_Flag d_Warm_Season;
run;


proc score data=new_data score=estimates out=predictions type=parms;
    var Temperature Humidity Wind_speed Solar_Radiation Rainfall d_Holiday_Flag d_Warm_Season;
run;

title "Predictions with Confidence Intervals";
proc print data=predictions;
run;



