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
soilfiltered <- soilFieldChem %>% 
  filter(siteID == 'BART') %>% 
  filter(nlcdClass == 'mixedForest') %>% 
  filter(biophysicalCriteria == 'OK - no known exceptions') 

