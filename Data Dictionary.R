
# Instructions for preparing Tableau File ----
# Unpack to get the twb
# rename the twb to an xml


# Libraries ----

library(tidyverse)
library(glamr) #for setting up the USAID way
library(xml2)
library(XML)
library(data.table)




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
# https://www.w3schools.com/XML/xml_xpath.asp




# Data Dictionary for all Calculations
all_columns <- xml_find_all(datasources_twb, xpath=".//column[@caption]")  #search for cases where there is no caption - that's the columns that aren't calculations
all_cols_xml <- lapply(xml_attrs(all_columns), as.list)
all_fields_df <- rbindlist(all_cols_xml, fill=TRUE)

all_calculations <- xml_find_all(datasources_twb, xpath=".//column/calculation")
all_calcs_xml <- lapply(xml_attrs(all_calculations), as.list)
all_calcs_df <-  rbindlist(all_calcs_xml,fill = TRUE)

data_dictionary_tbl <- bind_cols(all_fields_df, all_calcs_df)

# clean data
calculation <- data_dictionary_tbl %>% 
    select(-name) %>% 
    rename("name" = "caption")

data_dictionary_tbl


#Questions:  why do you get the fields with no calculations 3 times? and the calculations 3 times?  and why are calculations kept in a separate list?
