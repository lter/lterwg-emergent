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

#Need to join the categorial codes and validation files into one big dataframe each
categoricalcodes <- data.frame(dat[1])
for(k in 2:20) {
  categoricalcodes <- rbind(categoricalcodes, data.frame(dat[k]))
}
validation <- data.frame(dat[21])
for(k in 21:40) {
  validation <- rbind(validation, data.frame(dat[k]))
}

#Next step: get table to show up
ui <- fluidPage(
  titlePanel("NEON Shiny App"),
  sidebarLayout(
    sidebarPanel(
      selectInput("fileInput", "Choose the File you want to look at",
                             choices = c("categoricalcodes", "validation"),
                             selected = "categoricalcodes"
      )
    ),
    mainPanel("The results will go here", 
              tableOutput("results")
    )
  )
)

# error is here, trying to make an output table
server <- function(input, output) {
  output$results <- renderTable({
    filtered <-
      validation %>%
      filter(file == input$fileInput[1]
      )
    filter()
  })
}
shinyApp(ui =ui, server = server)
