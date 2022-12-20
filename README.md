# The paper
This repository includes scripts and data for the following paper:

Audrain, Barnett, & McAndrews, 2023, Leveraging the resting brain to predict memory decline after temporal lobectomy

# Abstract
Objectives
Anterior temporal lobectomy as a treatment for temporal lobe epilepsy is associated with a variable degree of postoperative memory decline, and estimating this decline for individual patients is a critical step of preoperative planning. Presently, predicting memory morbidity relies on indices of preoperative temporal lobe structural and functional integrity. However, epilepsy is increasingly understood as a network disorder, and memory a network phenomenon. We aimed to assess the utility of functional network measures to predict postoperative memory changes.

Methods
Seventy-two adults with left and right temporal lobe epilepsy (TLE) underwent preoperative resting-state fMRI (rs-fMRI) and pre- and postoperative neuropsychological assessment. We compared functional connectivity throughout the memory network of each patient to a healthy control template based on 19 individuals to identify differences in global organization. A second metric indicated the degree of integration of the to-be-resected temporal lobe with the rest of the memory network. We included these measures in a model alongside standard clinical and demographic variables as predictors of memory change after surgery.

Results
Left TLE patients with more abnormal memory networks, and with greater functional integration of the to-be-resected region with the rest of the memory network preoperatively, experienced the greatest decline in verbal memory after surgery. Together, these two measures explained 44% of variability in verbal memory change, outperforming standard clinical and demographic variables. None of the variables examined in this study were associated with visuospatial memory change in patients with right TLE.

Conclusion
Resting-state connectivity provides valuable information concerning both the integrity of to-be-resected tissue as well as functional reserve across memory-relevant regions outside of the to-be-resected tissue. Intrinsic functional connectivity has the potential to be useful for clinical decision-making regarding memory outcomes in left TLE, and more work is needed to identify differences seen in right TLE.

# The software
Matrix Similarity and ATL Degree were calculated using in house scripts in Matlab version R2021a, and using the Matlab-based Brain Connectivity Toolbox version 2017_01_15
- Matlab can be downloaded from here: https://www.mathworks.com/downloads
- The Brain Connectivity Toolbox can be downloaded from here: https://sites.google.com/site/bctnet/

Statistical analyses and figures were coded and plotted in R version 3.6.3, and R Studio version 1.3.1093.
- R and Rstudio can be downloaded from here: https://www.rstudio.com/products/rstudio/download/ .
- R packages required:
  1. dplyr: https://cran.r-project.org/web/packages/dplyr/index.html
  2. car: https://cran.r-project.org/web/packages/car/index.html
  3. rstatix: https://cran.r-project.org/web/packages/rstatix/index.html
  4. ggplot2: https://cran.r-project.org/web/packages/ggplot2/index.html
  5. emmeans: https://cran.r-project.org/web/packages/emmeans/index.html
  6. Rmisc: https://cran.r-project.org/web/packages/Rmisc/index.html
  7. jtools: https://cran.r-project.org/web/packages/jtools/index.html

These software packages must be installed on your local machine in order to run these scripts. Installation can take several minutes per software package.

# The scripts and functions
MatrixSimilarity_Calculator.m
- Script used to calculate matrix similarity and ROI similarity
- Requires:
  1. memory_matrices.mat
  2. BNA_memory_ROI.mat
  3. subj_list.txt
  4. nancorcoef.m
- Input: network connectivity matrices (memory_matrices.mat)
- Output:
  1. MatrixSimilarity.txt which contains matrix similarity values for each participant (rows)
  2. ROIsimilarity.txt contains ROI similarity for each participant (rows) and each ROI (columns)

nancorcoef.m
- matlab function that allows correlation with NaN values. This is called upon by MatrixSimilarity_Calculator.m.
- Copyright (c) 2001, Denis Gilbert

ATLDegree_Calculator.m
- Script used to calculate ATL degree across thresholds 5-45.
- Requires:
  1. memory_matrices.mat
  2. subj_list.txt
  3. Brain Connectivity Toolbox functions
- Input: network connectivity matrices (memory_matrices.mat)
- Output:
  1. LATL_degree.txt, contains degree from to-be-resected ROIs in the left hemisphere to the rest of the memory network. Each row is a participant, each column a threshold (5, 10, 15, 120, 25, 30, 35, 40, 45)
  2. RATL_degree.txt, degree from to-be-resected ROIs in the right hemisphere to the rest of the memory network. Each row is a participant, each column a threshold (5, 10, 15, 120, 25, 30, 35, 40, 45)

MSMem_Demographics.Rmd
- R script containing statistical analyses of demographic data between groups
- Input: R_MSMem.csv

MSMem_Similarity.Rmd
- R script containing statistical analyses of matrix similarity and ROI similarity
- Input: R_MSMem.csv

