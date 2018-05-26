
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

# # returns string w/o leading whitespace
# trim.leading <- function (x)  sub("^\\s+", "", x)
# 
# # returns string w/o trailing whitespace
# trim.trailing <- function (x) sub("\\s+$", "", x)

# returns string w/o leading or trailing whitespace
# trim <- function (x) gsub("^\\s+|\\s+$", "", x)

charToNumber <-function(x,replaceValue){
  x=suppressWarnings(as.numeric(x))
  x[ is.na(x) ] <- as.numeric(replaceValue)
  return(x)
  
}

YesNoSelection <-function(inputOption,ratingDataColumn,nrowRatingData){
  
  if (is.null(inputOption)){
    TFArray <- as.vector(rep(TRUE, nrowRatingData))
  }
  else {
    
    if ((inputOption) == "Yes"){
      TFArray <- (ratingDataColumn %in% "Y")
    }
    
    if ((inputOption) == "No"){
      TFArray <- (ratingDataColumn %in% "N")
    }
    
  }
   
  return(TFArray)
  
}

#Load spreadsheet
wb = XLConnect::loadWorkbook("Data.xlsx")
ratingData= XLConnect::readWorksheet(wb, sheet = "Sheet3")

#Set column names
ManufacturerExcelData<-as.data.frame(table(factor(ratingData$Manufacturer)))
colnames(ManufacturerExcelData) <- c("Manufacturer", "Count")

#Replace NA
naYearReleased ="2004"
naHeight       ="1"
naDepth        ="2"
naWidth        ="1"
naWeigth       ="10"
naPowerConsumption="40";
naInternalBattery="1"; 
naMinimumOpeartingTemperature ="0";
naMaximumOpeartingTemperature ="0";
naROHSCompliance = "N";
naNumberOfChannels = "12"; 
naMaxSimulTrackedChannels = "10"; 
naReacquisitionTime = "45";


ratingData$Year.released           =charToNumber(ratingData$Year.released,naYearReleased)
ratingData$Height                  =charToNumber((ratingData$Height),naHeight)
ratingData$Depth                   =charToNumber((ratingData$Depth),naDepth)
ratingData$Width                   =charToNumber((ratingData$Width),naWidth)
ratingData$Weight                  =charToNumber((ratingData$Weight),naWeigth)
ratingData$Power.consumption       =charToNumber(ratingData$Power.consumption,naPowerConsumption) 
ratingData$Internal.Battery        =charToNumber(ratingData$Internal.Battery,naInternalBattery)  
ratingData$Minimum.Operating.Temperature        =charToNumber(ratingData$Minimum.Operating.Temperature,naMinimumOpeartingTemperature)  
ratingData$Maximum.Operating.Temperature        =charToNumber(ratingData$Maximum.Operating.Temperature,naMaximumOpeartingTemperature)  
ratingData$ROHS.compliance           = sub("NA",naROHSCompliance,ratingData$ROHS.compliance)
ratingData$WEEE.compliance           = sub("NA",naROHSCompliance,ratingData$WEEE.compliance)
ratingData$Number.of.channels        =charToNumber(ratingData$Number.of.channels,naNumberOfChannels)  
ratingData$Max.simultaneous.tracked.channels        =charToNumber(ratingData$Max.simultaneous.tracked.channels,naMaxSimulTrackedChannels)  
ratingData$Reacquisition.time        =charToNumber(ratingData$Reacquisition.time,naReacquisitionTime)  
ratingData$RTK.Network.Compatibility = sub("NA",naROHSCompliance,ratingData$RTK.Network.Compatibility)
ratingData$MRS.functionality         = sub("NA",naROHSCompliance,ratingData$MRS.functionality)
ratingData$Simultaneous.links        = sub("NA",naROHSCompliance,ratingData$Simultaneous.links)
ratingData$PPS.Out                   = sub("NA",naROHSCompliance,ratingData$PPS.Out)
ratingData$Bluetooth                 = sub("NA",naROHSCompliance,ratingData$Bluetooth)

# d=(ratingData$MRS.functionality)
# print(table((d)))

