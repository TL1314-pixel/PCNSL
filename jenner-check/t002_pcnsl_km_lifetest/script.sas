* report one figure showing Kaplan-Meier survival curve of
overall survival (variables "os_mo" and "os_event") by EBER group ;
ods graphics on/reset = all imagefmt = png
imagename = "KM_Curve";

* time-to-event variable vs. categorical variable ;
ods select Survivalplot;

proc lifetest data = final.final1
  plots = survival(atrisk(outside maxlen = 13) test);
  time os_mo*os_event(0);
  strata EBER;
run;

ods graphics off;
