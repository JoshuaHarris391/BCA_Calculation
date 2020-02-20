#' ---
#' title: "EXP_84_20200220 BCA"
#' author: "Joshua Harris"
#' date: "2020_02_20"
#' ---

#' # Defining Variables
############## VARIABLES ################
# Experiment Name
name_exp <- "EXP_84"
# Input data
input_folder_ref <- "EXP_84_20200220"
input_data_ref <- "EXP_84_Input_DF_20200220.csv"
# Working Dir
wd <- getwd() 
setwd(wd)
# setwd("..")

#########################################

# Loading Packages
library(tidyverse)
library(markdown)
library(knitr)

# Loading input 
input_df <- read.csv(paste("/Users/joshua_harris/Dropbox/Research/Tools/Cunliffe_BCA_Calc/input_files",input_folder_ref, input_data_ref, sep = "/"), header = T)

# Subsetting Standard curve DF
unique_concs <- unique(input_df$STD_CONC)
n_unique_concs <- length(unique_concs)
# Slicing DF
STD_DF_1 <- slice(input_df[, 1:2], 1:n_unique_concs)
colnames(STD_DF_1) <- c("STD_CONC", "STD_SIG_1")

STD_DF_2 <- slice(input_df[, 1:2], (n_unique_concs+1):(n_unique_concs*2))
colnames(STD_DF_2) <- c("STD_CONC", "STD_SIG_2")

STD_DF_3 <- slice(input_df[, 1:2], (n_unique_concs*2+1):(n_unique_concs*3))
colnames(STD_DF_3) <- c("STD_CONC", "STD_SIG_3")

# Creating STD DF
STD_DF <- left_join(STD_DF_1, STD_DF_2, by="STD_CONC") %>% left_join(., STD_DF_3, by = "STD_CONC")
# Calculating mean
STD_DF$MEAN <- apply(STD_DF[, 2:4], 1, mean)

# Fitting linear model 
form_1 <- as.formula(MEAN~STD_CONC, env = STD_DF)
model_1 <- lm(form_1, STD_DF)
slope_1 <- model_1$coefficients[2]
intercept_1 <- model_1$coefficients[1]
# Printing R-square value
lm_R2 <- summary(model_1)$adj.r.squared
R2_val <- paste("R-squared",  "=", signif(lm_R2, 4), sep = " ") %>% print()

# Making a Standard curve graph
STD_plot <- ggplot(data =  STD_DF, aes(STD_CONC, MEAN)) +
  geom_point() +
  geom_abline(slope = model_1$coefficients[2], intercept = model_1$coefficients[1]) +
  ggtitle(paste("Standard Curve", " (", R2_val, ")", sep = "")) +
  ylab("Signal Mean") +
  xlab("BCA Standard Concentration (ng/uL)")


#' # Standard Curve
plot(STD_plot)


#' # Calculating Sample Concentrations
# Subsetting Samples to DF
samples_DF <- input_df[, 3:ncol(input_df)] %>% na.omit()
# Calculating concentrations of samples
samples_list <- list()
samples_output_df <- data.frame()
for (i in colnames(samples_DF)) {
  # calculating mean of sample
  sample_mean <- mean(samples_DF[, i])
  # Calculating concentration
  Sample <- paste(i)
  Concentration <- (sample_mean - intercept_1)/slope_1 %>% signif(., 3)
  Concentration <- signif(Concentration, 5)
  Unit <- paste("ng/uL")
  tmp_df <- data.frame(Sample, Concentration, Unit, row.names = NULL)
  samples_output_df <- rbind(samples_output_df, tmp_df)
}

#' # Sample Concentrations
knitr::kable(samples_output_df)


# Saving Plot and DF
####################################################
# Saving jpeg
####################################################
# Variables
File.Path <- paste("./output_files", input_folder_ref, sep = "/")
dir.create(File.Path, recursive = T)
File.Name <- paste(name_exp, "std_curve", sep = "_")
Plot.object <- STD_plot
Fig.Width <- 10
Fig.Height <- 10

# Single Save
F_Name <- paste(File.Path, "/", File.Name,".jpeg", sep = "")
jpeg(F_Name, width = Fig.Width, height = Fig.Height, units = "cm", res = 300)
plot(Plot.object)
dev.off()

# Saving DF
write.csv(samples_output_df, file = paste(File.Path, "/", name_exp, "_BCA_Sample_Conc.csv", sep = ""), row.names = F)
