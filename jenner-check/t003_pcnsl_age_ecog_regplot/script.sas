/* Scatter plot with regression line: Age vs ECOG_PS */
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
