#This is the Shiny app for the Neon data
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
#Note: The files are loaded onto the local machine. The folder should be on GitHub and it's name is NeonFiles.
#Make sure to set the working directory as the GitHub "NeonFiles" folder.
#This can be done by clicking Session --> Set Working Directory --> Choose Directory. Then navigate to this directory.

#Loading in the csv files
soilFieldChem <- read.csv(file = 'soilFieldChem.csv')
#<<<<<<< HEAD
grass <- soilFieldChem[grep('grassland|Grassland', soilFieldChem$nlcdClass), ]
forest <- soilFieldChem[grep('forest|Forest', soilFieldChem$nlcdClass), ]
#=======
#>>>>>>> parent of 373efc5... Table less columns and WIP for graphs


ui <- fluidPage(
  selectInput("siteTYPE", "Select Site Type", choices = c("All Sites", "Forrested Sites", "Grassland Sites")),
  plotOutput("BoxPlot")
)


server <- function(input, output, session) {
  siteTypeData <- reactive({
    input$siteTYPE
    
    if (input$siteType == "All  Sites") {
      siteData <- soilFieldChem
    }
    else if (input$siteType == "Grassland Sites") {
      siteData <-soilFieldChem[grep('grassland|Grassland', soilFieldChem$nlcdClass), ]
    }
    else if (input$siteType == "Forrested Sites") {
      siteData <- soilFieldChem[grep('forest|Forest', soilFieldChem$nlcdClass), ]
    }
  })
  g1 <- ggplot(siteData, aes(x=siteID, y=soilTemp)) 
  geom_boxplot() + 
    ylim(c(-20, 50)) +
    theme(axis.text.x = element_text(angle=45)) +
    ggtitle(input$siteType)
  
  ggplotly(g1)
  
  output$BoxPlot <- renderPlot({
    plotOutput(g1)
  })
} 
  
shinyApp(ui = ui, server = server)  
  
  