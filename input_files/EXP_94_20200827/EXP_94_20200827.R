#' ---
#' title: "EXP_94_20200818 BCA"
#' author: "Joshua Harris"
#' date: "27/08/2020"
#' ---

#' # Defining Variables
############## Variables ##############

# Input data
input_folder_ref <- "EXP_94_20200827"
input_data_std <- "BCA_STD.csv"
input_data_sample <- "BCA_SAMPLES.csv"


#########################################

# Loading Packages
library(tidyverse)
library(markdown)
library(knitr)

# Variable to access relative directories
wd <- ".."

# Loading input
input_df_std <- read.csv(paste(input_data_std, sep = "/"), header = T)
input_df_sample <- read.csv(paste(input_data_sample, sep = "/"), header = T)

# Calculating mean
input_df_std$MEAN <- apply(input_df_std[, 2:4], 1, mean)
input_df_sample$MEAN <- apply(input_df_sample[, 2:4], 1, mean)

# Fitting linear model
form_1 <- as.formula(MEAN~STD_CONC, env = input_df_std)
model_1 <- lm(form_1, input_df_std)
slope_1 <- model_1$coefficients[2]
intercept_1 <- model_1$coefficients[1]
# Printing R-square value
lm_R2 <- summary(model_1)$adj.r.squared
R2_val <- paste("R-squared",  "=", signif(lm_R2, 4), sep = " ") %>% print()

# Making a Standard curve graph
STD_plot <- ggplot(data =  input_df_std, aes(STD_CONC, MEAN)) +
  geom_point() +
  geom_abline(slope = model_1$coefficients[2], intercept = model_1$coefficients[1]) +
  ggtitle(paste("Standard Curve", " (", R2_val, ")", sep = "")) +
  ylab("Signal Mean") +
  xlab("BCA Standard Concentration (ng/uL)")


#' # Standard Curve
plot(STD_plot)


#' # Calculating Sample Concentrations
# Calculating concentrations of samples
samples_output_df <- data.frame()

for (i in input_df_sample$SAMPLE) {
  # Subsetting sample mean
  sample_mean <- input_df_sample %>% dplyr::filter(., SAMPLE == i) %>% dplyr::select(., MEAN)
  sample_mean <- sample_mean$MEAN %>% as.numeric()
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

File.Path <- paste("./outputs")
dir.create(File.Path, recursive = T)
File.Name <- paste(input_folder_ref, "std_curve", sep = "_")
Plot.object <- STD_plot
Fig.Width <- 10
Fig.Height <- 10

# Single Save
F_Name <- paste(File.Path, "/", File.Name,".jpeg", sep = "")
jpeg(F_Name, width = Fig.Width, height = Fig.Height, units = "cm", res = 300)
plot(Plot.object)
dev.off()

# Saving DF
write.csv(samples_output_df, file = paste(File.Path, "/", input_folder_ref, "_BCA_Sample_Conc.csv", sep = ""), row.names = F)
