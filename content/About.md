#### About RUSP RF

This web application focuses on integrating all metabolomics analytes with data mining method to remove as many false positives in first-tier tests as possible. 
Random Forest was proved promising in other multivrariate analysis settings and is applied here to yield second-tier DBS test results with higher specificity without reducing sensitivity.

#### Model

TBA

#### Instructions
1. Click an item from "Disorder" drop-down menu to navigate to the disease type of your interest
2. Click an item from "State" drop-down menu to switch between database of each state
3. Click on the "Browse..." button to choose a input file from local (The application won't keep record of any of your data or the results. Your information won't be tracked when you visit this website.)
4. Choose the demilimter of your input file and click "RUSP_RF"
5. Once the calculation is done, the result figure and table will show on the right panel. You could specify a sample on the figure by clicking the corresponding row on the table. Click the row once again to cancel.   
6. Click on the "Download figure/table" button to download the results to your local devices.     

#### Result Boxplot Explanation
The left side and the right side of the boxplot represent the FP cases and TP cases in our model, respectively. The center column represents the samples from input file. The solid orange line is the optimal cutoff suggested by the RF cross validation for each disease. The user selected cutoff (represented by dotted organe line) can be changed by using the sliderbar on the left panel. The numbers under the x-axis represent the change of error rate for TP/FP group when different cutoffs are applied.  

#### Input Data

The input data file could be in a comma separated values (csv) format, or in a plain text format with its delimiters being one of the following: semicolon, tab, or space. The first row of the file contains the header information for each column. Each row after the header contains the corresponding information for each sample.
The description and format of each column is described below. As long as all the 39 marker levels are included in the file, the metabolic markers can be in any order based on your preference.

| Column         | 1    | 2-40   |
|:-------------------|:-------------------------|:------------------------------------|
| Headers | id | Original marker name or its abbreviation |
| Example Headers | id | Citrulline, CIT, C18:1, c181 |
| Values | Unique sample id (string) | Individual marker concentration levels (numeric) |
| Example Values | S01, sample_001 | 0.2, 0.11421383 |

#### Code

Built with [R](http://www.r-project.org) and the [Shiny framework](http://shiny.rstudio.com).


Source Code
