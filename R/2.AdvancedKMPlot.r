#############################################################
# Project       : PhUSE 2022, Belfast
#                 Hands-On-Workshop 
# Author        : Kriss Harris & Endri Elnadav
# Date          : 16/11/2022
# File          : 2.AdvancedKMPlot1.r
# Purpose       : Generation of advanced KM Plot using R
#                 - Download data from phuse github 
#                   https://github.com/phuse-org/phuse-scripts/blob/master/data/adam/TDF_ADaM_v1.0.zip
#                 - Unzip the file and Update the data path below
#                 - Remove the single # to play with the functionality
#                 - for help, type in console for example: ?read_xpt or ?ggsurvplot
#############################################################

###### Including the packages
library(survival)
library(survminer)
library(haven)

###### Define data path (update needed)
data_path <- "C:/Temp/CDISC Test Data/TDF_ADaM_v1.0/adtte.xpt"

###### read ADaM dataset
###### Example used from github: TDF_ADaM_v1.0
data_adtte <- read_xpt(data_path)


###### "PROC LIFETEST" in R 
calc_surv <- survfit(Surv(AVAL, CNSR)~TRTA, data= data_adtte)
calc_plot <- ggsurvplot(calc_surv, 
                        risk.table          = TRUE, 
#                        break.time.by       = 30, 
#                        pval                = TRUE, 
#                        legend.title        = "", 
#                        legend.labs         = c("Placebo", "High Dose", "Low Dose"), 
#                        legend              = "bottom", 
#                        palette             = c("Blue", "Red", "Black"), 
#                        title               = "KM Plot", 
#                        ncensor.plot        = TRUE, 
#                        ncensor.plot.height = 0.4, 
#                        ncensor.plot.title  = "Number of censors"
                       )

###### Adding HR
#hr_val <- "HR= 0.5"
#calc_plot$plot <- calc_plot$plot + 
#                  ggplot2::annotate(
#                     "text", 
#                     x     = 200, 
#                     y     = 0.9,
#                     label = hr_val, 
#                     size  = 4,
#                  )
calc_plot