
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  
  
  # Some custom CSS
  tags$head(
    tags$style(HTML("
                    /* Smaller font for preformatted text */
                    pre, table.table {
                    font-size: smaller;
                    }
                    
                    body {
                    min-height: 2000px;
                    }
                    
                    .option-group {
                    border: 1px solid #ccc;
                    border-radius: 6px;
                    padding: 0px 20px;
                    margin: 5px -10px;
                    background-color: #f5f5f5; 
                    }
                    
                    .option-header {
                    color: #79d;
                    text-transform: uppercase;
                    margin-bottom: 5px;
                    }
                    "))
    ),
  
  
  fluidRow(
    column(width = 3,
           div(class = "option-group",
               div(class = "option-header", "General"),
               # selectizeInput('Manufactures', 'Manufactures', choices = "stocknames", multiple = TRUE),
               uiOutput("ManufacturesList"),
              
               div(style="height: 90px;",sliderInput("Year", "Year", min=2004, max=2016, value= c(2004, 2016), step=1,sep="")),
               div(style="height: 90px;",sliderInput("Height", "Height [m]", min=0, max=1, value= c(0, 1), step=0.1,sep="")),
               div(style="height: 90px;",sliderInput("Depth", "Depth [m]", min=0, max=2, value= c(0, 2), step=0.25,sep="")), 
               div(style="height: 90px;",sliderInput("Width", "Width [m]", min=0, max=1, value= c(0, 1), step=0.1,sep="")), 
               div(style="height: 90px;",sliderInput("Weight", "Weight [kg]", min=0, max=10, value= c(0, 10), step=0.5,sep=""))
           )
#            ,
#            div(class = "option-group",
#                div(class = "option-header", "Communication: Internal"),
#                radioButtons("hover_policy", "Input rate policy",
#                             c("debounce", "throttle"), inline = TRUE),
#                sliderInput("hover_delay", "Delay", min=100, max=1000, value=200,
#                            step=100),
#                checkboxInput("hover_null_outside", "NULL when outside", value=TRUE)
#            )
    )
    ,
    column(width = 3,
           div(class = "option-group",
               div(class = "option-header", "Power"), 
               div(style="height: 90px;",sliderInput("consumption", "Consumption [W]", min=0, max=40, value= c(0, 40), step=5,sep="")) ,
               div(style="height: 90px;",sliderInput("internalBattery", "Internal Battery [hours]", min=0, max=20, value= c(0, 20), step=2,sep=""))
           ),
           div(class = "option-group",
               div(class = "option-header", "Environment"),
               div(style="height: 120px;",sliderInput("OperatingTemperature", "Operating Temperature [C]" , min=-55, max=90, value= c(-55, 90), step=10,sep="")),
               div(style="height: 70px;",radioButtons("ROHS", "ROHS Compliance", c("Yes", "No"), inline = TRUE,selected = character(0))),
               div(style="height: 70px;",radioButtons("WEEE", "WEEE Compliance", c("Yes", "No"), inline = TRUE,selected = character(0)))
           )
    )
    ,
    column(width = 3,
           div(class = "option-group",
               div(class = "option-header", "Performance"),
               div(style="height: 90px;",sliderInput("NoChannels", "Number of channels" , min=12, max=544, value= c(12, 544), step=10,sep="")),
               div(style="height: 100px;",sliderInput("MaxSimultaneousTrack", "Max simultaneous tracked channels" , min=10, max=440, value= c(10, 440), step=10,sep="")),
               div(style="height: 90px;",sliderInput("ReacquisitionTime", "Reacquisition time [s]" , min=0, max=45, value= c(0, 45), step=5,sep="")),
               div(style="height: 60px;",radioButtons("RTKnetworkCompatibility", "RTK Network Compatibility", c("Yes", "No"), inline = TRUE,selected = character(0))),
               div(style="height: 70px;",radioButtons("MRSfunctionality", "MRS functionality", c("Yes", "No"), inline = TRUE,selected = character(0)))
               ),
           div(class = "option-group",
               div(class = "option-header", "* Recording")
               # div(style="height: 90px;",sliderInput("NoChannels", "Number of channels" , min=1, max=974632, value= c(1, 974632), step=1024,sep=""))
           )
    )
    ,
    column(width = 3,
           div(class = "option-group",
               div(class = "option-header", "* Position uncertainity")
           ),
           div(class = "option-group",
               div(class = "option-header", "Communication: protocols"),
               div(style="height: 70px;",radioButtons("SimultaneousLinks", "Simultaneous links", c("Yes", "No"), inline = TRUE,selected = character(0))),
               div(style="height: 70px;",radioButtons("PPSOut", "PPS Out", c("Yes", "No"), inline = TRUE,selected = character(0))),
               div(style="height: 70px;",radioButtons("Bluetooth", "Bluetooth", c("Yes", "No"), inline = TRUE,selected = character(0)))
           )
    ) 
  ) ,
fluidRow(
  column(width = 12,
         
         wellPanel(width = 12,
                   # h4("Manufacturers :"),
                   dataTableOutput("table")   
         )
  ) 
) ,
fluidRow(
  column(width = 12,
         
         wellPanel(width = 12,
                  
                   textOutput("NumberofReceivers"),
                   
                   h5("Default values for missing data :"),
                   htmlOutput("text")
         )
  ) 
) 
  
  
  
))
