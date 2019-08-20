#### About RUSP RF

This web application focuses on integrating all metabolomics analytes with data mining method to remove as many false positives in first-tier tests as possible. 
Random Forest was proved promising in other multivrariate analysis settings and is applied here to yield second-tier DBS test results with higher specificity without reducing sensitivity.

#### Model

TBA

#### Suggested Cutoff

TBA

#### Instructions

1. Click an item from "Disorder" drop-down menu to navigate to the disease type of your interest.
2. Click an item from "State" drop-down menu to switch between database of each state.
3. Click on the "Browse..." button to choose a input file from local device. The application won't keep record of any of your data or the results. Your information won't be tracked when you visit this website.
4. Choose the delimiter of your input file and click "RUSP_RF".
5. Once the calculation is done, the result figure and table will show on the right panel. 
6. You could specify/underline a sample or multiple samples on the figure by clicking the corresponding row on the table. Click the row once again to cancel the specification. 
7. Type in a keyword in the search field to search for a certain information. 
8. Click on the "Download figure/table" button to download the results to your local devices to view them offline.
9. While navigating to another disease type, the application will clear all current data and switch to the corresponding model. A popup dialog with the text "If you choose to continue, the current input file and the results will be cleared. Please download the results beforehand if you prefer to keep a record." will appear. Please proceed according to the instructions. 
10. We welcome comments, suggestions and questions. Please feel free to send emails to us by clicking 'Report issues to the developers' from the bottom of the left panel. We will try our best to reply back to you in a timely manner.

#### General View of Result Boxplot

The left side and the right side of the boxplot represent the FP cases and TP cases in our model, respectively. The center column represents the samples from input file. The solid orange line is the optimal cutoff suggested by the RF cross validation for each disease. The user selected cutoff (represented by dotted organe line) can be changed by using the sliderbar on the left panel. The suggested status of each sample will be refreshed according to the changing cutoff. The numbers under the x-axis represent the change of error rate for TP and FP group when different cutoffs are applied. 

#### General View of Result Table


#### Input Data

The input data file could be in a comma separated values (csv) format, or in a plain text format with its delimiters being one of the following: semicolon, tab, or space. The first row of the file contains the header information for each column. Each row after the header contains the corresponding information of each sample.
The description and format of each column are described below. As long as all the 39 marker levels are included in the file, the metabolic markers can be in any order depending on your preference.

| Column         | 1    | 2-40   |
|:-------------------|:-------------------------|:------------------------------------|
| Headers | id | Original marker name or its abbreviation |
| Example Headers | ID, sample | Citrulline, cit, C18:1, c181, C5-OH, C5OH |
| Values | Unique sample id (string) | Individual marker concentration levels (numeric) |
| Example Values | S01, sample_001 | 0.2, 0.11421383 |


#### Data

Data from 2,777 screen-positive infants born between 2005 and 15 were selected at random by the [California NBS program](https://www.cdph.ca.gov/Programs/CFH/DGDS/Pages/cbp/default.aspx) that included metabolic analytes measured by MS/MS as well as birth weight, gestational age, sex, race/ethnicity, and age at blood collection. The above data includes 235 true-positives and 2,542 false-positives, where an infants could be screen-positive for multiple diseases. The California Department of Public Health is not responsible for the results or conclusions drawn by the authors of this publication.

#### Code

Built with [R](http://www.r-project.org) and the [Shiny framework](http://shiny.rstudio.com).


Source Code
