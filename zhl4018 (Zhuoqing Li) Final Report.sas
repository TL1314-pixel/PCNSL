/*=== Report all contents (tables, graphics etc.) in one rtf file: ===*/

ods rtf file = "/home/u63877896/SAS class 2025 fall/Final-term/
zhl4018 (Zhuoqing Li) Final Report.rtf" image_dpi = 300
STARTPAGE=no; *style=journal;

OPTIONS center ORIENTATION = portrait;
/* If used 'landscape', will also need to change 'orientation=portrait' to 'landscape'
   in each '%tablen' run so it would not start a new page for each table */

ods escapechar='^'; /* Need this first and must use '^' because it used with the Macro! */
title; /* this will remove "SAS System" title */
options center;
ods noproctitle; /* will remove Proc title */

* Titles ;
ods rtf text = "^S={just=center font=('arial', 12pt)}  ";
ods rtf text = "^S={font = ('arial',16pt, bold) just = center}
{My Final-term project for SPS 2025}"; 

ods rtf text = "^S={just=center font=('arial', 11pt)}  ";
ods rtf text = "^S={font = ('arial',11pt) just = center}
{[by: Zhuoqing Li(zhl4018)]}";

ods rtf text = "^S={font = ('arial', 10pt) just = center color = red}
{Last updated on: 02DEC25}";

* Introduction ;

ods rtf text = "^S={just=center font=('arial', 11pt)}  ";
ods rtf text = "^S={just=center font=('arial', 11pt)}  ";
ods rtf text = "^S={font = ('arial', 15pt, bold) just = left}
{Introduction:}";
ods rtf text = "^S={font = ('arial', 11pt) just = left 
fontstyle = italic}{    This is the TFL (Table, Figure, Listing) report for 
Bivariate association with EBER, the report includes the table of original 
'final_clean' data, quick summary of each variable by EBER groups (Table-1) 
one figure showing Kaplan-Meier survival curve of overall survival by EBER group, 
a table shows spearman correlation coefficient and a regression plot between Age and ECOG_PS.}";

* Dataset ;
ods rtf text = "^S={just=center font=('arial', 11pt)}  ";
ods rtf text = "^S={font = ('arial', 15pt, bold) just = left}
{Dataset:}";
ods rtf text = "^S={font = ('arial', 11pt) just = left color = red 
fontstyle = italic}{    final_clean.sas7bdat.[Note:cleaned data from mid-term project]}";

* Methods ;
ods rtf text = "^S={just=center font=('arial', 11pt)}  ";
ods rtf text = "^S={font = ('arial', 15pt, bold) just = left}
{Methods:}";
ods rtf text = "^S={font = ('arial', 11pt) just = left  
fontstyle = italic}{    The summary table (table-1) is generated through TABLEN SAS Macro, 
which includes Age, Sex, ECOG_PS, Overall Survival Event, Overall Survival (months) by EBER 
group, the overall survival analysis by EBER group is using Kaplan-Meier survival curve, the 
correlation analysis (table-2) is performed through Sparman Correlation Coefficient between 
Age and ECOG_PG, then a regression plot is generated as well.}";
ods rtf text = "^S={font = ('arial', 11pt) just = left fontstyle = italic}
{All analyses were performed in SAS9.4.}";

* Results ;
ods rtf text = "^S={just=center font=('arial', 11pt)}  ";
ods rtf text = "^S={font = ('arial', 15pt, bold) just = left}
{Results:}";

* create a library contains the final data;
libname final "/home/u63877896/SAS class 2025 fall/Final-term";

* 2.1 produce a table contains the first 10 patients in 
the final data ;
ods rtf text = "^S={just=center font=('arial', 11pt)}  ";
ods rtf text = "^S={font = ('arial', 14pt, bold) just = center}
{List of the first 10 patients}";
ods select all;

proc print data = final.final_clean (obs=10 keep = 
"Patient ID"n Age Sex ECOG_PS EBER os_event os_mo) label;
label os_event = "Overall Survival Event" 
      OS_mo = "Overall Survival (months)";
run;

* 2.2 produce table 1 using the provided SAS Macro ;
/*--- Use tablen SAS Macro for Tables: ---*/

/* Run this macro in the back: */
%include "/home/u63877896/SAS class 2025 fall/Final-term/
TABLEN_web_20210718 _ZChen.sas";
ods select report(persist);

* remove missing value in EBER variable ;
data final.final1;
set final.final_clean;
if not missing(EBER);
run;

* table 1 ;
ods rtf startpage=now;                                                                        
ods rtf text = "^S={font = ('arial',14pt, bold) just = center}
{Table-1}"; 
 
%tablen(
  DATA = final.final1,
  VAR = Age Sex ECOG_PS os_event os_mo,
  /* just want to change the default label for 'FTIME' variable: */
  labels=  | | | Overall Survival Event | Overall Survival (months) ,
  TYPE = 1 2 1 1 4 ,
  BY = EBER,
  pvals = 3 2 0 0 1 ,
  contdisplay = n_nmiss mean_sd median_range median_IQR, 
  /* 'event' variable name: */
  SURV_STAT = os_event,
  /* censoring value: */
  CEN_VL = 0,
  /* time was in 'day' so need to convert to 'year': */
  TDIVISOR = 365.25,
  /* specify this is in year: */
  TIME_UNITS = year
);

* 2.3 report one figure showing Kaplan-Meier survival curve of 
overall survival (variables "os_mo" and "os_event") by EBER group ; 

/*--- Want to include plot in report as well: ---*/ 
ods graphics on/reset = all imagefmt = png 
imagename = "KM_Curve";                                                                      
ods rtf startpage=now;
ods rtf text = "^S={just=center font=('arial', 11pt)}  ";
ods rtf text = "^S={just=center font=('arial', 11pt)}  ";
ods rtf text = "^S={font = ('arial',14pt, bold) just = center}
{Figure: Kaplan-Meier curve by EBER group}"; 
 
* time-to-event variable vs. categorical variable ;
ods select Survivalplot;

proc lifetest data = final.final1 
  plots = survival(atrisk(outside maxlen = 13) test);
  time os_mo*os_event(0);
  strata EBER;
run;

ods select all;
ods graphics off;

* 2.3 produce table-2 using the provided SAS Macro;
/*------------ Call the Macro: ----------------------------------------------*/
%include "/home/u63877896/SAS class 2025 fall/Final-term/
Correlation analysis and reporting SAS Macro -CorrReport.sas";

ods rtf startpage=now;
ods rtf text = "^S={font = ('arial',14pt, bold) just = center}
{Table-2: Spearman correlation coefficient}"; 

ods select Report(persist);
 
/* with smaller sample (note how the r and 95% CI band of regression line change): */
/* Also want to change the axis labels: */
%CorrReport(dataset=final.final1, V1=Age, V2=ECOG_PS,
           type="pearson",
           plot="regression",
           V1Label="Age", V2Label="ECOG_PS",
           legendPosition=bottomright);

/*--- Want to include plot in report as well: ---*/                                                                        
ods rtf startpage=now; 

ods select Report(persist);
/* Scatter plot with regression line: */
ods graphics on;
Proc sgplot data = final.final1; 
  reg  x=ECOG_PS y=Age
    /name='reg'
     CLM 
     lineAttrs =(color=red thickness=2)
     markerAttrs =(size=8 color=black
        symbol=circlefilled)
     clmTransparency =0.5;
run;

/*--- Close ods rtf output ----*/
ods rtf close;
/*=== End of report ===========*/