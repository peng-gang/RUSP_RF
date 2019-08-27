#### About RUSP RF

This web application focuses on integrating all metabolomics analytes with random forest method to remove as many false positives in first-tier tests as possible. 
Random Forest was proved promising in other multivrariate analysis settings and is applied here to yield second-tier NBS test results with higher specificity without reducing sensitivity.


#### Training Data

Data from 2,777 screen-positive infants born between 2005 and 15 were selected at random by the [California NBS program](https://www.cdph.ca.gov/Programs/CFH/DGDS/Pages/cbp/default.aspx) that included metabolic analytes measured by MS/MS as well as birth weight, gestational age, sex, race/ethnicity, and age at blood collection. The above data includes 235 true-positives and 2,542 false-positives, where an infants could be screen-positive for multiple diseases. The California Department of Public Health is not responsible for the results or conclusions drawn by the authors of this publication.


#### Code and User Guide

Built with [R](http://www.r-project.org) and the [Shiny framework](http://shiny.rstudio.com).

[Source Code](https://github.com/peng-gang/RUSP_RF)

[User Guide](https://peng-gang.github.io/RUSP_RF_UserGuide/)


