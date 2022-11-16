/****************************************************************************************
Program:          Exercise 1-3.sas
SAS Version:      SAS 9.4M3
Developer:        Kriss Harris and Endri Elnadav
Date:             2022-11-11
Purpose:          Used to create the Survival plot using ODS Output for SAS® Graphics HoW. 
Operating Sys:    Windows 7
Macros:           NONE
Input:            adam.adtteeff 
Output:           Exercise 1-3
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

proc format;
value $trt
  "0" = "Placebo"
  "54" = "Low Dose"
  "81" = "High Dose";
run;

proc template;
   define statgraph kmtemplate;
      begingraph;
      	 layout lattice / rows=2 rowweights=preferred;
      	 
	        layout XXXXXX;
               stepplot x = time y = survival / group = stratum name="Survival";
	           scatterplot x=time y = censored / markerattrs=(symbol=plus) group=stratum;            
               discretelegend "Survival";      
	        endlayout;
	        
            layout XXXXXX;
               axistable value=XXXXX x=tatrisk / class=stratum colorgroup=stratum;		 
	        endlayout;
	        
	     endlayout;
      endgraph;
   end;
run;

ods listing image_dpi=300 style = customsapphire gpath = "&outputpath";
ods graphics / reset=all imagename="Exercise 1-3" height=3.33in width=5in;

title1 'Product-Limit Survival Estimates';

proc sgrender data = KMDataset template = kmtemplate;
   format stratum $trt.;
run;

ods listing close;