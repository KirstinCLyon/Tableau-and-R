
# Instructions for preparing Tableau File ----
# Unpack to get the twb
# rename the twb to an xml


# Libraries ----

library(tidyverse)
library(glamr) #for setting up the USAID way
library(xml2)
library(XML)
library(data.table)




# Folder structure (not strictly needed)----
folder_setup(
    folder_list = list("Data", "Images", "Scripts", "AI", "Dataout", "GIS", "Documents",
                       "Graphics", "markdown", "Tableau")
)


#ReadME - creating the initial XML dataset ----

# 1. Unpack tableau file (should be a .twb not a .twbx)
# 2. Rename tableau file to chance file type from .twb to .xml

# Read data ----
twb_file <- read_xml("Data/Test.xml")


# There are two "datasources" - the top relates to parameters, and the bottom relates to fields 
# https://www.w3schools.com/XML/xml_xpath.asp

#Scenario 1:  Raw data ----

all_cols_raw <- xml_find_all(twb_file, xpath = ".//column")
all_cols_raw_xml <- lapply(xml_attrs(all_cols_raw), as.list)
all_cols_raw_df <- rbindlist(all_cols_raw_xml,fill = TRUE)


all_raw_tbl <- all_cols_raw_df %>% 
    filter(!is.na(type),is.na(caption)) %>% 
    mutate(formula = "", name = str_remove_all(name, "[\\[\\]]")) %>% 
    select(-ordinal, -caption) 



all_raw_tbl

# Sceanrio 2:  calculations ----

all_cols_calcs <- xml_find_all(twb_file, xpath=".//column[@caption]")  
all_cols_calcs_xml <- lapply(xml_attrs(all_cols_calcs), as.list)
all_cols_calcs_df <- rbindlist(all_cols_calcs_xml, fill=TRUE)

all_cols_calcs_details <- xml_find_all(twb_file, xpath=".//column/calculation")
all_cols_calcs_details_xml <- lapply(xml_attrs(all_cols_calcs_details), as.list)
all_cols_calcs_details_df <-  rbindlist(all_cols_calcs_details_xml,fill = TRUE)

all_calcs_tbl <- bind_cols(all_cols_calcs_df, all_cols_calcs_details_df) %>% 
    distinct() %>% 
    select(-name, -class) %>% 
    rename("name" = "caption")

all_calcs_tbl


# Combine raw and calculations and output data ----

data_dictionary_tbl <- all_raw_tbl %>% 
    union(all_calcs_tbl) %>% 
    mutate_all(na_if,"") %>%
    rename(default_format = `default-format`) %>% 
    select(name, datatype, role, type, default_format, formula) %>% 
    write_csv("Dataout/Data Dictionary.csv")


glimpse(data_dictionary_tbl)

