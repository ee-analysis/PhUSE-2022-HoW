#############################################################
# Project       : PhUSE 2022, Belfast
#                 Hands-On-Workshop 
# Author        : Kriss Harris & Endri Elnadav
# Date          : 16/11/2022
# File          : 7.AdvancedShinyKMPlot_vithCodeGen.r
# Purpose       : (Simple) Interactive Plot using R(Shiny)
#                 Calculation done on SAS Side
#############################################################

library(shiny)
library(haven)
library(ggplot2)
library(patchwork)
library(whisker)

###### Define data path (update needed)
###### Read data from SAS
data_path <- "C:/Temp/PhUSE 2022 - HoW/data/lf_est.xpt"
data_calc <- read_xpt(data_path)

# UI
ui <- fluidPage(
  
  # Application title
  titlePanel("SAS meets R(Shiny)"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    
    sidebarPanel(
      sliderInput("interval",
                  "Select Interval:",
                  min = 0,
                  max = 210,
                  value = 30), 
      width = 3
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot"), 
      verbatimTextOutput("SASProg")
    )
  )
)

# Server
server <- function(input, output, session) {
  
  ################# Filter dats based on the input slider
  filterData <- reactive({
    filteredData <- data_calc[data_calc$AVAL %in% seq(0, 210, input$interval),]
    return(filteredData)
  })
  
  
  output$distPlot <- renderPlot({
    
    ###########################################
    # Code from 4.AdvancedKMPlot_using_SAS_R.r
    # Scale_x_continous has been updated to enable the interactiv
    ###########################################
    
    ################# KM Plot
    ggplot(data = data_calc, aes(x = AVAL, y = SURVIVAL, group=TRTA, colour = TRTA)) + 
      geom_step() + 
      geom_point(aes(shape = as.factor(CENSOR)), show.legend =F) +
      scale_shape_manual("", values = c(32, 3)) + 
      labs(colour = "Treatment Group", x = "Time", y = "Survival Probability", title = "KM Plot") +
      theme_classic() +
      scale_x_continuous(breaks = seq(0, 210, input$interval)) + 
      
      ################# Number at risk 
      ggplot(data = filterData()) +
      geom_text(aes(x=AVAL, y=TRTA, label=RISK)) + 
      scale_x_continuous(breaks = seq(0, 210, input$interval)) + 
      scale_y_discrete(limits = c("Xanomeline Low Dose", "Xanomeline High Dose", "Placebo")) + 
      labs(x = "Number at risk", y = " ") +
      theme_classic() +
      
      ################# Layout 
      plot_layout(ncol =  1, heights = c(1, 0.2))
  })
  
  SAStemp <- "/**************************************
 *** Template code used from: 
 *** SAS/Program 1-1.sas  
 *** Simple example code generator based on 1 user input 
 *** The interval will be updated. (See by xxx below)
 **************************************/
 
ods trace on;
proc lifetest data = adam.adtteeff  
   plots=survival(atrisk=0 to 210 by {{interval}});
   time aval * cnsr(1);
   strata trtpn;
   run;
ods trace off;"
  
  
  
  ui_value <- reactive({
    ui_value <- list(interval = input$interval)
    txt = whisker.render(SAStemp, ui_value)
    return(txt)
  })
  
  output$SASProg <- renderText({ui_value()})
}


# Run the application 
shinyApp(ui = ui, server = server)
