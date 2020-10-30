#This is the Shiny app for the Neon data
#Author: Dvir Blander
#First loading in the shiny, dplyr, readr libraries.
#The shiny library is used because this is a shiny app.
#The dplyr and readr libraries are used to help read in the data. 
#The DT library is used for the datatables
library(shiny)
library(dplyr)
library(readr)
library(DT)

#Note: The files are loaded onto the local machine. The folder should be on GitHub and it's name is NeonFiles.
#Make sure to set the working directory as the GitHub "NeonFiles" folder.
#This can be done by clicking Session --> Set Working Directory --> Choose Directory. Then navigate to this directory.
#Loading in the csv files
soil <- list.files(pattern = "*.csv")
dat<-lapply(soil,read.csv)



ui <- fluidPage(
  title = "NEON Shiny App",
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("categoricalCodes", DT::dataTableOutput("soil"))      )
    )
  )


server <- function(input, output) {
  
  # sorted columns are colored now because CSS are attached to them
  output$soil <- DT::renderDataTable({
    DT::datatable(soil,options = list(orderClasses = TRUE))
  })
  
  
}
shinyApp(ui = ui, server = server)


