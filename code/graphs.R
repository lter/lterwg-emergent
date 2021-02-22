#This is the Shiny app for the Neon data showcasing the graphs for the NEON data
#Author: Dvir Blander and Katrina Newcomer
#First loading in the shiny, dplyr, readr libraries.
#The shiny library is used because this is a shiny app.
#The dplyr and readr libraries are used to help read in the data.
library(ggplot2)
library(shiny)
library(dplyr)
library(readr)
library(shinyWidgets)
library(tidyverse)
library(maps)
library(mapdata)
library(lubridate)
library(viridis)
library(wesanderson)
library(plotly)

#Note: The file needed is called soilFieldChem.csv and it is already in the same directory as this file.
#Loading in the csv file

soilFieldChem <- read.csv(file = 'soilFieldChem.csv')
soilFieldPh <- read.csv(file = 'soilFieldPh.csv')
grass <- soilFieldChem[grep('grassland|Grassland', soilFieldChem$nlcdClass), ]
forest <- soilFieldChem[grep('forest|Forest', soilFieldChem$nlcdClass), ]
forestsub <- forest %>%
  group_by(siteID, nlcdClass) %>%
  summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
            mean_soilTemp = mean(soilTemp, na.rm = TRUE), .groups="keep")
Grass <- soilFieldPh[grep('grassland|Grassland', soilFieldPh$nlcdClass), ]
Forest <- soilFieldPh[grep('forest|Forest', soilFieldPh$nlcdClass), ]
Forestsub <- Forest %>%
  group_by(siteID, nlcdClass) %>%
  summarise(soilMoisture = mean(soilMoisture, na.rm = TRUE),
            soilTemp = mean(soilTemp, na.rm = TRUE), soilInCaClpH = soilInCaClpH, .groups="keep")
Grasssub <- Grass %>%
  group_by(siteID, nlcdClass) %>%
  summarise(soilMoisture = mean(soilMoisture, na.rm = TRUE),
            soilTemp = mean(soilTemp, na.rm = TRUE), soilInCaClpH = soilInCaClpH, .groups="keep")
grasssub <- grass %>%
  group_by(siteID, nlcdClass) %>%
  summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
            mean_soilTemp = mean(soilTemp, na.rm = TRUE), .groups="keep")
allsub <- soilFieldChem%>%
  group_by(siteID, nlcdClass) %>%
  summarise(mean_soilMoisture = mean(soilMoisture, na.rm = TRUE),
            mean_soilTemp = mean(soilTemp, na.rm = TRUE), .groups="keep")
soilFieldChem$collectDate.x <- as.Date(soilFieldChem$collectDate.x, format = "%m/%d/%Y")
mindate<- min(soilFieldChem$collectDate.x)
maxdate <- max(soilFieldChem$collectDate.x)
soilT <- soilFieldChem%>%
  group_by(siteID, nlcdClass) %>%
  summarise(soilTemp = soilTemp, .groups="keep")

soilM <- soilFieldChem %>%
  group_by(siteID, nlcdClass) %>%
  summarise(soilMoisture = soilMoisture, .groups="keep")
gsi <- " "
soilP <- soilFieldPh %>%
  group_by(siteID, nlcdClass) %>%
    summarise(soilInCaClpH = soilInCaClpH, .groups="keep")
