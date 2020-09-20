#This is the Shiny app for the Neon data
#Author: Dvir Blander
#First loading in the shiny library
library(shiny)

#Note: The files are loaded onto the local machine. The folder should be on GitHub and it's name is NeonFiles.
#Make sure to set the working directory as the GitHub "code" folder.
#Looping through the folder to load each csv file separately.
#Still WIP
neonFiles <- list.files(path = "./NeonFiles/", pattern = "*.csv")
myfiles <- lapply(neonFiles, read.delim)

#bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)
ui <- fluidPage()
server <- function(input, output) {}
shinyApp(ui =ui, server = server)