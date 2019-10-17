# Automated BCA Calculation
- Repository takes in a DF from the input_files folder, then outputs the calculated BCA concentrations
- It should be noted that this calculation is based on the Cunliffe Lab [protocol](https://github.com/JoshuaHarris391/Lab_Protocols/blob/master/Protein/BCA_Assay.md).
	- This protocol dilutes the test samples by 1:10 so that the signal will be in the range of the standard curve. However, in the past, all Cunliffe lab BCA calculations have NOT multiplied the protein concentration result by a factor of 10, which is needed to account for the 1:10 dilution prior to the assay.
	- Despite knowing this, the Cunliffe lab have decided to keep doing the same protocol, as it has proven successful for subsequent experiments.

## Input data format
- The input data frame must have the standard concentrations in the first column, then standard signal in the second column.
- Samples go in the 3rd column and onwards. Where technical repeats go in each row.

![](cache/input_df_fig.png?raw=true)
