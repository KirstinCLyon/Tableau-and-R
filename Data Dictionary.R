
# Instructions for preparing Tableau File ----
# 1. Unpack tableau file (should be a .twb not a .twbx)
# 2. Rename tableau file to chance file type from .twb to .xml


# Libraries ----

library(tidyverse)
library(xml2)
library(XML)

# Read data ----
twb_file <- read_xml("Data/Test.xml")

#Functions ---------------------------------------------------------------------
convert_cols_xml_to_tbl <- function(data,twb_xpath){
    test     <- xml_find_all(data, xpath = twb_xpath)
    test_xml <- map(xml_attrs(test), as.list) %>% reduce(bind_rows)
    return(test_xml)
}

#Scenario 1:  Raw data ----
all_cols <- convert_cols_xml_to_tbl(twb_file, "..//column")

all_raw_tbl <- all_cols %>% 
    filter(!is.na(type),is.na(caption)) %>% 
    mutate(formula = NA, tableau_name = NA, name = str_remove_all(name, "[\\[\\]]")) %>% 
    select(-ordinal, -caption, -value) 

# Scenario 2:  calculations and parameters ----

all_calcs <- convert_cols_xml_to_tbl(twb_file, "//column[@caption]")
all_calcs_details <- convert_cols_xml_to_tbl(twb_file, ".//column/calculation")

all_calcs_tbl <- bind_cols(all_calcs, all_calcs_details) %>% 
    distinct() %>% 
    select(-class, -value) %>% 
    rename("name" = "caption", "tableau_name" = "name")


# Combine raw and calculations and output data ----

data_dictionary_tbl <- all_raw_tbl %>% 
    union(all_calcs_tbl) %>% 
    select(name, datatype, role, type, 'default-format', formula, alias, tableau_name, 'param-domain-type') %>% 
    write_csv("Dataout/Data Dictionary.csv")
