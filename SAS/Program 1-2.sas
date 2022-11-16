/****************************************************************************************
Program:          Program 1-2.sas
SAS Version:      SAS 9.4M3
Developer:        Kriss Harris and Endri Elnadav
Date:             2022-11-11
Purpose:          Used to create the Log-Rank Dataset for SAS® Graphics HoW. 
Operating Sys:    Windows 7
Macros:           NONE
Input:            adam.adtteeff 
Output:           Output 1-2.png
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

ods listing image_dpi=300 style = customsapphire gpath = "&outputpath";
ods graphics / reset = all imagename = "Output 1-2" height = 3.33in width = 5in;

ods output SurvivalPlot = SurvivalPlot;
ods output HomTests = HomTests(where=(test="Log-Rank"));
proc lifetest data = adam.adtteeff plots=survival(atrisk=0 to 210 by 30);
   time aval * cnsr(1);
   strata trtpn;
run;
