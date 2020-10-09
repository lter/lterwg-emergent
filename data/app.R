#This is the Shiny app for the Neon data
#Author: Dvir Blander and Katrina Newcomer
#First loading in the shiny, dplyr, readr libraries.
#The shiny library is used because this is a shiny app.
#The dplyr and readr libraries are used to help read in the data. 
#The DT library is used for the datatables
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


shinyApp(
  ui = pageWithSidebar(
    headerPanel("Painting 8"),
    sidebarPanel(
      selectizeGroupUI(
        id = "my-filters",
        inline = FALSE,
        params = list(
          siteID = list(inputId = "siteID", title = "Select variable 1", placeholder = 'select'),
          nlcdClass = list(inputId = "nlcdClass", title = "Select variable 2", placeholder = 'select'),
          sampleTiming = list(inputId = "sampleTiming", title = "Select variable 3", placeholder = 'select'),
          incubationMethod = list(inputId = "incubationMethod", title = "Select variable 4", placeholder = 'select'),
          domainID = list(inputId = "domainID", title = "Select variable 5", placeholder = 'select')
        )
      )
    ),
    
    mainPanel(
      tableOutput("table")
    )
  ),
  
  server = function(input, output, session) {
    
    res_mod <- callModule(
      module = selectizeGroupServer,
      id = "my-filters",
      data = soilFieldChem,
      vars = c("siteID", "nlcdClass", "sampleTiming", "incubationMethod", "domainID")
    )
    
    output$table <- renderTable({
      res_mod()
    })
    
  },
  
  options = list(height = 500)
)


shinyApp(ui = ui, server = server)

