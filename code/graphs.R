#This is the Shiny app for the Neon data showcasing the graphs for the NEON data
#Author: Dvir Blander and Katrina Newcomer
#First loading in the shiny, dplyr, readr libraries.
#The shiny library is used because this is a shiny app.
#The dplyr and readr libraries are used to help read in the data.
library(ggplot2)
library(shiny)
library(dplyr)
library(readr)
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
  selectInput("siteType", "Select Site Type", choices = c("All Sites", "Forrested Sites", "Grassland Sites")),
  selectInput("tempmoist", "Select Either Temperature or Moisture", choices = c("Temperature", "Moisture")),
  plotOutput("boxplot"),
  plotOutput("both")
)


server <- function(input, output) {
  #plotting the boxplot based on the selected site and temp/moisture
  output$boxplot <- renderPlot({
    #selecting site
    site = allsub
    if(input$siteType == "All Sites") {
      site = allsub
    } else if(input$siteType == "Forrested Sites") {
      site = forestsub
    } else if(input$siteType == "Grassland Sites") {
      site = grasssub
    }
    
    #selecting either temperature or mositure
    if(input$tempmoist == "Temperature") {
      ggplot(site, mapping = aes(x = siteID, y = mean_soilTemp)) + 
        geom_boxplot() + 
        ylim(c(-20, 50)) +
        theme(axis.text.x = element_text(angle=45)) +
        ggtitle(input$siteType)
    } else if(input$tempmoist == "Moisture") {
      ggplot(site, mapping = aes(x = siteID, y = mean_soilMoisture)) + 
        geom_boxplot() + 
        ylim(c(-20, 50)) +
        theme(axis.text.x = element_text(angle=45)) +
        ggtitle(input$siteType)
    }
  })
  
  #plotting the relationship for temp and moisture based on the siteID
  output$both <- renderPlot({
    #selecting site
    site = allsub
    if(input$siteType == "All Sites") {
      site = allsub
    } else if(input$siteType == "Forrested Sites") {
      site = forestsub
    } else if(input$siteType == "Grassland Sites") {
      site = grasssub
    }
    
    #plotting the relationship for temp and moisture
    ggplot(site, mapping = aes(x = mean_soilMoisture, y = mean_soilMoisture)) + 
      geom_point() + 
      theme(axis.text.x = element_text(angle=45)) +
      ggtitle("Temperature and Moisture Relationship")
  })
  
}
# Create Shiny app objects from either an explicit UI/server pair
shinyApp(ui = ui, server = server)
