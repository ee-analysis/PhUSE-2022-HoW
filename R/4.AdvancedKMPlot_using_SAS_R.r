#############################################################
# Project       : PhUSE 2022, Belfast
#                 Hands-On-Workshop 
# Author        : Kriss Harris & Endri Elnadav
# Date          : 16/11/2022
# File          : 4.AdvancedKMPlot_using_SAS_R.r
# Purpose       : Generation of advanced KM Plot using data calculated using SAS
#                 - Calculation done by SAS 
#                 - Display by R
#############################################################

###### Including the packages
library(haven)
library(ggplot2)
library(patchwork)

###### Define data path (update needed)
data_path <- "C:/Temp/PhUSE 2022 - HoW/data/lf_est.xpt"
x_int <- seq(0, 210, 30)

###### read ADaM dataset
###### Example used from github: TDF_ADaM_v1.0
data_calc <- read_xpt(data_path)
dataatrisk <- data_calc[data_calc$AVAL %in% x_int,]


###### Playground - plot 
kmplot <- ggplot(data = data_calc, aes(x = AVAL, y = SURVIVAL, group=TRTA, colour = TRTA)) + 
  geom_step() + 
  geom_point(aes(shape = as.factor(CENSOR)), show.legend =F) +
  
  ### Adding the censor ticks 
  scale_shape_manual("", values = c(32, 3)) + 
  
  ### Modify labels 
  labs(colour = "Treatment Group", x = "Time", y = "Survival Probability", title = "KM Plot") +
  
  ### Axis Settings
  scale_y_continuous(breaks = seq(0, 1, 0.1)) +
  scale_x_continuous(breaks = x_int) + 
  
  ### Layout
  theme_classic() 


kmatrisk <- ggplot(data = dataatrisk) +
  
  ### Adding table
  geom_text(aes(x=AVAL, y=TRTA, label=RISK)) + 
  
  ### Axis settings
  scale_x_continuous(breaks = x_int) + 
  scale_y_discrete(limits = c("Xanomeline Low Dose", "Xanomeline High Dose", "Placebo")) + 
  
  ### labels
  labs(x = "Number at risk", y = " ") +
  theme_classic() 


kmplot + kmatrisk  + plot_layout(ncol =  1, heights = c(1, 0.2))