MSMem_Degree.Rmd
- R script containing statistical analyses of mean ATL degree
- Input: R_MSMem.csv

MSMem_MultipleRegression.Rmd
- R script containing multiple linear regression model comparisons
- Input: R_MSMem.csv

##  A note on statistical analysis choices
An alpha of 0.05 was used for all analyses. In keeping with the assumptions of linear regression, normality of each linear regression model’s residuals was confirmed with Shapiro-Wilks tests of normality, as implemented in the base ‘stats’ package in R. Homogeneity of variance of the model residuals was assessed using the Breusch-Pagan test41 using the ncvTest function from the ‘car’ package in R. The base plot function in R was used to check Cook’s distance for outliers, and a plot of the model residuals versus fitted values was used to check for linearity between predictors and the dependent variable. To ensure no collinearity among predictors for multiple linear regression analyses, we examined the variance inflation factor (VIF) using the ‘car’ package. A VIF of less than 10 was considered to indicate no consequential collinearity42. For demographic variables, we checked the model assumptions for ANOVAs and t-tests in a similar manner. Where normality assumptions were violated, we used non-parametric Kruskal-Wallis and Wilcoxon rank sum tests. If heterogeneity of variance was violated, we used Welch ANOVA and Grames Howell tests for post-hoc pairwise comparisons.

# The data
memory_matrices.mat
- contains memory network connectivity matrices

BNA_memory_ROI.mat
- contains the Brainnetome Atlas labels corresponding to the memory network ROIs.
- The Brainnetome atlas used to construct the memory network can be found here: https://atlas.brainnetome.org/

subj_list.txt
- contains list of subject numbers included in this project

R_MSMem.csv
- SubjID: subject ID
- Group: participant group. LTLE = left temporal lobe epilepsy, RTLE = right temporal lobe epilepsy, CON = control
- pathology: pathology via radiology and/or pathology team
- Surgery: surgery type. LTLAmHipp = left standard ATL resection, RTLAmHipp = right standard ATL resection, LSAmHipp = left selective amygdalohippocampectomy, RSAmHipp = right selective amygdalohippocampectomy
- age1: age at preoperative neuropsychological assessment
- sex: F = female; M = male
- edu: years of education at preoperative assessment
- AOO: age of epilepsy onset, in years
- hem_dom: hemispheric dominance as assessed by language task fMRI. L = left; B = bilateral, R = right
- postop: 1 = underwent postoperative neuropsychological assessment; 0 = did not undergo postoperative assessment 	
- MTS_status: 1 = evidence of medial temporal sclerosis; 0 =  no evidence of medial temporal sclerosis
- Pre_Verb: preoperative composite verbal memory scores
- Pre_Vis: preoperative composite visuospatial scores 	
- VerbalFactor: composite measure of post-preoperative verbal memory change
- VisualFactor: composite measure of post-preoperative visuospatial memory change
- material_specific_mem_change: same as VerbalFactor and VisualFactor, but all in one column depending on the group. LTLE values reflect VerbalFactor, RTLE participants reflect VisualFactor scores
- MatrixSim_64: matrix similarity values across the memory network (64 ROIs; output of MatrixSimilarity_Calculator.m script)
- BNA_3...BNA_136	B: ROI similarity values for each of the 64 ROIs in the memory network. Each column is named after the Brainnetome Atlas ROI label corresponding to the ROI. (output of MatrixSimilarity_Calculator.m script)
- L_cost05...L_cost45: 	ATL degree for to-be-resected ROIs of the left hemisphere, at thresholds 5-45 (output of ATLDegree_Calculator.m script)
- R_cost05...R_cost45: ATL degree for to-be-resected ROIs of the right hemisphere, at thresholds 5-45 (output of ATLDegree_Calculator.m script)

This file accompanies all R scripts (.Rmd) for statistical analysis and figure generation.

# Running the scripts
To run these scripts you will need to download and save the scripts, data, and functions associated with them (as described under "The scripts and functions" section) to your local machine.

You will need to change the path in each script to point to wherever you saved the data and functions on your local machine (denoted by ###### CHANGE PATH FOR YOUR DATA ####### within each script).

Running these scripts will reproduce the matrix similarity, roi similarity, and ATL degree values used in the paper (the .m scripts), as well as all statistical analyses and figures (the .Rmd scripts). Each script should take no more than a few minutes to run.

Note that the output from the MatrixSimilarity_Calculator.m script and the ATLDegree_Calculator.m were saved in R_RSMem.csv file alongside other data. As such, you do not need to run these matlab scripts to run the R statistical analysis scripts.

# License
All code in this repository is licensed under the MIT license.

The data included in this repository is licensed under the Creative Commons Attribution 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

# Inquiries
Please contact samanthaaudrain at gmail dot com for questions, comments, or bugs.
