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
grass <- soilFieldChem[grep('grassland|Grassland', soilFieldChem$nlcdClass), ]
forest <- soilFieldChem[grep('forest|Forest', soilFieldChem$nlcdClass), ]

ui <- fluidPage(

  titlePanel("Neon"),
  
  
  sidebarLayout( 
    
    
    sidebarPanel( 
      
      
      selectInput("selection", label = h3("Select box"), 
                  choices = c("All Sites", "Forrested Sites", "Grassland Sites"),
                  selected = 1)
    ),
    
   
    mainPanel(
      plotOutput("distPlot")
      
    ))
)

server <- function(input, output) {

  output$distPlot <- renderPlot({ 
    if (input$selection == "All Sites") {
      x    <-   soilFieldChem
    }
    else if (input$selection == "Grassland Sites" ) {
      x    <-  grass
    }
    else if (input$selection == "Forrested Sites" ) {
      x    <-  forest
    }
    ggplot(x, aes(x=siteID, y=soilTemp)) +
      geom_boxplot() + 
      ylim(c(-20, 50)) +
      theme(axis.text.x = element_text(angle=45)) +
    ggtitle("Soil Temp for Each Site ID")
    
    
 
  }) 
}


# Create Shiny app objects from either an explicit UI/server pair 
shinyApp(ui = ui, server = server)

