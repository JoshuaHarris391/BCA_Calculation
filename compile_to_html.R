# Get file paths for R scripts in input_files folder
system("find ./input_files -name '*.R' > R_scripts_tmp.txt")
# Loading file names to object
library(tidyverse)
R_script_paths <- read.table("R_scripts_tmp.txt", header = F)
R_script_paths <-  as.character(R_script_paths$V1) %>% as.list()

# Rendering all R scripts
for (i in 1:length(R_script_paths)) {
  rmarkdown::render(R_script_paths[[i]], "html_document")
}

# Removing temp file
system("rm R_scripts_tmp.txt")
