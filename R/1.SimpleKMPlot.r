#############################################################
# Project       : PhUSE 2022, Belfast
#                 Hands-On-Workshop 
# Author        : Kriss Harris & Endri Elnadav
# Date          : 16/11/2022
# File          : 01_SimpleKMPlot.r
# Purpose       : Generation of simple KM Plot using R
#                 - Download data from phuse github 
#                   https://github.com/phuse-org/phuse-scripts/blob/master/data/adam/TDF_ADaM_v1.0.zip
#                 - Unzip the file and Update the data path below
#                 - Remove the single # to play with the functionality
#                 - for help, type in console for example: ?read_xpt or ?ggsurvplot
#############################################################


###### Including the packages
library(survival)
library(haven)

###### Define data path (update needed)
data_path <- "C:/Temp/PhUSE 2022 - HoW/data/TDF_ADaM_v1.0/adtte.xpt"

###### read ADaM dataset
###### Example used from github: TDF_ADaM_v1.0
data_adtte <- read_xpt(data_path)

######  "PROC LIFETEST" in R 
calc_surv <- survfit(Surv(AVAL, CNSR)~TRTA, data= data_adtte)
#summary(calc_surv)

plot(calc_surv,
     xlab  = "Time",
     ylab  = "Survival Probability",
     main  = "KM Plot",
    )

