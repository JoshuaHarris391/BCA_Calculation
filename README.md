# Automated BCA Calculation
- Repository takes in a standard curve data frame (BCA_STD.csv) and a sample data frame (BCA_SAMPLES.csv)from the input_files folder, then outputs the calculated BCA concentrations

- It should be noted that this calculation is based on the Cunliffe Lab [protocol](https://github.com/JoshuaHarris391/Lab_Protocols/blob/master/Protein/BCA_Assay.md).
	- This protocol dilutes the test samples by 1:10 so that the signal will be in the range of the standard curve. However, in the past, all Cunliffe lab BCA calculations have NOT multiplied the protein concentration result by a factor of 10, which is needed to account for the 1:10 dilution prior to the assay.
	- Despite knowing this, the Cunliffe lab have decided to keep doing the same protocol, as it has proven successful for subsequent experiments.

## Conducting the analysis:
1. Create a folder in input_files for the experiment you want to analyse e.g.
```bash
mkdir -p input_files/EXP_94_20200815
```
1. Copy the input data frame templates to the input data folder you just created
```bash
cp templates/BCA* input_files/EXP_94_20200815/
```

1. Copy the template script from the templates folder to the scripts_html folder. The scripts_html folder is where the compiled html report will be created
```bash
cp templates/template.R scripts_html/
```
1. Rename template script name to the folder you created in step 1
```bash
mv scripts_html/template.R scripts_html/EXP_94_20200815.R
```
1. Open script and edit the title, author, and date.
```R
#' ---
#' title: "EXP_94_20200818 BCA"
#' author: "Joshua Harris"
#' date: "18/08/2020"
#' ---
```

1. Redefine the experiment name, and input data folder
```R
# Experiment Name
name_exp <- "EXP_94"
# Input data
input_folder_ref <- "EXP_94_20200815"
```
1. Either open the R script in R studio and compile, or run the bash code below:
```bash
# Open R
R
# Run command in R terminal
rmarkdown::render("scripts_html/EXP_94_20200815.R", "html_document")
# Exit R terminal
q()
```

## Input data format
- The input data frame must have the standard concentrations or sample name in the first column, then signal technical repeats in columns 2 to 4.

### Input format for standard curve (BCA_STD.csv)
![](cache/input_df_STD.png?raw=true)

### Input format for Samples (BCA_SAMPLES.csv)
![](cache/input_df_SAMPLES.png?raw=true)
