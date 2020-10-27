#This is the Shiny app for the Neon data showcasing the graphs for the NEON data
#Author: Dvir Blander and Katrina Newcomer
#First loading in the shiny, dplyr, readr libraries.
#The shiny library is used because this is a shiny app.
#The dplyr and readr libraries are used to help read in the data.
#The DT library is used for the datatables
library(plotly)
library(ggplot2)
library(shiny)
library(dplyr)
library(readr)
library(DT)
library(shinyWidgets)
#Note: The file needed is called soilFieldChem.csv and it is already in the same directory as this file.
#Loading in the csv file
soilFieldChem <- read.csv(file = 'soilFieldChem.csv')
grass <- soilFieldChem[grep('grassland|Grassland', soilFieldChem$nlcdClass), ]
forest <- soilFieldChem[grep('forest|Forest', soilFieldChem$nlcdClass), ]
forestsub <- forest %>%
  group_by(siteID, nlcdClass) %>%
  summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
            mean_soilTemp = mean(soilTemp, na.rm = TRUE), .groups="keep")
grasssub <- grass %>%
  group_by(siteID, nlcdClass) %>%
  summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
            mean_soilTemp = mean(soilTemp, na.rm = TRUE), .groups="keep")
allsub <- soilFieldChem%>%
  group_by(siteID, nlcdClass) %>%
  summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
            mean_soilTemp = mean(soilTemp, na.rm = TRUE), .groups="keep")
ui <- fluidPage(
  titlePanel("Neon Graphs"),
  mainPanel(
    plotOutput("allsub_temp"),
    plotOutput("allsub_moist"),
    plotOutput("grasssub_temp"),
    plotOutput("grasssub_moist"),
    plotOutput("forestsub_temp"),
    plotOutput("forestsub_moist")
  )
)
server <- function(input, output) {
  
  output$allsub_temp <- renderPlot({
    ggplot(allsub, aes(x=siteID, y=mean_soilTemp))+
      geom_boxplot() + 
      ggtitle("Temperature by Site ID for All Sites")
  })
  
  output$allsub_moist <- renderPlot({
    ggplot(allsub, aes(x=siteID, y=mean_soilMoisture))+
      geom_boxplot() + 
      ggtitle("Moisture by Site ID for All Sites")
  })
  
  output$grasssub_temp <- renderPlot({
    ggplot(grasssub, aes(x=siteID, y=mean_soilTemp))+
      geom_boxplot()+
      ggtitle("Temperature by Site ID for Grassland Sites")
  })
  
  output$grasssub_moist <- renderPlot({
    ggplot(grasssub, aes(x=siteID, y=mean_soilMoisture))+
      geom_boxplot() + 
      ggtitle("Moisture by Site ID for Grassland Sites")
  })
  
  output$forestsub_temp <- renderPlot({
    ggplot(forestsub, aes(x=siteID, y=mean_soilTemp))+
      geom_boxplot() + 
      ggtitle("Moisture by Site ID for Forrested Sites")
  })
  
  output$forestsub_moist <- renderPlot({
    ggplot(forestsub, aes(x=siteID, y=mean_soilMoisture))+
      geom_boxplot() + 
      ggtitle("Moisture by Site ID for Forrested Sites")
  })
  
}
# Create Shiny app objects from either an explicit UI/server pair
shinyApp(ui = ui, server = server)
