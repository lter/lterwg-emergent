#This is the Shiny app for the Neon data
#Author: Dvir Blander
#First loading in the shiny, dplyr, readr libraries.
#The shiny library is used because this is a shiny app.
#The dplyr and readr libraries are used to help read in the data. 
library(shiny)
library(dplyr)
library(readr)

#Note: The files are loaded onto the local machine. The folder should be on GitHub and it's name is NeonFiles.
#Make sure to set the working directory as the GitHub "NeonFiles" folder.
#This can be done by clicking Session --> Set Working Directory --> Choose Directory. Then navigate to this directory.
#Loading in the csv files
neonFiles <- list.files(pattern = "*.csv")
dat<-lapply(neonFiles,read.csv)

#Next step
#Now need to add option to choose which file to look at.
ui <- fluidPage(
  titlePanel("NEON Shiny App"),
  sidebarLayout(
    sidebarPanel(selectInput("fileInput", "Choose the File Number you want to look at",
                             choices = neonFiles)
    ),
    mainPanel("the results will go here")
  )
)
server <- function(input, output) {}
shinyApp(ui =ui, server = server)