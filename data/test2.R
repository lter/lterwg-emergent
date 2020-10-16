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
  tabPanel("Graph",
           sidebarPanel(      selectInput("selection", label = h3("Select Type of Site"), 
                                          choices = c("All Sites", "Forrested Sites", "Grassland Sites"),
                                          selected = 1),
                              selectInput("selection3", label = h3("Soil Temp or Moisture"), 
                                          choices = c("soilTemp", "soilMoisture"),
                                          selected = 1)
                              ),
           mainPanel(plotOutput("distPlot"))
  ),
  tabPanel("Table",
           sidebarPanel(      selectInput("selection1", label = h3("Select nlcdClass"), 
                                          choices =  c("choose" = "", levels(soilFieldChem$nlcdClass)), selected = 'MI'),
                              selectInput("selection2", label = h3("Select Type of Site"), 
                                          choices = c("choose" = "", levels(soilFieldChem$siteID)), selected = 'BART')
           ),
           mainPanel(tableOutput("table"))
  )
    )


server <- function(input, output) {

  tab <- reactive({ 
    
    soilFieldChem %>% 
      filter(nlcdClass == input$selection1) %>% 
      filter(siteID == input$selection2) 
    
  })
  output$table <-renderTable({
    tab()
    
  })
  output$select_s1 <- renderUI({
    
    selectizeInput('s1', 'Select variable 1', choices = c("select" = "", levels(soilFieldChem$selection1)))
    
  })
  
  output$select_selection2 <- renderUI({
    
    
    choice_selection2 <- reactive({
      soilFieldChem %>% 
        filter(selection1 == input$s1) %>% 
        pull(selection2) %>% 
        as.character()
      
    })
  })
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
    ggplot(x, aes(x=siteID, y= !!sym(input$selection3))) +
      geom_boxplot() + 
      ylim(c(-20, 50)) +
      theme(axis.text.x = element_text(angle=45)) +
    ggtitle("for Each Site ID")
    
    
 
  }) 
}

options = list(height = 500)
# Create Shiny app objects from either an explicit UI/server pair 
shinyApp(ui = ui, server = server)

