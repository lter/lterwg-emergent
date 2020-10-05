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

#Note: The files are loaded onto the local machine. The folder should be on GitHub and it's name is NeonFiles.
#Make sure to set the working directory as the GitHub "NeonFiles" folder.
#This can be done by clicking Session --> Set Working Directory --> Choose Directory. Then navigate to this directory.

#Loading in the csv files
neonFiles <- list.files(pattern = "*.csv")
dat<-lapply(neonFiles,read.csv)

#adding all of theHARVARD soil files
#each file has a different number of columns so they will be separated for now
harvard1 <-  data.frame(dat[1])
harvard2 <-  data.frame(dat[2])
harvard3 <-  data.frame(dat[3])

#Need to join the categorial codes and validation files into one big dataframe each
categoricalcodes <- data.frame(dat[4])
for(k in 5:23) {
  categoricalcodes <- rbind(categoricalcodes, data.frame(dat[k]))
}
validation <- data.frame(dat[24])
for(k in 25:44) {
  validation <- rbind(validation, data.frame(dat[k]))
}


ui <- fluidPage(
  title = "NEON Shiny App",
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "pubCode", "Select pubcode", choices=c("All", sort(unique("pubCode")))),
      conditionalPanel(
        'input.dataset === "harvard1"',
        helpText("Click the tab that you want to look at.")
      ),
      conditionalPanel(
        'input.dataset === "harvard2"',
        helpText("Click the tab that you want to look at.")
      ),
      conditionalPanel(
        'input.dataset === "harvard3"',
        helpText("Click the tab that you want to look at.")
      ),
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
        tabPanel("harvard1", DT::dataTableOutput("mytable1")),
        tabPanel("harvard2", DT::dataTableOutput("mytable2")),
        tabPanel("harvard3", DT::dataTableOutput("mytable3")),
        tabPanel("categoricalCodes", DT::dataTableOutput("mytable4")),
        tabPanel("validation", DT::dataTableOutput("mytable5"))
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
    DT::datatable(harvard1, filter='top', options = list(orderClasses = TRUE))
  })
  
  output$mytable2 <- DT::renderDataTable({
    reactive_data <- reactive({
      categoricalcodes %>%
        filter(variable1 == input$pubCode)    
      
    }) 
    DT::datatable(harvard2, filter='top', options = list(orderClasses = TRUE))
  })
  
  output$mytable3 <- DT::renderDataTable({
    reactive_data <- reactive({
      categoricalcodes %>%
        filter(variable1 == input$pubCode)    
      
    }) 
    DT::datatable(harvard3, filter='top', options = list(orderClasses = TRUE))
  })
  
  output$mytable4 <- DT::renderDataTable({
    reactive_data <- reactive({
      categoricalcodes %>%
        filter(variable1 == input$pubCode)    
      
    }) 
    DT::datatable(categoricalcodes, filter='top', options = list(orderClasses = TRUE))
  })
  
  # customize the length drop-down menu; display 5 rows per page by default
  output$mytable5 <- DT::renderDataTable({
    DT::datatable(validation, options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  })
  
}
shinyApp(ui = ui, server = server)
