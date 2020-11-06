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
library(plotly)

#Note: The file needed is called soilFieldChem.csv and it is already in the same directory as this file.
#Loading in the csv file

soilFieldChem <- read.csv(file = 'soilFieldChem.csv')
soilFieldPh <- read.csv(file = 'soilFieldPh.csv')
grass <- soilFieldChem[grep('grassland|Grassland', soilFieldChem$nlcdClass), ]
forest <- soilFieldChem[grep('forest|Forest', soilFieldChem$nlcdClass), ]
forestsub <- forest %>%
  group_by(siteID, nlcdClass) %>%
  summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
            mean_soilTemp = mean(soilTemp, na.rm = TRUE), .groups="keep")
Grass <- soilFieldPh[grep('grassland|Grassland', soilFieldPh$nlcdClass), ]
Forest <- soilFieldPh[grep('forest|Forest', soilFieldPh$nlcdClass), ]
Forestsub <- Forest %>%
  group_by(siteID, nlcdClass) %>%
  summarise(soilMoisture = mean(soilMoisture, na.rm = TRUE),
            soilTemp = mean(soilTemp, na.rm = TRUE), soilInCaClpH = soilInCaClpH, .groups="keep")
Grasssub <- Grass %>%
  group_by(siteID, nlcdClass) %>%
  summarise(soilMoisture = mean(soilMoisture, na.rm = TRUE),
            soilTemp = mean(soilTemp, na.rm = TRUE), soilInCaClpH = soilInCaClpH, .groups="keep")
grasssub <- grass %>%
  group_by(siteID, nlcdClass) %>%
  summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
            mean_soilTemp = mean(soilTemp, na.rm = TRUE), .groups="keep")
allsub <- soilFieldChem%>%
  group_by(siteID, nlcdClass) %>%
  summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
            mean_soilTemp = mean(soilTemp, na.rm = TRUE), .groups="keep")

soilT <- soilFieldChem%>%
  group_by(siteID, nlcdClass) %>%
  summarise(soilTemp = soilTemp, .groups="keep")

soilM <- soilFieldChem %>%
  group_by(siteID, nlcdClass) %>%
  summarise(soilMoisture = soilMoisture, .groups="keep")

soilP <- soilFieldPh %>%
  group_by(siteID, nlcdClass) %>%
    summarise(soilInCaClpH = soilInCaClpH, .groups="keep")
