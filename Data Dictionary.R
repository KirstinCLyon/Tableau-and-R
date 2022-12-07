
# Instructions for preparing Tableau File ----
# Unpack to get the twb
# rename the twb to an xml


# Libraries ----

library(tidyverse)
library(glamr) #for setting up the USAID way
library(xml2)




# Folder structure ----
folder_setup(
    folder_list = list("Data", "Images", "Scripts", "AI", "Dataout", "GIS", "Documents",
                       "Graphics", "markdown", "Tableau")
)


# Global Variables in all caps ----


# Read data ----
twb_file <- read_xml("Data/Test.xml")


# Isolate datasources part of xml ----
datasources_twb <- xml_child(twb_file, "datasources")
datasources_twb

# There are two "datasources" - the top relates to parameters, and the bottom relates to fields 

all_columns <- xml_find_all(datasources_twb, xpath=".//column")

#Questions:  why do you get the fields with no calculations 3 times? and the calculations 3 times?  and why are calculations kept in a separate list?
