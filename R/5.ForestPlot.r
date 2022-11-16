#############################################################
# Project       : PhUSE 2022, Belfast
#                 Hands-On-Workshop 
# Author        : Kriss Harris & Endri Elnadav
# Date          : 16/11/2022
# File          : 10_ForestPlot.r
# Purpose       : Generation of Forest Plot using R
#                 - Calculation has been done before, and we just need to import the calculation
#                 - Remove the single # to play with the functionality
#                 - for help, type in console for example: ?read_xpt or ?ggsurvplot
#############################################################


###### Including the packages
library(ggplot2)
library(haven)

##### Import from CSV
data_forest <- read.csv2(file = "C:/Temp/PhUSE 2022 - HoW/data/ForestCalc.csv")

###### Data manipulation - converting char to num
data_forest$ODDS <- as.double(data_forest$ODDS)
data_forest$LL   <- as.double(data_forest$LL)
data_forest$UL   <- as.double(data_forest$UL)

##### Forest Plot
plot1 <- ggplot(data_forest, aes(y = INDEX, x = ODDS)) +
  
  ### Item list on Y-Axis
  scale_y_continuous(breaks = 1:3, labels = data_forest$LABEL) +   
  
  ### Plot Odds Ratio
  geom_point(shape = 18, size = 3) +
  
  ### Plot Error Bar
  geom_errorbarh(aes(xmin = LL, xmax = UL), height = 0.2) +
  
  ### Plot Vertical Line at 1.0
  geom_vline(xintercept = 1, linetype = "dashed") + 
  
  ### Axis limit setings
  coord_cartesian(xlim=c(-1, 4)) +
  
  ### Y Label
  ylab("Variables") + 
  
  ### X Label
  xlab('Odds Ratio (95% CI) ') + 
  scale_x_continuous(breaks = -1:4, labels = c(" ", "0", "1", "2", " ", " ")) +
  
  ### Title
  ggtitle('Forest Plot with CI') + 
  
  
  
  ### Annotate
  annotate("text", x = 0  ,  y = 3.5, label = "xxx is better") + 
  annotate("text", x = 2,  y = 3.5, label = "yyy is better") + 
  
  ### Theme / Template 
  theme_classic() +
  
  ### Add CI table  
  annotate("text", x = 3.5,  y = 3.5, label = "95% CI") + 
  geom_text(data = data_forest, aes(x = 3.5, label = CI))

plot1 