shinyServer(function(input, output) {
 
  output$ManufacturesList <- renderUI({
    # return(as.vector(Manufacturer[["Manufacturer"]] ))
    selectInput("Manufactures","Manufacturers",choices = as.vector(ManufacturerExcelData[["Manufacturer"]] ), multiple = TRUE) 
  })
  
  
  
  dataFormReactiveFunction<-reactive({
    
    # When the script loads, it gives a null value for Manufactures. Want an empty selection to mean all
    if (is.null(input$Manufactures)){
      ManufacturesTFArray <- as.vector(rep(TRUE, nrow(ratingData)))
    }
    else{
      ManufacturesTFArray = (ratingData$Manufacturer %in% input$Manufactures)
    }
 
    ROHScomplianceTFArray    = YesNoSelection(input$ROHS,ratingData$ROHS.compliance,nrow(ratingData))
    WEEEcomplianceTFArray    = YesNoSelection(input$WEEE,ratingData$WEEE.compliance,nrow(ratingData))
    RTKnetworkCompTFArray    = YesNoSelection(input$RTKnetworkCompatibility,ratingData$RTK.Network.Compatibility,nrow(ratingData))
    MRSfunctionalityTFArray  = YesNoSelection(input$MRSfunctionality,ratingData$MRS.functionality,nrow(ratingData))
    SimultaneousLinksTFArray = YesNoSelection(input$SimultaneousLinks,ratingData$Simultaneous.links,nrow(ratingData))
    PPSoutTFArray            = YesNoSelection(input$PPSOut,ratingData$PPS.Out,nrow(ratingData))
    BluetoothTFArray         = YesNoSelection(input$Bluetooth,ratingData$Bluetooth,nrow(ratingData))
    
      
    
    G4=which(
      #General
      (ratingData$Year.released  >= input$Year[1]) & (ratingData$Year.released  <= input$Year[2])&
      (ManufacturesTFArray)&
      (ratingData$Height  >= input$Height[1])      & (ratingData$Height  <= input$Height[2]) &
      (ratingData$Depth    >= input$Depth[1])      & (ratingData$Depth  <= input$Depth[2]) &
      (ratingData$Width    >= input$Width[1])      & (ratingData$Width  <= input$Width[2]) &
      (ratingData$Weight   >= as.numeric(input$Weight[1]))     & (ratingData$Weight  <= as.numeric(input$Weight[2]))&
      #Power
      (ratingData$Power.consumption  >= input$consumption[1]) & (ratingData$Power.consumption<= input$consumption[2])& 
      (ratingData$Internal.Battery  >= input$internalBattery[1]) & (ratingData$Internal.Battery<= input$internalBattery[2]) &
      #Environment
      (ratingData$Minimum.Operating.Temperature  >= input$OperatingTemperature[1]) & (ratingData$Maximum.Operating.Temperature<= input$OperatingTemperature[2]) &
      ROHScomplianceTFArray&
      WEEEcomplianceTFArray&
      #Performance
      (ratingData$Number.of.channels  >= input$NoChannels[1]) & (ratingData$Number.of.channels <= input$NoChannels[2])&
      (ratingData$Max.simultaneous.tracked.channels  >= input$MaxSimultaneousTrack[1]) & (ratingData$Max.simultaneous.tracked.channels <= input$MaxSimultaneousTrack[2]) &
      (ratingData$Reacquisition.time  >= input$ReacquisitionTime[1]) & (ratingData$Reacquisition.time <= input$ReacquisitionTime[2]) &
      RTKnetworkCompTFArray &
      MRSfunctionalityTFArray &
      #Communication Protocols
      SimultaneousLinksTFArray &
      PPSoutTFArray &
      BluetoothTFArray
      
      
      
    ) 
    dataFrameTime   = data.frame(ratingData$Manufacturer[G4], ratingData$Model.name[G4])       
    colnames(dataFrameTime) <- c("Manufacturer", "Model Name")
    
    # print(input$Manufactures)
    # print( (ratingData$Manufacturer %in% input$Manufactures))
    # print(nrow(dataFrameTime))
    
    return(dataFrameTime)
  })
  
  output$table <- renderDataTable(dataFormReactiveFunction(),options = list(pageLength = 10,paging = TRUE,searching = TRUE,info=0))  
  
  output$Note1 <- renderText({ "Default for missing data, currently intialized to worst case scenario." })
  output$NumberofReceivers <- renderText({paste("Total number of recommended receivers:" , as.character(nrow(dataFormReactiveFunction()))) })

  output$text <- renderUI({
    str1 <- paste("Year Released : ", naYearReleased)
    # str2 <- paste("You have chosen a range that goes from", input$range[1], "to", input$range[2])
    str2 <- paste("Height : ", naHeight)
    str3 <- paste("Depth : ", naDepth)
    str4 <- paste("Width : ", naWidth)
    str5 <- paste("Weight : ", naWeigth)
    str5 <- paste("Power Consumption : ", naPowerConsumption)
    str6 <- paste("Internal Battery : ", naInternalBattery)
    str7 <- paste("Minimum operating temperature : ", naMinimumOpeartingTemperature) 
    str8 <- paste("Maximum operating temperature : ", naMaximumOpeartingTemperature)
    str9<- paste("ROHS Compliance : ", naROHSCompliance) 
    str10<- paste("WEEE Compliance : ", naROHSCompliance) 
    str11<- paste("Number of channels : ", naNumberOfChannels) 
    str12<- paste("Maximum simultaneous tracked channels : ", naMaxSimulTrackedChannels) 
    str13<- paste("Reacquisition time : ", naReacquisitionTime) 
    str14<- paste("RTK Network Compatibility : ", naROHSCompliance) 
    str15<- paste("MRS functionality : ", naROHSCompliance) 
    str16<- paste("Simultaneous links : ", naROHSCompliance) 
    str17<- paste("PPS out : ", naROHSCompliance) 
    str18<- paste("Bluetooth : ", naROHSCompliance) 
    HTML(paste(str1, str2, str3, str4, str5, str6, str7, str8, str9, str10,str11,str12,str13,str14,str15,str16,str17,str18, sep = '<br/>'))
     
    
  }) 
  
})


