# RED
R Exploratory Data analysis package

The package provides functions for comprehensive exploratory analysis

The package automatically separates categorical and continous variables of your data set and then performs univariate and bivariate  analysis for both the types of variables. The package also contains functions to transform data to generate a model ready data set is also available.

# Description of the functions available
  ```univariate_charvar``` : The function performs univariate analysis on all the categorical variables of the data. It automatically identifies all the categorical variables and  performs univariate analysis
  
  ```univariate_numvar``` : The punction produces comprehensive descriptive statistics for all the numerical variables in the dataset
  
  ```col_missing_count``` : Produces a summary of missing values for all the variables in a data set
  
  ```row_missing_count``` : Produces a row wise summary of missing values
  
  ```mv_treatment_charvar``` : Performs missing value treatment for character variables by imputation. Imputes missing values with 'unknown' or mode. The function also deletes the columns with missing values more than the specified cutoff
  
  ```mv_treatment_numvar``` : Performs missing value imputation for numeric variables. Imputes missing values with mean or median. Also deletes the columns with missing values more than the specified cutoff
 
 ``` replace_charvars``` : Performs variable transformations on character variables. Groups minority classes as 'others' or replaces them with the modal class 
 
 ```char_bivariate``` : Performs bivariate analysis on the character variables. For numeric dependent variable, the function outputs mean of the dependent variable for all the classes and for categorical dependent variable the function returns crosstabs

# Installation Guide
 
 ```install_github()``` function of the ```devtools``` package can be used to install the package from github repository. First install the package ```devtools``` and the run following commands
 
 ``` R
library(devtools)
install_github("saushe/RED")
```

# Examples

Use ```help(RED)``` in ```R``` to get detailed information about the function in the package

## univariate_charvar()
```R
library(RED)
data('iris')
charvar_summary<- univariate_charvar(iris)
charvar_summary
charvar_summary$`1_Species`
```
**Output**

```
> charvar_summary$`1_Species`
$`#Levels`
[1] 3

$`Missing Count`
[1] 0

$Variable_Distribution
    setosa versicolor  virginica 
         1          0          0 

$`Variable_Distribution Percentage`
    setosa versicolor  virginica 
      0.01       0.00       0.00 

$`Percentage of observations in the levels with less than 5% of the observation`
[1] 0.67
```

## univariate_numvar()

```R
univariate_numvar(iris)
```

**Output**
```
           Var Count Missing Mean Median Std Dev Coeff of Variation Min Max Kurtosis Skewness 25% 75% Potential Upper Outliers Count Potential Lower Outlier Count
1 Sepal.Length             0  5.8    5.8     0.8               14.2 4.3 7.9     -0.6      0.3 5.1 6.4                              0                             0
2  Sepal.Width             0  3.1    3.0     0.4               14.3 2.0 4.4      0.1      0.3 2.8 3.3                              0                             0
3 Petal.Length             0  3.8    4.3     1.8               47.0 1.0 6.9     -1.4     -0.3 1.6 5.1                              0                             0
4  Petal.Width             0  1.2    1.3     0.8               63.6 0.1 2.5     -1.4     -0.1 0.3 1.8                              0                             0
```

## col_missing_count()

```R
col_missing_count(iris)
```
**Output**

```
[1] "0 variables have more than 50% missing values"
                      var var_type count_missing percent_missing
Sepal.Length Sepal.Length  numeric             0               0
Sepal.Width   Sepal.Width  numeric             0               0
Petal.Length Petal.Length  numeric             0               0
Petal.Width   Petal.Width  numeric             0               0
Species           Species   factor             0               0

```

## row_missing_count ()

```R
row_missing_count(iris)
```

**Output**
  
  ```
  missing_count Freq percent_missing
        1             0  150               
  ```
## mv_treatment_charvar()

```R










