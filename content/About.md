#### About RUSP RF

This web application focuses on integrating all metabolomics analytes with data mining method to remove as many false positives in first-tier tests as possible. 
Random Forest was proved promising in other multivrariate analysis settings and is applied here to yield second-tier DBS test results with higher specificity without reducing sensitivity.

#### Model

TBA

#### Instructions

TBA

#### Input Data

The input data file could be in a comma separated values (csv) format, or in a plain text format with its delimiters being one of the following: semicolon, tab, or space. The first row of the file contains the header information for each column. Each row after the header contains the corresponding information for each sample.
The description and format of each column is described below: 

| Column         | 1    | 2-40   |
|:-------------------|:-------------------------|:------------------------------------|
| Headers | id | Original marker name or its abbreviation |
| Example Headers | id | Citrulline, CIT, C18:1, c181 |
| Values | Unique sample id (string) | Individual marker concentration levels (numeric) |
| Example Values | S01, sample_001 | 0.2, 0.11421383 |

<br>
As long as all the 39 marker levels are included in the file, the metabolic markers can be in any order based on your preference.

#### Code

Built with [R](http://www.r-project.org) and the [Shiny framework](http://shiny.rstudio.com).
<br>
Source Code
<hr>
