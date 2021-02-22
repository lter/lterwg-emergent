#This is the Shiny app for the Neon data showcasing the tables of the data
#Author: Dvir Blander and Katrina Newcomer
#First loading in the shiny, dplyr, readr libraries.
#The shiny library is used because this is a shiny app.
#The dplyr and readr libraries are used to help read in the data. 
#The DT library is used for the datatables
library(plotly)
library(shiny)
library(dplyr)
library(readr)
library(DT)
library(shinyWidgets)
#Note: The file needed is called soilFieldChem.csv and it is already in the same directory as this file.
#Loading in the csv file
soilFieldChem <- read.csv(file = 'soilFieldChem.csv')
soilFieldChem <- soilFieldChem[-c(72:113)]
nTransData <- read.csv(file = 'sls_nTransData_20210206.csv')
truncated_nTransData <- nTransData[ , c("sampleID","kclAmmoniumNConc", "ammoniumNRepNum","kclNitrateNitriteNConc")]
df <- soilFieldChem %>% right_join(truncated_nTransData, by = "sampleID")
df <- df[!is.na(df$collectDate.x),]
df$collectDate.x <- as.Date(df$collectDate.x, format = "%m/%d/%Y")
mindate<- min(df$collectDate.x)
maxdate <- max(df$collectDate.x)

ui <- fluidPage(
  titlePanel("Neon Data Table"),
  sidebarLayout(position = "left",
                tabPanel("Table",
                         sidebarPanel(selectInput("selection1", label = h3("Select nlcdClass"), 
                                                  choices =  c("choose" = "", levels(df$nlcdClass)), selected = 'mixedForest' ),
                                      selectInput("selection2", label = h3("Select siteID"), 
                                                  choices = c("choose" = "", levels(df$siteID)), selected = 'HARV'),
                                      selectInput("selection5", label = h3("Select sampleTiming"), 
                                                  choices = c("choose" = "", levels(df$sampleTiming)), selected='peakGreenness'),
                                      sliderInput("date_slider", label = h3("Date Range"), min = mindate, 
                                                  max = maxdate, value = c(mindate, maxdate)),
                                      downloadButton("downloadData", "Download")
                         )
                         
                         
                ),
                mainPanel(
                  DT::dataTableOutput("table"),
                  img(src = "neon_banner.png", height = "25%", width = "25%", align = "left"),
                  img(src = "soil_emergent3.png", height = "25%", width = "25%", align = "left")
                )
  )
)


server <- function(input, output) {
  
  tab <- reactive({ 
    df <- df %>%
      filter(nlcdClass == input$selection1) %>% 
      filter(siteID == input$selection2) %>%
      filter(sampleTiming == input$selection5 ) %>%
      filter(collectDate.x >= input$date_slider[1] & collectDate.x <= input$date_slider[2]) %>%
      filter(!is.na(geneticArchiveSample1ID) | !is.na(geneticArchiveSample2ID) | !is.na(geneticArchiveSample3ID) | 
             !is.na(geneticArchiveSample4ID) | !is.na(geneticArchiveSample5ID))
  })
  
  
  output$table <-DT::renderDataTable({
    DT::datatable(tab(),filter = "top", 
                  extensions = 'Buttons', options = list(dom = 'Bfrtip',    buttons = list(
                    #list(
                     # extend = 'colvis', 
                      #columns = c(0,10:30,31:70)
                    #),
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
                    list(targets = c(0,10:30,31:75), visible = FALSE)
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

