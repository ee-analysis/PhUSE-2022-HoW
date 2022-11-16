#############################################################
# Project       : PhUSE 2022, Belfast
#                 Hands-On-Workshop 
# Author        : Kriss Harris & Endri Elnadav
# Date          : 16/11/2022
# File          : 6.ShinyKMPlot1.r
# Purpose       : (Simple) Interactive Plot using R(Shiny)
#                 Calculation done on SAS Side
#############################################################

library(shiny)
library(haven)
library(ggplot2)


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
    
    sidebarPanel(),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot",         
                 dblclick = "plot1_dblclick",
                 brush = brushOpts(
                   id = "plot1_brush",
                   resetOnNew = TRUE
                 ))
    )
  )
)

# Server
server <- function(input, output, session) {
  
  ranges <- reactiveValues(x = NULL, y = NULL)
  
  output$distPlot <- renderPlot({
    
    ###### Code from 4.AdvancedKMPlot_using_SAS_R.r
    ggplot(data = data_calc, aes(x = AVAL, y = SURVIVAL, group=TRTA, colour = TRTA)) + 
      geom_step() + 
      geom_point(aes(shape = as.factor(CENSOR)), show.legend =F) +
      
      ### Adding the censor ticks 
      scale_shape_manual("", values = c(32, 3)) + 
      
      ### Modify labels 
      labs(colour = "Treatment Group", x = "Time", y = "Survival Probability", title = "KM Plot") +
      
      
      ### Layout
      theme_classic() +
      
      ### Interactive Plot
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
    
  })
  
  observeEvent(input$plot1_dblclick, {
    brush <- input$plot1_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
}


# Run the application 
shinyApp(ui = ui, server = server)
