OPTIONS VALIDVARNAME = UPCASE; 

%*****************************************************************************;
%* Get ADTTE data; 
%*****************************************************************************;
%LET _path = C:\temp; 
libname sasfile       "&_path.";
libname xptfile xport "&_path.\adtte.xpt" access=readonly;

proc copy inlib=xptfile outlib=sasfile;
run;

%*****************************************************************************;
%* PROC LIFETEST; 
%*****************************************************************************;
ODS OUTPUT ProductLimitEstimates = calc_010_est; 
PROC LIFETEST DATA     = sasfile.adtte 
              ATRISK; 
    TIME aval * CNSR (0); 
    STRATA trta; 
RUN; 
ODS OUTPUT CLOSE; 

%*****************************************************************************;
%* Preparing data for Output; 
%*****************************************************************************;
%* keep last records by aval; 
DATA calc_020_prep; 
  SET calc_010_est; 
  IF NOT MISSING(numberatrisk); 
RUN; 

%* expand data; 
PROC SQL;
  CREATE TABLE calc_030_matrix1 AS 
  SELECT DISTINCT stratum, trta
  FROM calc_020_prep; 
QUIT; 

%* Hardcoding AVAL - just for example.; 
%* Please check in real study!; 
DATA calc_030_matrix2; 
  SET calc_030_matrix1; 
  DO aval = 1 TO 210; 
     OUTPUT; 
  END; 
RUN; 

%* Merge with result; 
DATA calc_035_join; 
  MERGE calc_030_matrix2
        calc_010_est; 
  BY stratum trta aval; 
RUN; 

%* Retain SURVIVAL value over the time; 
%* Retain NUMBERATRISK value over the time; 
DATA calc_040_ret; 
  SET calc_035_join; 
  BY stratum trta; 
  RETAIN temp_survival
         temp_numberatrisk; 
  IF FIRST.TRTA THEN DO; 
     temp_survival      = survival; 
     temp_numberatrisk  = numberatrisk; 
  END; 
  ELSE DO; 
     IF MISSING(survival) THEN survival      = temp_survival; 
                          ELSE temp_survival = survival; 

     IF MISSING(numberatrisk) THEN numberatrisk      = temp_numberatrisk; 
                              ELSE temp_numberatrisk = numberatrisk; 
  END; 

  IF missing(censor) THEN censor = 0; 
RUN; 


%*****************************************************************************;
%* Export to XPT; 
%*****************************************************************************;
DATA sasfile.lf_est; 
  SET calc_040_ret; 
  DROP temp_:; 
  RENAME numberatrisk   = risk; 
  RENAME observedevents = obsev; 
RUN; 

LIBNAME sasxpt XPORT "&_path\lf_est.xpt"; 
PROC COPY IN  = sasfile
          OUT = sasxpt; 
  SELECT lf_est;  
RUN; 
LIBNAME sasxpt CLEAR; 




