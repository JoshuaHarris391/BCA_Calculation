# Automated BCA Calculation
- Repository takes in a standard curve data frame (BCA_STD.csv) and a sample data frame (BCA_SAMPLES.csv)from the input_files folder, then outputs the calculated BCA concentrations

- It should be noted that this calculation is based on the Cunliffe Lab [protocol](https://github.com/JoshuaHarris391/Lab_Protocols/blob/master/Protein/BCA_Assay.md).
	- This protocol dilutes the test samples by 1:10 so that the signal will be in the range of the standard curve. However, in the past, all Cunliffe lab BCA calculations have NOT multiplied the protein concentration result by a factor of 10, which is needed to account for the 1:10 dilution prior to the assay.
	- Despite knowing this, the Cunliffe lab have decided to keep doing the same protocol, as it has proven successful for subsequent experiments.

## Conducting the analysis:
1. Open create_entry.R, define the folder you want to create, then run the script.
```R
# Folder/entry name
Entry_name <- "EXP_TMP_20200827"
```

2. Enter standard curve and sample data into the template data frames (BCA_STD.csv, BCA_SAMPLES.csv)

3. Run compile_to_html.R to compile R analysis scripts to html and produce output files
```bash
Rscript -e "source('compile_to_html.R')"                                           
```

## Input data format
- The input data frame must have the standard concentrations or sample name in the first column, then signal technical repeats in columns 2 to 4.

### Input format for standard curve (BCA_STD.csv)
![](cache/input_df_STD.png?raw=true)

### Input format for Samples (BCA_SAMPLES.csv)
![](cache/input_df_SAMPLES.png?raw=true)
