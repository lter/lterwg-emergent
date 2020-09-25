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
neonFiles <- list.files(pattern = "*.csv")
dat<-lapply(neonFiles,read.csv)

#Need to join the categorial codes and validation files into one big dataframe each
categoricalcodes <- data.frame(dat[1])
for(k in 2:20) {
  categoricalcodes <- rbind(categoricalcodes, data.frame(dat[k]))
}
validation <- data.frame(dat[21])
for(k in 22:40) {
  validation <- rbind(validation, data.frame(dat[k]))
}


ui <- fluidPage(
  title = "NEON Shiny App",
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "pubCode", "Select pubcode", choices=c("All", sort(unique("pubCode")))),
      conditionalPanel(
        'input.dataset === "categoricalCodes"',
        helpText("Click the tab that you want to look at.")
      ),
      conditionalPanel(
        'input.dataset === "validation"',
        helpText("Click the tab that you want to look at.")
      )
    ),
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("categoricalCodes", DT::dataTableOutput("mytable1")),
        tabPanel("validation", DT::dataTableOutput("mytable2"))
      )
    )
  )
)

server <- function(input, output) {
  
  # sorted columns are colored now because CSS are attached to them
  output$mytable1 <- DT::renderDataTable({
    reactive_data <- reactive({
      categoricalcodes %>%
        filter(variable1 == input$pubCode)    
      
    }) 
    DT::datatable(categoricalcodes, options = list(orderClasses = TRUE))
  })
  
  # customize the length drop-down menu; display 5 rows per page by default
  output$mytable2 <- DT::renderDataTable({
    DT::datatable(validation, options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  })
  
}
shinyApp(ui = ui, server = server)
