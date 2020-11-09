#This is the Shiny app for the Neon data showcasing the tables of the data
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
soilFieldChem <- soilFieldChem[-c(72:113)]

ui <- fluidPage(
  titlePanel("Neon Data Table"),
  sidebarLayout(position = "left",
                tabPanel("Table",
                         sidebarPanel(selectInput("selection1", label = h3("Select nlcdClass"), 
                                                  choices =  c("choose" = "", levels(soilFieldChem$nlcdClass)), selected = 'mixedForest' ),
                                      selectInput("selection2", label = h3("Select siteID"), 
                                                  choices = c("choose" = "", levels(soilFieldChem$siteID)), selected = 'BART'),
                                      selectInput("selection5", label = h3("Select sampleTiming"), 
                                                  choices = c("choose" = "", levels(soilFieldChem$sampleTiming)), selected='peakGreenness'),
                                      downloadButton("downloadData", "Download")
                         )
                         
                         
                ),
                mainPanel(
                  DT::dataTableOutput("table"),
                  img(src = "LTER-logo.png", height = "25%", width = "25%", align = "left"),
                  img(src = "NCEAS-logo.png", height = "20%", width = "20%", align = "left"),
                  img(src = "neon_banner.png", height = "25%", width = "25%", align = "left"),
                  img(src = "soil_emergent3.png", height = "25%", width = "25%", align = "left")
                )
  )
)


server <- function(input, output) {
  
  tab <- reactive({ 
    soilFieldChem <- soilFieldChem %>% 
      filter(nlcdClass == input$selection1) %>% 
      filter(siteID == input$selection2) %>%
      filter(sampleTiming == input$selection5 )
  })
  
  
  output$table <-DT::renderDataTable({
    DT::datatable(tab(),filter = "top", 
                  extensions = 'Buttons', options = list(dom = 'Bfrtip',    buttons = list(
                    list(
                      extend = 'colvis', 
                      columns = c(0,10:30,31:70)
                    ),
                    list(
                      extend = 'colvisGroup', 
                      text = "Show all",
                      show = ":hidden"
                    ),
                    list(
                      extend = 'colvisGroup', 
                      text = "Show none",
                      hide = ":visible"
                    )
                  ),
                  columnDefs = list(
                    list(targets = c(0,10:30,31:71), visible = FALSE)
                  )
                  )
    )
    
  }) 
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("NeonDataTable", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(tab(), file)
    }
  )
}

shinyApp(ui = ui, server = server)  

