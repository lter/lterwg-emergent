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
library(tidyverse)
library(maps)
library(mapdata)
library(lubridate)
library(viridis)
library(wesanderson)

#Note: The file needed is called soilFieldChem.csv and it is already in the same directory as this file.
#Loading in the csv file
soilFieldChem <- read.csv(file = 'soilFieldChem.csv')
soil_FieldPh <- read.csv(file = 'soilFieldPh.csv')
grass <- soilFieldChem[grep('grassland|Grassland', soilFieldChem$nlcdClass), ]
forest <- soilFieldChem[grep('forest|Forest', soilFieldChem$nlcdClass), ]
forestsub <- forest %>%
  group_by(siteID, nlcdClass) %>%
  summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
            mean_soilTemp = mean(soilTemp, na.rm = TRUE))
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
  sidebarLayout(
  sidebarPanel(
  tabsetPanel(type="tabs",
              tabPanel("Plot ",selectInput("siteType", "Select Site Type", choices = c("All Sites", "Forrested Sites", "Grassland Sites")),
                       selectInput("tempmoist", "Select Either Temperature or Moisture", choices = c("Temperature", "Moisture", "pH in CaCl2")),
                       selectInput("nlcdClass", "Specify nlcdClass",choices =  c("choose" = "", levels(soilFieldChem$nlcdClass)) )),
              tabPanel("2 var" ),
              tabPanel("US view")
  
  )),
  mainPanel( 
  tabsetPanel(type="tabs",
              tabPanel("Plot ",plotOutput("boxplot")),
              tabPanel("2 var", plotOutput("both")),
              tabPanel("US View", plotOutput("no"))

)
))

)
server <- function(input, output) {
  #plotting the boxplot based on the selected site and temp/moisture
  output$boxplot <- renderPlot({
    #selecting site
    site = soilFieldChem
    if(input$siteType == "All Sites") {
      site = soilFieldChem
    } else if(input$siteType == "Forrested Sites") {
      site =forest
    } else if(input$siteType == "Grassland Sites") {
      site = grass
    }
    
    #selecting either temperature or mositure
    if(input$tempmoist == "Temperature") {
      ggplot(site, mapping = aes(x = siteID, y = soilTemp)) + 
        geom_boxplot() + 
        ylim(c(-20, 50)) +
        theme(axis.text.x = element_text(angle=45)) +
        ggtitle(input$siteType)
    } else if(input$tempmoist == "Moisture") {
      ggplot(site, mapping = aes(x = siteID, y = soilMoisture)) + 
        geom_boxplot() + 
        ylim(c(-20, 50)) +
        theme(axis.text.x = element_text(angle=45)) +
        ggtitle(input$siteType)
    } else {
      ggplot(soil_FieldPh, mapping = aes(x = siteID, y = soilInCaClpH)) + 
        geom_boxplot() + 
        ylim(c(0, 10)) +
        theme(axis.text.x = element_text(angle=45)) +
        ggtitle(input$siteType)
    }
    
    
  })
  
  #plotting the relationship for temp and moisture based on the siteID
  output$both <- renderPlot({
    #selecting site
    site = forest %>% 
      filter(nlcdClass == "deciduousForest") %>% 
      filter(sampleTiming == "peakGreenness") %>% 
      group_by(siteID) %>% 
      summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
                mean_soilTemp = mean(soilTemp, na.rm = TRUE))
    if(input$siteType == "All Sites") {
      site = soilFieldChem
    } else if(input$siteType == "Forrested Sites") {
      site = forest %>% 
        filter(nlcdClass == "deciduousForest") %>% 
        filter(sampleTiming == "peakGreenness") %>% 
        group_by(siteID) %>% 
        summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
                  mean_soilTemp = mean(soilTemp, na.rm = TRUE))
    } else if(input$siteType == "Grassland Sites") {
      site = grass
    }
    
    #plotting the relationship for temp and moisture
    ggplot(site, mapping = aes(x = mean(soilMoisture), y = mean(soilTemp) + 
      geom_point() + 
      theme(axis.text.x = element_text(angle=45)) +
      ggtitle("Temperature and Moisture Relationship")

    
 
  
    ))
    
  })

  output$no <-renderPlot ({
    site = soilFieldChem
    if(input$siteType == "All Sites") {
      site =  soilFieldChem
    } else if(input$siteType == "Forrested Sites") {
      site = forest %>% filter(decimalLatitude>-140)
    } else if(input$siteType == "Grassland Sites") {
      site = grass
    }


    ggplot( site,  aes(x = decimalLongitude, y = decimalLatitude, size=100))+
      borders("state", colour = "white", fill = "grey90") +
      geom_point(aes(x = decimalLongitude, y = decimalLatitude, size=100),stroke=F, alpha=0.7) +
     
      # Cleaning up the graph
      
      theme_void() + 
      guides( colour = guide_legend()) +
      labs(title = "") +
      theme(
        legend.position = "bottom",
        text = element_text(color = "#22211d"),
        plot.background = element_rect(fill = "#ffffff", color = NA), 
        panel.background = element_rect(fill = "#ffffff", color = NA), 
        legend.background = element_rect(fill = "#ffffff", color = NA)
      ) +
      coord_fixed(ratio=1.5)
    
    
})

}

# Create Shiny app objects from either an explicit UI/server pair
shinyApp(ui = ui, server = server)