ui <- fluidPage(
  titlePanel("Neon Graphs"),
  sidebarPanel(
    conditionalPanel(condition="input.conditionedPanels== 'BoxPlot' ", selectInput("siteType", "Select Site Type", choices = c("All Sites", "Forrested Sites", "Grassland Sites")),
                     selectInput("tempmoist", "Select Either Temperature or Moisture", choices = c("Temperature", "Moisture", "soilInCaClpH"))),
    conditionalPanel(condition="input.conditionedPanels== '2 Variable' ", selectInput("var1", "Select variable 1", choices = c("soilMoisture", "soilTemp", "soilInCaClpH")),
                     selectInput("var2", "Select variable 2", choices = c("soilTemp","soilMoisture",  "soilInCaClpH")),
                     checkboxInput("siteIDCheck", "Show Site ID", value = FALSE), selectInput("siteType2", "Select Site Type", choices = c("Forrested Sites","All Sites",  "Grassland Sites"))),
    conditionalPanel(condition="input.conditionedPanels == 'map' ", selectInput("siteType1", "Select ncldClass", choices = c("All Sites","deciduousForest","dwarfScrub","emergentHerbaceousWetlands","evergreenForest","grasslandHerbaceous","mixedForest","sedgeHerbaceous","shrubScrub","woodyWetlands")),
                     
                     selectInput("sampleTime", "Select Sample Timing", choices = c("All Options","winterSpringTransition
", "other","peakGreenness
","fallWinterTransition
")),sliderInput("MinTemp", ("Input lowest Temp"),min=0, max=100, 
                               value = c(10,100)), sliderInput("minSoil", ("Input lowest soil moisture"), min=0, max=100, 
                                                        value =c(10,100)), sliderInput("date_slider", label = h3("Date Range"), min = mindate, 
                                                                                       max = maxdate, value = c(mindate, maxdate)), textInput(gsi,"Genetic Sample ID", value = "") )
    
    
    ),
  mainPanel (
    tabsetPanel(
      id="conditionedPanels",
        tabPanel("BoxPlot", plotOutput("boxplot", width = "100%", height = "800px")),
        tabPanel("2 Variable",plotOutput("both", width = "100%", height = "800px")),
        tabPanel("map", plotlyOutput("no", width = "100%", height = "800px"))
    ),
    img(src = "LTER-logo.png", height = "25%", width = "25%", align = "left"),
    img(src = "neon_banner.png", height = "25%", width = "25%", align = "left")
  )
)


server <- function(input, output) {
  #plotting the boxplot based on the selected site and temp/moisture
  output$boxplot <- renderPlot({
    #selecting site
    site = allsub
    if(input$siteType == "All Sites") {
      site = allsub
    } else if(input$siteType == "Forrested Sites") {
      site = forestsub
    } else if(input$siteType == "Grassland Sites") {
      site = grasssub
    }
    
    #selecting either temperature or mositure
    if(input$tempmoist == "Temperature") {
      ggplot(site, mapping = aes(x = siteID, y = mean_soilTemp, color=siteID, fill=siteID)) + 
        geom_boxplot() + 
        ylim(c(0, 30)) +
        theme(axis.text.x = element_text(angle=45)) +
        ggtitle(input$siteType)
    } else if(input$tempmoist == "Moisture") {
      ggplot(site, mapping = aes(x = siteID, y = mean_soilMoisture, color=siteID, fill=siteID)) + 
        geom_boxplot() + 
        ylim(c(0, 7.5)) +
        theme(axis.text.x = element_text(angle=45)) +
        ggtitle(input$siteType)
    }
    else {
      ggplot(soilFieldPh, mapping = aes(x = siteID, y = soilInCaClpH)) + 
      geom_boxplot() + 
      ylim(c(1, 10)) +
      theme(axis.text.x = element_text(angle=45)) +
      ggtitle(input$siteType)
    }
  })
  
  #plotting the relationship for temp and moisture based on the siteID
  output$both <- renderPlot({

    #selecting site
    site = soilFieldPh
    if(input$siteType2 == "All Sites") {
      site = soilFieldPh
    } else if(input$siteType2 == "Forrested Sites") {
      site = Forestsub
    } else if(input$siteType2 == "Grassland Sites") {
      site = Grasssub
    }
  
    if(input$var1 == "soilInCaClpH") {
      if(input$var2 == "soilMoisture") {
        if(input$siteIDCheck == TRUE){
        g1 <- ggplot(site, aes(x=soilInCaClpH, y=soilMoisture, color = siteID, label = siteID)) + 
          geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
          ggtitle('Soil Moisture x Calcium Chloride in Soil')
        g1
        }
        else {
          g1 <- ggplot(site, aes(x=soilInCaClpH, y=soilMoisture, color = siteID)) + 
            geom_point() +
            ggtitle('Soil Moisture x Calcium Chloride in Soil')
          g1
        }
      }
  
      else if (input$var2 == "soilTemp") {
        if(input$siteIDCheck == TRUE) {
        g1 <- ggplot(site, aes(x=soilInCaClpH, y=soilTemp, color = siteID, label = siteID)) + 
          geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
          ggtitle('Soil Moisture x Soil Temperature')
        g1
        }
        else {
          g1 <- ggplot(site, aes(x=soilInCaClpH, y=soilTemp, color = siteID)) + 
            geom_point() + 
            ggtitle('Soil Moisture x Soil Temperature')
          g1
        }
      }
      else {
        if(input$siteIDCheck == TRUE) {
        g1 <- ggplot(site, aes(x=soilInCaClpH, y=soilInCaClpH, color = siteID, label = siteID)) + 
          geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
          ggtitle('Soil Moisture x Temperatue Forested Plots')
        g1
        }
        else {
          g1 <- ggplot(site, aes(x=soilInCaClpH, y=soilInCaClpH, color = siteID)) + 
            geom_point() + 
            ggtitle('Soil Moisture x Temperatue Forested Plots')
          g1
        }
      }
  }
   else if(input$var1 == "soilMoisture") {
      if(input$var2 == "soilMoisture") {
        if(input$siteIDCheck == TRUE) {
        g1 <- ggplot(site, aes(x=soilMoisture, y=soilMoisture, color = siteID, label=siteID)) + 
          geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
          ggtitle('Soil Moisture x Temperatue Forested Plots')
        g1
        }
        else {
          g1 <- ggplot(site, aes(x=soilMoisture, y=soilMoisture, color = siteID)) + 
            geom_point() +
            ggtitle('Soil Moisture x Temperatue Forested Plots')
          g1
        }
      }
      
    else if (input$var2 == "soilTemp") {
      if(input$siteIDCheck == TRUE) {
      g1 <- ggplot(site, aes(x=soilMoisture, y=soilTemp, color = siteID, label = siteID)) + 
        geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
        ggtitle('Soil Moisture x Temperature')
      g1
      }
      else {
        g1 <- ggplot(site, aes(x=soilMoisture, y=soilTemp, color = siteID)) + 
          geom_point() +
          ggtitle('Soil Moisture x Temperature')
        g1
      }
    }
    else {
      if(input$siteIDCheck == TRUE) {
      g1 <- ggplot(site, aes(x=soilMoisture, y=soilInCaClpH, color = siteID, label = siteID)) + 
        geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
        ggtitle('Soil Moisture x Calcium Chloride in Soil')
      g1
      }
      else {
        g1 <- ggplot(site, aes(x=soilMoisture, y=soilInCaClpH, color = siteID)) + 
          geom_point() +
          ggtitle('Soil Moisture x Calcium Chloride in Soil')
        g1
      }
    }
  }
    else if(input$var1 == "soilTemp") {
      if(input$var2 == "soilMoisture") {
        if(input$siteIDCheck == TRUE) {
        g1 <- ggplot(site, aes(x=soilTemp, y=soilMoisture, color = siteID, label = siteID)) + 
          geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
          ggtitle('Soil Moisture x Calcium Chloride in Soil')
        g1
        }
        else {
          g1 <- ggplot(site, aes(x=soilTemp, y=soilMoisture, color = siteID)) + 
            geom_point() +
            ggtitle('Soil Moisture x Calcium Chloride in Soil')
          g1
        }
      }
      
      else if (input$var2 == "soilTemp") {
        if(input$siteIDCheck == TRUE) {
        g1 <- ggplot(site, aes(x=soilTemp, y=soilTemp, color = siteID, label = siteID)) + 
          geom_point() + geom_text(aes(label=siteID),hjust=-0.2, vjust=0.5) +
          ggtitle('Soil Temperature x Calcium Chloride in Soil')
        g1
        }
        else {
          g1 <- ggplot(site, aes(x=soilTemp, y=soilTemp, color = siteID)) + 
            geom_point() +
            ggtitle('Soil Temperature x Calcium Chloride in Soil')
          g1
          
        }
      }
      else {
        if(input$siteIDCheck == TRUE) {
          
          g1 <- ggplot(site, aes(x=soilTemp, y=soilTemp, color = siteID)) + 
            geom_point() + 
            ggtitle('Soil Moisture x Temperatue Forested Plots')
          g1

        }
        else {
          g1 <- ggplot(site, aes(x=soilTemp, y=soilTemp, color = siteID)) + 
            geom_point() +
            ggtitle('Error')
          g1
        }
      }
    }

  })
  
  output$no <- renderPlotly({
    site = soilFieldChem 
    if(input$siteType1 == "All Sites") {
      site = soilFieldChem 
    } else if(input$siteType1 == "Forrested Sites") {
      site = forest 
    } else if(input$siteType1 == "Grassland Sites") {
      site = grass
    }
    if(input$sampleTime == "All Options") {
      site%>% filter(nlcdClass=="dwarfScrub")
      soilFieldChema <- filter(site, soilTemp > input$MinTemp[1], soilTemp < input$MinTemp[2], soilMoisture > input$minSoil[1], soilMoisture < input$minSoil[2], Latitude > 20)
    }
    else if (input$sampleTime == "winterSpringTransition") {
      soilFieldChema <- filter(site, sampleTiming == "winterSpringTransition", soilTemp > input$MinTemp[1], soilMoisture > input$minSoil[1])
    }
    else {
      soilFieldChema <- filter(site, sampleTiming == input$sampleTime, soilTemp > input$MinTemp[1], soilMoisture > input$minSoil[1] )
    }
    
    print(soilFieldChem)
p <- ggplot(data=soilFieldChema,  aes(x = Longitude, y = Latitude))+
      borders("state", colour = "white", fill = "grey90") +
      geom_point(aes(x = Longitude, y = Latitude,  size=10, text=paste("Site ID: ", siteID, "<br> Latitude: ", Latitude, "<br> Longitude: ", Longitude), color=nlcdClass),stroke=F, alpha=0.7) +
      theme_void() + 
      guides( colour = guide_legend()) +
      labs(title = "Sites") +
      theme(
        legend.position = "bottom",
        text = element_text(color = "#22211d"),
        plot.background = element_rect(fill = "#ffffff", color = NA), 
        panel.background = element_rect(fill = "#ffffff", color = NA), 
        legend.background = element_rect(fill = "#ffffff", color = NA)
      ) +
      coord_fixed(ratio=1.5)
p <- ggplotly(p, tooltip="text")
p

  })
}
# Create Shiny app objects from either an explicit UI/server pair
shinyApp(ui = ui, server = server)

