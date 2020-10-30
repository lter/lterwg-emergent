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
library(ggplot2)
#Note: The files are loaded onto the local machine. The folder should be on GitHub and it's name is NeonFiles.
#Make sure to set the working directory as the GitHub "NeonFiles" folder.
#This can be done by clicking Session --> Set Working Directory --> Choose Directory. Then navigate to this directory.

#Loading in the csv files
soilFieldChem <- read.csv(file = 'soilFieldChem.csv')




ui <- fluidPage(
  title = "NEON Shiny App",
  sidebarLayout(
    sidebarPanel(
      selectizeGroupUI(
        id = "my-filters",
        inline = FALSE,
        params = list(
          siteID = list(inputId = "siteID", title = "Select Site ID", choices = c("choose" = "", levels(soilFieldChem$siteID)), selected = 'BART'),
          nlcdClass = list(inputId = "nlcdClass", title = "Select nlcdClass", choices = c("choose" = "", levels(soilFieldChem$nlcdClass)), selected = 'MI'),
          biophysicalCriteria = list(inputId = "biophysicalCriteria", title = "Select biophysicalCriteria", choices = c("choose" = "", levels(soilFieldChem$biophysicalCriteria)), selected='OK'),
          sampleTiming = list(inputId = "sampleTiming", title = "Select sampleTiming", choices = c("choose" = "", levels(soilFieldChem$sampleTiming)), selected='dryWetTransition'),
          soilTemp = list(inputId = "soilTemp", title = "Select soilTemp", choices = c("choose" = "", levels(soilFieldChem$soilTemp)))
        )
      )
    ),
    
    mainPanel(
      tableOutput("table")
      )
    )
  )


server <- function(input, output, session) {
  soilFieldChem <- reactive({ 
    
    soilFieldChem <- soilFieldChem %>% 
      filter(siteID == 'BART') %>% 
      filter(nlcdClass == input$nlcdClass) %>% 
      filter(biophysicalCriteria == input$biophysicalCriteria) %>% 
      filter(sampleTiming == input$sampleTiming) %>% 
      filter(soilTemp == input$soilTemp)
    
})
  
  output$select_siteID <- renderUI({
    
    selectizeInput('siteID', 'Select variable 1', choices = c("select" = "", levels(soilFieldChem$siteID)), selected = "BART")
    
  })
  
  output$select_nlcdClass <- renderUI({
    
    
    choice_var2 <- reactive({
      soilFieldChem %>% 
        filter(siteID = input$siteID) %>% 
        pull(nlcdClass) %>% 
        as.character()
      
    })
    
    selectizeInput('var2', 'Select variable 2', choices = c("select" = "", soilFieldChem$nlcdClass)) # <- put the reactive element here
    
  })
  
  output$select_var3 <- renderUI({
    
    choice_var3 <- reactive({
      soilFieldChem %>% 
        filter(siteID == 'BART') %>% 
        filter(nlcdClass == input$var2) %>% 
        pull(biophysicalCriteria) %>% 
        as.character()
      
    })
    
    selectizeInput('var3', 'Select variable 3', choices = c("select" = "", sfctabe$choice_var3()))
    
  })
  
  output$select_var4 <- renderUI({
    
    choice_var4 <- reactive({
      soilFieldChem %>% 
        filter(siteID == sfctabe$siteID) %>% 
        filter(nlcdClass == input$var2) %>% 
        filter(biophysicalCriteria == input$var3) %>% 
        pull(sampleTiming) %>% 
        as.character()
      
    })
    
    selectizeInput('var4', 'Select variable 4', choices = c("select" = "", choice_var4()))
    
  })
  
  output$select_var5 <- renderUI({
    
    choice_var5 <- reactive({
     soilFieldChem %>% 
        filter(siteID == 'BAR') %>% 
        filter(nlcdClass == input$var2) %>% 
        filter(biophysicalCriteria == input$var3) %>% 
        filter(sampleTiming == input$var4) %>% 
        pull(soilTemp) %>% 
        as.character()
      
    })  
    
    selectizeInput('var5', 'Select variable 5', choices = c("select" = "", choice_var5()))
    
  })
  
  output$table <- renderTable({
    soilFieldChem <- soilFieldChem %>%
      filter(siteID == 'BART') %>% 
      filter(nlcdClass == input$var2) %>% 
      filter(biophysicalCriteria == input$var3) %>% 
      filter(sampleTiming == input$var4) %>% 
      pull(soilTemp) %>% 
      as.character()
    
  })
 
options = list(height = 500)


}

shinyApp(ui = ui, server = server)

