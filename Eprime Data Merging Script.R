#------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------
# STANDARDIZED SCRIPT TO READ AND COMBINE INDIVIDUAL E-PRIME TEXT FILES (.TXT)
#
# Created by Stefan Vermeent
# P.C.S.Vermeent@uu.nl

# INSTRUCTIONS:
#
# This script can be used to read in all individual E-prime .txt files and automatically combine them into one
# dataframe. Make sure the working directory of the script is set to the folder that contains all files. The 
# script consists of three parts:

# 1. This is the only part in the script that has to be changed manually. Specify the E-prime levels and trial
#    levels to retain, and (optionally) which variables to include in the final dataset.
# 2. This part consists of a function that translates the .txt files to a tidy dataframe, and a loop that 
#    applies this function to all the .txt files. In the final step, they all get combined into one dataframe.
# 3. An optional part if you want to filter out additional variables. These variables can be specified under
#    step 1. Use the "write_csv" function to write the data to a .csv file (e.g., if you want to export it to 
#    SPSS).
#    
#------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------

library(rprime)
library(tidyverse)

#------------------------------------------------------------------------------------------------------------
##1. EXPERIMENT-SPECIFIC PARAMETERS THAT NEED TO BE SPECIFIED##
#------------------------------------------------------------------------------------------------------------

# Specify which nested levels you want to keep in the final dataset.
# NOTE: If you are not sure, you can first run the script for one file. the preview_levels() function in 
# read_files prints an overview of the levels and the corresponding trial types.
levels_to_retain <- c(1,2,3)

# Specify which trials you want to keep (e.g., here you could drop the instructions or practice trials)
trials_to_retain <- c("TrialList", "Coincouterbalance", "Header", "Demo")


# Optional for step 3: standard E-prime vectors and experiment-specific vectors that you want to filter out or retain:

drop_variables <- c("Eprime.Level", "Eprime.LevelName", "Eprime.Basename", "Eprime.FrameNumber", "Procedure", "Running",
               "VersionPersist", "LevelName", "Experiment", "SessionDate", "SessionTime", "SessionStartDateTimeUtc",
               "Session", "DataFile.Basename", "RandomSeed", "Group", "Display.RefreshRate", "StimulusFile")  

keep_variables <- c()


#------------------------------------------------------------------------------------------------------------
## 2. PARSING AND JOINING DATA##
#------------------------------------------------------------------------------------------------------------

# 'file_names' contains all the individual textfiles that are located in the working directory. NOTE: ".txt" 
# doesn't have to be in the filename for this code to work
file_names <- list.files(pattern="*.txt")

# A function that goes through all the steps to transform the text file into a tidy dataframe.
read_files <- function(x, y) {
  parse_data <- read_eprime(x) %>%
    FrameList()
  
preview_levels(parse_data)
  
individual_data <- keep_levels(parse_data, levels_to_retain) %>%
  filter_in(., "Running", trials_to_retain) %>%
  to_data_frame() 
  
individual_tidy <- individual_data %>%
# Make sure every trial line contains the subject number...
  mutate(subject = ifelse(is.na(Subject), Subject[1], Subject)) %>%
# And drop the original 'Subject' vector...
  select(-Subject) %>%
# And move the subject vector to the front of the dataset
  .[,c(max(ncol(.)),1:(ncol(.)-1))]
}

# A loop that makes sure that the read_files function is applied to all the individual datafiles in the working directory
output <- vector("list", length(file_names)) 
for (i in seq_along(file_names)) {
  output[[i]] <- read_files(file_names[[i]], full_data)
}

# Combine the individual datasets created in the loop into one full dataset.
data <- bind_rows(output)

#------------------------------------------------------------------------------------------------------------
# 3. (OPTIONAL) FILTER RELEVANT VECTORS##
#------------------------------------------------------------------------------------------------------------

tidy_data <- data %>%
  select(-one_of(drop_variables)) %>%
  select(one_of(keep_variables))

# write_csv(tidy_data, "tidy_data.csv")





