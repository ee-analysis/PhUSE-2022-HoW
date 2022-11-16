#############################################################
# Project       : PhUSE 2022, Belfast
#                 Hands-On-Workshop 
# Author        : Kriss Harris & Endri Elnadav
# Date          : 16/11/2022
# File          : 3.KMPlot_using_SAS_R.r
# Purpose       : Generation of advanced KM Plot using data calculated using SAS
#                 - Calculation done by SAS 
#                 - Display by R
#                 - Remove the single # to play with the functionality
#                 - While remove or add #, dont forget the "+" at the previous line!!
#############################################################

###### Including the packages
library(haven)
library(ggplot2)
library(reshape)

###### Define data path (update needed)
data_path <- "C:/Temp/PhUSE 2022 - HoW/data/lf_est.xpt"

###### read ADaM dataset
###### Example used from github: TDF_ADaM_v1.0
data_calc <- read_xpt(data_path)

###### Playground - plot 
###### Remove the single # to play with the functionality
###### While remove or add #, dont forget the "+" at the previous line!!
kmplot <- ggplot(data = data_calc, aes(x = AVAL, y = SURVIVAL, group=TRTA, colour = TRTA)) + 
  geom_step() + 
  geom_point(aes(shape = as.factor(CENSOR)), show.legend =F) +
  scale_shape_manual("", values = c(32,3)) + 
  labs(colour = "Treatment Group", x = "Time", y = "Survival Probability", title = "KM Plot") 
#          scale_y_continuous(breaks = seq(0, 1, 0.1)) +
#          scale_x_continuous(breaks = seq(0, 210, 30)) + 
#          theme_classic()

kmplot