# Folder/entry name
Entry_name <- "EXP_TMP_20200827"
# Making entry folder
dir.create(paste("input_files", Entry_name, sep = "/"))
# Defining list of files 
template_files <- c("./templates/BCA_SAMPLES.csv", "./templates/BCA_STD.csv", "./templates/template.R")
dest_folder <- paste("input_files", Entry_name, sep = "/")
# Copying templates
file.copy(template_files, dest_folder)