# Eprime-data-merging
Standardized script to read and combine individual e-prime text files

Created by Stefan Vermeent
P.C.S.Vermeent@uu.nl


INSTRUCTIONS:
This script can be used to read in all individual E-prime .txt files and automatically combine them into one
dataframe. Make sure the working directory of the script is set to the folder that contains all files. The
script consists of three parts:  

1. This is the only part in the script that has to be changed manually. Specify the E-prime levels and trial
  levels to retain, and (optionally) which variables to include in the final dataset.
2. This part consists of a function that translates the .txt files to a tidy dataframe, and a loop that
  applies this function to all the .txt files. In the final step, they all get combined into one dataframe.
3. An optional part if you want to filter out additional variables. These variables can be specified under
  step 1. Use the "write_csv" function to write the data to a .csv file (e.g., if you want to export it to
  SPSS).