ui <- fluidPage(
  titlePanel("Neon Graphs"),
  sidebarPanel(
    conditionalPanel(condition="input.conditionedPanels== 'BoxPlot' ", selectInput("siteType", "Select Site Type", choices = c("All Sites", "Forrested Sites", "Grassland Sites")),
                     selectInput("tempmoist", "Select Either Temperature or Moisture", choices = c("Temperature", "Moisture"))),
    conditionalPanel(condition="input.conditionedPanels== '2 Variable' ", selectInput("var1", "Select variable 1", choices = c("soilMoisture", "soilTemp", "soilInCaClpH")),
                     selectInput("var2", "Select variable 2", choices = c("soilMoisture", "soilTemp", "soilInCaClpH")), selectInput("siteType2", "Select Site Type", choices = c("All Sites", "Forrested Sites", "Grassland Sites"))),
    conditionalPanel(condition="input.conditionedPanels == 'map' ", selectInput("siteType1", "Select Site Type", choices = c("All Sites", "Forrested Sites", "Grassland Sites")))
    
    
    ),
  mainPanel (
  tabsetPanel(
    id="conditionedPanels",
      tabPanel("BoxPlot", plotOutput("boxplot")),
      tabPanel("2 Variable",plotOutput("both")),
      tabPanel("map", plotOutput("no"))
)
),
fluidRow(
  print("hi"),
  img(src='https://lternet.edu/wp-content/themes/ndic/library/images/logo.svg', align='left')
)
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
        ylim(c(0, 30)) +
        theme(axis.text.x = element_text(angle=45)) +
        ggtitle(input$siteType)
    } else if(input$tempmoist == "Moisture") {
      ggplot(site, mapping = aes(x = siteID, y = mean_soilMoisture)) + 
        geom_boxplot() + 
        ylim(c(0, 10)) +
        theme(axis.text.x = element_text(angle=45)) +
        ggtitle(input$siteType)
    }
  })
  
  #plotting the relationship for temp and moisture based on the siteID
  output$both <- renderPlot({

    #selecting site
    site = soilFieldPh
    if(input$siteType2 == "All Sites") {
      site = soilFieldPh
    } else if(input$siteType2 == "Forrested Sites") {
      site = Forestsub
    } else if(input$siteType2 == "Grassland Sites") {
      site = Grasssub
    }
  
    if(input$var1 == "soilInCaClpH") {
      if(input$var2 == "soilMoisture") {
        g1 <- ggplot(site, aes(x=soilInCaClpH, y=soilMoisture, color = siteID, label = siteID)) + 
          geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
          xlim(c(0, 4)) +
          ylim(c(0, 30)) +
          ggtitle('Soil Moisture x Temperatue Forested Plots')
        g1
      }
  
      else if (input$var2 == "soilTemp") {
        g1 <- ggplot(site, aes(x=soilInCaClpH, y=soilTemp, color = siteID, label = siteID)) + 
          geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
          xlim(c(0, 4)) +
          ylim(c(0, 30)) +
          ggtitle('Soil Moisture x Temperatue Forested Plots')
        g1
      }
      else {
        g1 <- ggplot(site, aes(x=soilInCaClpH, y=soilInCaClpH, color = siteID, label = siteID)) + 
          geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
          xlim(c(0, 4)) +
          ylim(c(0, 30)) +
          ggtitle('Soil Moisture x Temperatue Forested Plots')
        g1
      }
  }
   else if(input$var1 == "soilMoisture") {
      if(input$var2 == "soilMoisture") {
        g1 <- ggplot(site, aes(x=soilMoisture, y=soilMoisture, color = siteID, label = siteID)) + 
          geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
          xlim(c(0, 4)) +
          ylim(c(0, 30)) +
          ggtitle('Soil Moisture x Temperatue Forested Plots')
        g1
      }
      
    else if (input$var2 == "soilTemp") {
      g1 <- ggplot(site, aes(x=soilMoisture, y=soilTemp, color = siteID, label = siteID)) + 
        geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
        xlim(c(0, 4)) +
        ylim(c(0, 30)) +
        ggtitle('Soil Moisture x Temperatue Forested Plots')
      g1
    }
    else {
      g1 <- ggplot(site, aes(x=soilMoisture, y=soilInCaClpH, color = siteID, label = siteID)) + 
        geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
        xlim(c(0, 4)) +
        ylim(c(0, 10)) +
        ggtitle('Soil Moisture x Temperatue Forested Plots')
      g1
    }
  }
    else if(input$var1 == "soilInCaClpH") {
      if(input$var2 == "soilMoisture") {
        g1 <- ggplot(site, aes(x=soilInCaClpH, y=soilMoisture, color = siteID, label = siteID)) + 
          geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
          xlim(c(2, 6)) +
          ylim(c(0, 25)) +
          ggtitle('Soil Moisture x Temperatue Forested Plots')
        g1
      }
      
      else if (input$var2 == "soilTemp") {
        g1 <- ggplot(site, aes(x=soilInCaClpH, y=soilTemp, color = siteID, label = siteID)) + 
          geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
          xlim(c(2, 10)) +
          ylim(c(0, 50)) +
          ggtitle('Soil Moisture x Temperatue Forested Plots')
        g1
      }
      else {
        g1 <- ggplot(site, aes(x=soilInCaClpH, y=soilInCaClpH, color = siteID, label = siteID)) + 
          geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
          xlim(c(2, 10)) +
          ylim(c(0, 10)) +
          ggtitle('Soil Moisture x Temperatue Forested Plots')
        g1
      }
    }

  })
  
  output$no <- renderPlot({
    site = soilFieldChem
    if(input$siteType1 == "All Sites") {
      site = soilFieldChem
    } else if(input$siteType1 == "Forrested Sites") {
      site = forest 
    } else if(input$siteType1 == "Grassland Sites") {
      site = grass
    }
    soilFieldChema <- soilFieldChem 
ggplot(site,  aes(x = Longitude, y = Latitude, size=100))+
      borders("state", colour = "white", fill = "grey90") +
      geom_point(aes(x = Longitude, y = Latitude,  size=100, text='HI', color=siteID),stroke=F, alpha=0.7) +
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

