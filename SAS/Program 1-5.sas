/****************************************************************************************
Program:          Program 1-5.sas
SAS Version:      SAS 9.4M3
Developer:        Kriss Harris and Endri Elnadav 
Date:             2022-11-11
Purpose:          Used to create the subgroup Forest Plot for SAS® Graphics HoW. 
Operating Sys:    Windows 7
Macros:           NONE
Input:            tfldata.HazardRatios_Subgroup_All
Output:           Output 5-7.png
Comments:         Use CustomSapphire style that was provided by SAS press
                  Note CustomSapphire is not provided with SAS but rather created 
                  specifically for SAS Press books
----------------------------------------------------------------------------------------- 
****************************************************************************************/

/*******************************************/
/*** BEGIN SECTION TO BE UPDATED BY USER ***/
/*******************************************/
*Including Custom Sapphire Style;
%include "/home/krissharris/sasgtl/styles/CustomSapphire.sas";
%let outputpath = /home/krissharris/sasgtl/tfl/output;
libname adam "/home/krissharris/sasgtl/adam/data";

/*****************************************/
/*** END SECTION TO BE UPDATED BY USER ***/
/*****************************************/

/*
proc sort data = tfldata.HazardRatios_Subgroup_All out = HazardRatios_Subgroup_All;
   by ord ord2 original_order; 
run;
*/
proc sort data = HazardRatios_Subgroup_All;
   by ord ord2 original_order; 
run;

proc template;
   define statgraph forestplotsubgrouptemplate;
      begingraph;

	  discreteattrmap name="factortext";
	     value "Yes" / textattrs=(weight=bold);
		 value "No" / textattrs=(weight=normal);
	  enddiscreteattrmap;
	  discreteattrvar attrvar=factortext var=factor attrmap="factortext";

	  layout overlay / xaxisopts=(type=log logopts=(base=2 tickintervalstyle=logexpand viewmin= 0.0625 viewmax=16) label="Hazard Ratio" tickvalueattrs=(size=8pt) labelattrs=(size=9pt))
                       yaxisopts=(reverse=true display=(line) label="Interventions" tickvalueattrs=(size=8pt) labelattrs=(size=9pt));

	     innermargin / align=left;
	        axistable y = variable value=variable / display=(values) indentweight=indent textgroup=factortext;
	     endinnermargin;

         highlowplot y=variable low=WaldLower high=WaldUpper;

		 scatterplot y=variable x=HazardRatio / markerattrs=(symbol=squarefilled) markersizeresponse=n ; 

         referenceline x=1 / lineattrs=(pattern=2);

         layout gridded / Border=false halign=left valign=bottom;
            layout gridded;
               entry halign=left "Xanomeline high dose is better" / textattrs=(size=5);
            endlayout;
         endlayout;

         layout gridded / border=false halign=right valign=bottom;
            layout gridded;
               entry halign=left "Placebo is better" / textattrs=(size=5);
            endlayout;
         endlayout;

	  endlayout;
      endgraph;
   end;
run;

ods listing image_dpi=300 style = customsapphire gpath = "&outputpath";
ods graphics / reset=all imagename="Output 1-5" height=3.33in width=5in;

title1 'Product-Limit Survival Estimates';
title2 'With Number of Subjects at Risk';

proc sgrender data = Hazardratios_subgroup_all template = forestplotsubgrouptemplate;
   where description = "TRTPN High Dose vs Placebo";
run;

ods listing close;