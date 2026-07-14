/* PCNSL Final Report — "List of the first 10 patients" table.
   The report's PROC PRINT of final.final_clean (keep list + survival labels).
   A 24-row inline stand-in for final_clean is built here so this step runs
   on its own (the report's own libname pointed at a SAS Studio path). */
libname final (work);

data final.final_clean;
  length "Patient ID"n $8 Sex $1 EBER $5;
  input "Patient ID"n $ Age Sex $ ECOG_PS EBER $ os_event os_mo;
  label os_event = "Overall Survival Event"
        os_mo    = "Overall Survival (months)";
datalines;
PT001 68 M 1 EBER+ 1 14.2
PT002 55 F 0 EBER- 0 40.1
PT003 72 M 2 EBER+ 1 8.5
PT004 61 F 1 EBER- 1 26.7
PT005 49 M 0 EBER- 0 52.3
PT006 77 F 3 EBER+ 1 3.9
PT007 63 M 1 EBER- 0 38.4
PT008 58 F 2 EBER+ 1 19.0
PT009 70 M 1 EBER- 1 22.8
PT010 66 F 0 EBER- 0 45.6
PT011 74 M 2 EBER+ 1 11.3
PT012 52 F 1 EBER- 0 48.9
PT013 80 M 3 EBER+ 1 2.5
PT014 47 F 0 EBER- 0 55.2
PT015 69 M 1 EBER+ 1 16.7
PT016 60 F 1 EBER- 1 30.4
PT017 65 M 2 EBER+ 1 9.8
PT018 57 F 0 EBER- 0 43.1
PT019 71 M 1 EBER- 1 24.5
PT020 54 F 2 EBER+ 1 13.6
PT021 62 M 1 EBER- 0 37.0
PT022 76 F 3 EBER+ 1 5.1
PT023 50 M 0 EBER- 0 50.8
PT024 67 F 1 EBER+ 1 18.2
;
run;

* 2.1 produce a table contains the first 10 patients in
the final data ;
proc print data = final.final_clean (obs=10 keep =
"Patient ID"n Age Sex ECOG_PS EBER os_event os_mo) label;
label os_event = "Overall Survival Event"
      OS_mo = "Overall Survival (months)";
run;
