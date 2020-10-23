#This is the Shiny app for the Neon data Graphs
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
forestsub <- forest %>%
  group_by(siteID, nlcdClass) %>%
  summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
<<<<<<< HEAD
            mean_soilTemp = mean(soilTemp, na.rm = TRUE), .groups="keep")
grasssub <- grass %>%
  group_by(siteID, nlcdClass) %>%
  summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
            mean_soilTemp = mean(soilTemp, na.rm = TRUE), .groups="keep")
allsub <- soilFieldChem%>%
  group_by(siteID, nlcdClass) %>%
=======
            mean_soilTemp = mean(soilTemp, na.rm = TRUE))

grasssub <- grass %>% 
  group_by(siteID, nlcdClass) %>% 
  summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
            mean_soilTemp = mean(soilTemp, na.rm = TRUE))

allsub <- soilFieldChem%>% 
  group_by(siteID, nlcdClass) %>% 
>>>>>>> parent of 8edd20a... update .groups error
  summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
            mean_soilTemp = mean(soilTemp, na.rm = TRUE))
ui <- fluidPage(
<<<<<<< HEAD
<<<<<<< HEAD
  titlePanel("Neon"),
  sidebarLayout(position = "right",
                tabPanel("Graph",
                         sidebarPanel(      selectInput("selection", label = h3("Select Type of Site"),
                                                        choices = c("All Sites", "Forrested Sites", "Grassland Sites"),
                                                        selected = 1),
                                            selectInput("selection3", label = h3("Soil Temp or Moisture"),
                                                        choices = c("soilTemp", "soilMoisture"),
                                                        selected = 1)
                                            
                         ),
                         mainPanel(plotOutput("distPlot")),
                         mainPanel(plotOutput("distPlot2"))
=======
  
  titlePanel("Neon Graphs"),
  sidebarLayout(position = "left",
                tabPanel("Graph",
                         sidebarPanel(selectInput("selection2", label = h3("Select Type of Site"), 
                                                  choices = c("All Sites", "Forrested Sites", "Grassland Sites"),
                                                  selected = 1),
                                      selectInput("selection4", label = h3("Soil Temp or Moisture"), 
                                                  choices = c("soilTemp", "soilMoisture"),
                                                  selected = 1)
                         )
>>>>>>> parent of 373efc5... Table less columns and WIP for graphs
                ),
                tabPanel("Table",
                         sidebarPanel(      selectInput("selection1", label = h3("Select nlcdClass"),
                                                        choices =  c("choose" = "", levels(soilFieldChem$nlcdClass)), selected = 'evergreenForest
                                                        ' ),
                                            choices =  c("choose" = "", levels(soilFieldChem$nlcdClass)), selected = 'mixedForest' ),
                         selectInput("selection2", label = h3("Select siteID"),
                                     choices = c("choose" = "", levels(soilFieldChem$siteID)), selected = 'BART'),
                         selectInput("selection4", label = h3("Select biophysicalCriteria"),
                                     choices = c("choose" = "", levels(soilFieldChem$biophysicalCriteria)), selected = 'OK - no known exceptions'),
                         selectInput("selection5", label = h3("Select sampleTiming"),
                                     choices = c("choose" = "", levels(soilFieldChem$sampleTiming)), selected='peakGreenness')
                         ),
                mainPanel(DT::dataTableOutput("table"))
                )
=======
  titlePanel("Neon Graphs"),
  sidebarLayout(position = "left",
                tabPanel("Graph",
                         sidebarPanel(selectInput("selection", label = h3("Select Type of Site"), 
                                                  choices = c("All Sites", "Forrested Sites", "Grassland Sites"),
                                                  selected = 1),
                                      selectInput("selection3", label = h3("Soil Temp or Moisture"), 
                                                  choices = c("soilTemp", "soilMoisture"),
                                                  selected = 1),
                                      selectInput("selection1", label = h3("Select nlcdClass"), 
                                                  choices =  c("choose" = "", levels(soilFieldChem$nlcdClass)), selected = 'mixedForest' ),
                                      selectInput("selection2", label = h3("Select siteID"), 
                                                  choices = c("choose" = "", levels(soilFieldChem$siteID)), selected = 'BART')
                         )
                ),
                mainPanel(plotOutput("distPlot")),
                mainPanel(plotOutput("distPlot2"))   
>>>>>>> parent of 8edd20a... update .groups error
  )
)


server <- function(input, output) {
<<<<<<< HEAD
  tab <- reactive({

    soilFieldChem %>%
      filter(nlcdClass == input$selection1) %>%
      filter(siteID == input$selection2) %>%
      filter(biophysicalCriteria == input$selection4) %>%
      filter(sampleTiming == input$selection5 )

<<<<<<< HEAD
  })
  output$table <-DT::renderDataTable({
    tab()

  })
=======
>>>>>>> parent of 8edd20a... update .groups error
  output$select_s1 <- renderUI({

    selectizeInput('s1', 'Select variable 1', choices = c("select" = "", levels(soilFieldChem$selection1)))

  })

  output$select_selection2 <- renderUI({


=======
server <- function(input, output) {
  output$select_selection2 <- renderUI({
>>>>>>> parent of 373efc5... Table less columns and WIP for graphs
    choice_selection2 <- reactive({
      soilFieldChem %>%
        filter(selection1 == input$s1) %>%
        pull(selection2) %>%
        as.character()

    })
  })

  output$selection4 <- renderUI({

    choice_selection4 <- reactive({
      soilFieldChem %>%
        filter(selection1 == input$s1) %>%
        filter(selection2 == input$s2) %>%
        pull(selection4) %>%
        as.character()

    })
  })
<<<<<<< HEAD

  output$distPlot <- renderPlot({
=======
  
  output$distPlot <- renderPlot({ 
    
>>>>>>> parent of 8edd20a... update .groups error
    if (input$selection == "All Sites") {
      x    <-   soilFieldChem
    }
    else if (input$selection == "Grassland Sites" ) {
      x    <-  grass
    }
    else if (input$selection == "Forrested Sites" ) {
      x    <-  forest
    }
<<<<<<< HEAD

=======
    
    
>>>>>>> parent of 8edd20a... update .groups error
    ggplot(x, aes(x=siteID, y= !!sym(input$selection3))) +
      geom_boxplot() +
      ylim(c(-20, 50)) +
      theme(axis.text.x = element_text(angle=45)) +
      ggtitle("for Each Site ID")



  })
  output$distPlot2 <- renderPlot ({
    if (input$selection == "All Sites") {
      x    <-   soilFieldChem
    }
    else if (input$selection == "Grassland Sites" ) {
      x    <-  grass
    }
    else if (input$selection == "Forrested Sites" ) {
      x    <-  forest
    }

    xsub <- x %>%
      group_by(siteID, nlcdClass) %>%
      summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
<<<<<<< HEAD
                mean_soilTemp = mean(soilTemp, na.rm = TRUE), .groups="keep")

    g1 <- ggplot(xsub, aes(x=mean_soilMoisture, y=mean_soilTemp, color = siteID, label = siteID)) +
=======
                mean_soilTemp = mean(soilTemp, na.rm = TRUE)) 
    
    g1 <- ggplot(xsub, aes(x=mean_soilMoisture, y=mean_soilTemp, color = siteID, label = siteID)) + 
>>>>>>> parent of 8edd20a... update .groups error
      geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
      xlim(c(0, 4)) +
      ylim(c(0, 30)) +
      ggtitle('Soil Moisture x Temperatue Forested Plots')
<<<<<<< HEAD
<<<<<<< HEAD
    g1
=======
    g1 
>>>>>>> parent of 373efc5... Table less columns and WIP for graphs
  })
}
# Create Shiny app objects from either an explicit UI/server pair
shinyApp(ui = ui, server = server)
=======
    g1  
  })
}


# Create Shiny app objects from either an explicit UI/server pair 
shinyApp(ui = ui, server = server)
>>>>>>> parent of 8edd20a... update .groups error
