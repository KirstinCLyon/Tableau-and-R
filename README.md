# Tableau-and-R - Creating a Data Dictionary
Different Tableau and R automation projects


Data Dictionary.R creates a data dictionary using all fields from Tableau.  This is useful for checking calculations, data type, naming and formatting for each field in Tableau. The code inputs a Tableau.twb (which is converted to an XML file), and outputs a CSV with one row per field. 

The section to create folders isn't strictly needed (to do it you need to download the glamr package from:
https://usaid-oha-si.github.io/glamr/
Without the package, folders for Scripts, Data and Dataout shoult be created.  The Data folder holds the xml file, the Scripts holds the script files and Dataout contains the final csv file.  Update the folder names if you want to have the data and scripts together.

This is inspired by the following work which provides a similar output but uses Python:
https://thedotviz.com/index.php/2019/05/27/tableau-calculation-extractor/
https://github.com/practo/tableau-parser

