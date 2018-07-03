#loading the required libraries
install.packages('stringr')
library(stringr)

#setting up the working directory
setwd('D:\\LogiSmart\\LogiSmart')

#getting the list of files
files <- list.files(pattern = "..\\.R$")

#initializing the empty list for libraries
libraries_list <- list()
#looping over the files
for (file in files){
  print(file)
  # Read in the data
  l_temp_lib_list <- scan(file, what="", sep="\n")

  #extracting the libaries from the readed R file
  l_temp_lib_list <- l_temp_lib_list[grepl('library',l_temp_lib_list,ignore.case = T)]
  
  #removing the extra library command from the R library loading command
  l_temp_lib_list <- sapply(l_temp_lib_list,function(p_library){gsub("[\\(\\)]", "", regmatches(p_library, gregexpr("\\(.*?\\)", p_library))[[1]])})
  
  #setting the names of the library list to NULL, as this is not required anyfurthermore
  names(l_temp_lib_list) <- NULL
  
  #aggregating the files dependencies into the main libraries list to install. 
  libraries_list <- append(libraries_list, l_temp_lib_list)
}
#getting the unique of the libraries for installation
libraries_list <- unique(libraries_list)


#converting list to vectors
libraries_list<- unlist(libraries_list) 

#cleaning the extracted libraries list
libraries_list <- str_extract(libraries_list, "[0-9a-zA-Z]+")

#installing the packages if not installaed
list.of.packages <- libraries_list
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

#some fancy print on the console of the missing dependencies
print('######################################')
print(paste('Installing following packages'))
lapply(new.packages,print)
print('######################################')

#isntallation of not installed packages
if(length(new.packages)) install.packages(new.packages)

#Printing the final confirmation
print('done')
