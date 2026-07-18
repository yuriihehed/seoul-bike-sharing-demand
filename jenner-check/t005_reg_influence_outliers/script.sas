/* Rebuilds Yurii's bike_data from a representative sample of the project's
   SeoulBikeSharing.csv (all four seasons + holiday + non-functioning rows,
   so the dummy variables carry real variance). Column names match what the
   project's PROC IMPORT step produces from the CSV header. */
data bike_data;
    length Date $10 Seasons $8 Holiday $12 Functioning_Day $3;
    infile datalines dsd truncover;
    input Date $ Rented_Bike_Count Hour Temperature Humidity Wind_speed
          Visibility Dew_point_temperature Solar_Radiation Rainfall Snowfall
          Seasons $ Holiday $ Functioning_Day $;
    datalines;
28/01/2018,30,6,-7.8,35,1.9,2000,-20.6,0,0,0,Winter,No Holiday,Yes
7/5/2018,1970,14,24.1,42,1.2,1770,10.3,1.93,0,0,Spring,No Holiday,Yes
12/6/2018,2505,21,20.6,70,1.8,1986,14.9,0,0,0,Summer,No Holiday,Yes
6/11/2018,0,15,16.3,54,1.6,374,6.9,0.76,0,0,Autumn,No Holiday,No
15/08/2018,563,12,36.5,41,1.1,1807,21.1,2.73,0,0,Summer,Holiday,Yes
28/02/2018,72,4,5.4,56,1.7,472,-2.6,0,0,0,Winter,No Holiday,Yes
8/3/2018,757,17,7.5,64,4.3,538,1.1,0.88,0,0,Spring,No Holiday,Yes
15/06/2018,2460,17,26.1,45,1.4,2000,13.2,1.26,0,0,Summer,No Holiday,Yes
26/10/2018,576,15,14,87,1.2,1482,11.8,0.68,1,0,Autumn,No Holiday,Yes
2/1/2018,273,22,-3.4,33,2.4,2000,-17.4,0,0,0,Winter,No Holiday,Yes
12/5/2018,34,16,13.8,97,0.7,196,13.3,0.12,1.5,0,Spring,No Holiday,Yes
8/6/2018,255,4,18.5,82,2,1072,15.3,0,0,0,Summer,No Holiday,Yes
11/11/2018,574,9,7.8,72,1.2,360,3,0.54,0,0,Autumn,No Holiday,Yes
25/09/2018,1885,18,21.6,37,1,2000,6.2,0.24,0,0,Autumn,Holiday,Yes
21/12/2017,316,15,4.4,46,1.4,1113,-6.2,0.78,0,1,Winter,No Holiday,Yes
29/05/2018,466,2,20.2,56,2.3,1498,0,0,0,0,Spring,No Holiday,Yes
8/8/2018,687,15,34.5,47,3.2,1958,21.5,2.32,0,0,Summer,No Holiday,Yes
7/10/2018,189,6,14.8,89,0.2,1490,12.9,0,0,0,Autumn,No Holiday,Yes
12/12/2017,184,10,-10.5,45,3.3,1855,-20.1,0.6,0,0,Winter,No Holiday,Yes
19/04/2018,996,14,20.5,17,3.1,1512,-5.4,2.83,0,0,Spring,No Holiday,Yes
30/08/2018,846,9,25,92,1.1,782,23.6,0.39,0,0,Summer,No Holiday,Yes
1/10/2018,1501,22,13.9,69,0.5,2000,8.2,0,0,0,Autumn,No Holiday,Yes
25/09/2018,1747,15,24.1,26,1.6,2000,3.3,2.38,0,0,Autumn,Holiday,Yes
17/02/2018,183,12,-1.3,17,1.5,1998,-23.2,2.28,0,0,Winter,Holiday,Yes
15/03/2018,214,16,10.7,98,1.2,196,10.3,0.14,0,0,Spring,No Holiday,Yes
2/6/2018,1334,13,29.6,24,2.4,1873,6.8,3.42,0,0,Summer,No Holiday,Yes
15/11/2018,942,12,13.8,43,0.9,987,1.4,1.61,0,0,Autumn,No Holiday,Yes
18/02/2018,22,5,-4,28,0.5,2000,-19.8,0,0,0,Winter,No Holiday,Yes
12/3/2018,581,12,11.7,32,1.6,690,-4.4,1.99,0,0,Spring,No Holiday,Yes
31/07/2018,582,10,32.7,43,1.2,2000,18.4,2.31,0,0,Summer,No Holiday,Yes
1/10/2018,1777,21,14.6,66,4,2000,8.3,0,0,0,Autumn,No Holiday,Yes
24/09/2018,1442,17,21.6,32,3.1,2000,4.1,1.2,0,0,Autumn,Holiday,Yes
23/02/2018,312,14,7.8,57,2.1,277,-0.2,1.39,0,0,Winter,No Holiday,Yes
25/04/2018,536,0,8.9,55,0.7,2000,0.3,0,0,0,Spring,No Holiday,Yes
14/08/2018,643,6,27.8,71,0.1,2000,22,0,0,0,Summer,No Holiday,Yes
26/10/2018,1882,18,13.1,74,1.6,1989,8.5,0.05,0,0,Autumn,No Holiday,Yes
15/02/2018,134,21,-1.1,32,2.4,2000,-15.7,0,0,0,Winter,Holiday,Yes
17/04/2018,406,6,6.9,57,0.5,1775,-1,0,0,0,Spring,No Holiday,Yes
27/08/2018,47,6,20.6,98,0.7,626,20.2,0,1,0,Summer,No Holiday,Yes
3/10/2018,1594,21,17.6,59,1.6,2000,9.4,0,0,0,Autumn,Holiday,Yes
22/12/2017,250,1,-1.6,79,0.6,784,-4.7,0,0,0.8,Winter,Holiday,Yes
2/1/2018,41,3,-2.5,62,0.4,1626,-8.7,0,0,0,Winter,No Holiday,Yes
11/4/2018,0,10,13.3,51,4.1,1487,3.3,2.17,0,0,Spring,No Holiday,No
21/07/2018,727,13,35.2,34,1.8,1636,16.9,3.21,0,0,Summer,No Holiday,Yes
2/10/2018,0,16,21.7,36,3.2,1929,5.9,1.64,0,0,Autumn,No Holiday,No
3/1/2018,130,1,-5,42,1.2,1993,-15.9,0,0,0,Winter,No Holiday,Yes
6/4/2018,585,16,6.6,50,4,645,-3.1,0.81,0,0,Spring,No Holiday,Yes
16/06/2018,1861,15,27.8,41,1.6,1851,13.3,2.89,0,0,Summer,No Holiday,Yes
5/10/2018,66,17,16.9,97,2.1,728,16.4,0.08,5.5,0,Autumn,No Holiday,Yes
25/09/2018,132,6,11.2,70,0.9,2000,5.9,0,0,0,Autumn,Holiday,Yes
5/2/2018,170,14,-6.4,24,4.6,1970,-23.7,2.23,0,0,Winter,No Holiday,Yes
25/04/2018,148,5,6,63,0.5,1984,-0.5,0,0,0,Spring,No Holiday,Yes
18/07/2018,1308,7,24.2,74,0.7,656,19.2,0.35,0,0,Summer,No Holiday,Yes
18/10/2018,165,4,8.1,78,0.6,2000,4.4,0,0,0,Autumn,No Holiday,Yes
1/1/2018,248,13,2.4,22,2.3,1921,-17.2,1.1,0,0,Winter,Holiday,Yes
24/05/2018,2081,8,15.2,50,1.6,1530,4.8,1.1,0,0,Spring,No Holiday,Yes
20/07/2018,1029,9,28.4,65,1.2,806,21.1,1.69,0,0,Summer,No Holiday,Yes
28/11/2018,681,13,9.2,13,1.6,1776,-17.8,1.86,0,0,Autumn,No Holiday,Yes
9/11/2018,0,7,10.4,81,3,1741,7.2,0,0,0,Autumn,No Holiday,No
19/02/2018,50,4,-1.9,44,0.7,1907,-12.5,0,0,0,Winter,No Holiday,Yes
9/5/2018,3130,18,20.6,41,2.3,2000,6.8,1.1,0,0,Spring,No Holiday,Yes
3/7/2018,2965,18,32.2,57,1.8,1880,22.5,1.53,0,0,Summer,No Holiday,Yes
22/11/2018,777,20,3.1,42,2.4,2000,-8.5,0,0,0,Autumn,No Holiday,Yes
8/2/2018,126,1,-8.5,60,1.2,1908,-14.8,0,0,0,Winter,No Holiday,Yes
30/03/2018,1406,8,11.5,60,1.6,550,3.9,0.42,0,0,Spring,No Holiday,Yes
21/06/2018,1473,16,28.5,42,3.1,1622,14.3,2.62,0,0,Summer,No Holiday,Yes
20/09/2018,761,1,20,59,1.1,1999,11.7,0,0,0,Autumn,No Holiday,Yes
9/11/2018,0,11,13.3,59,4.1,1970,5.4,1.43,0,0,Autumn,No Holiday,No
27/02/2018,102,3,1.1,44,1,1128,-9.8,0,0,0,Winter,No Holiday,Yes
21/03/2018,223,1,1.5,40,2.8,2000,-10.6,0,0,0,Spring,No Holiday,Yes
;
run;

*Part B — dummy variables (from the project preparation step);
data bike_data;
    set bike_data;
    if Seasons in ("Summer", "Spring") then d_Warm_Season = 1; else d_Warm_Season = 0;
    if Seasons in ("Winter", "Autumn") then d_Cold_Season = 1; else d_Cold_Season = 0;
    if Holiday = "Holiday" then d_Holiday_Flag = 1; else d_Holiday_Flag = 0;
    if Functioning_Day = "Yes" then d_Functioning_Flag = 1; else d_Functioning_Flag = 0;
run;

* Adding a unique identifier to each observation;
data bike_data;
    set bike_data;
    obs_id = _n_;
run;

title "Influential Points and Diagnostics";
proc reg data=bike_data;
    model Rented_Bike_Count = Temperature Humidity Wind_speed Solar_Radiation Rainfall d_Warm_Season d_Holiday_Flag d_Functioning_Flag / vif influence r;
    output out=residuals p=predicted r=resid student=student_resid cookd=cookd h=leverage;
run;
quit;

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
