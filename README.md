# RED
R Exploratory Data analysis package.

The package provides functions for comprehensive exploratory analysis.

The package automatically separates categorical and continuous variables of your data set and then performs univariate and bivariate  analysis for both the types of variables. The package also contains functions to transform data to generate a model ready data set.

# Description of the functions available
  ```univariate_charvar``` : The function performs univariate analysis on all the categorical variables of the data. It automatically identifies all the categorical variables and  performs univariate analysis
  
  ```univariate_numvar``` : The function produces comprehensive descriptive statistics for all the numerical variables in the dataset
  
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
row_missing_count(df)
```
## mv_treatment_charvar()
```R
mv_treatment_numvar(df, col.del_cutoff = 0.5) 
```
This will automatcally drop all the numeric columns with more than 50% missing values and wiil impute missing values in rest of the numeric columns with mean

```R
mv_treatment_numvar(df, col.del_cutoff = 0.4, treatment_type = median)
```
This will drop all the numeric columns with more than 40% missing values and will impute missing values in rest of the numeric columns with **median**

```R
mv_treatment_numvar(df, col.del_cutoff = 0.5, treatment_type = median, var_list = c("numvar1", "numvar2")) 
```
This will drop variables with more than 40% missing values but perform imputation only on variables numvar1 and numvar2

## mv_treatment_charvar()

```R
mv_treatment_charvar(df, default = T, col.del_cutoff = 0.4)
```
This will drop all the variables with more than 40% missing value and will impute missing value in other character variables with "unknown". Default col.del_cutoff is 0.5

```R
 mv_treatment_charvar(df, default = T, col.del_cutoff = 0.4, char_var_list1 =  c("charvar1", "charvar2"), char_var_list2 =  c("charvar3", "charvar4")) 
``` 
Using this function, you can specify variables on which you want to perform missing value imputation. For the variables in char_var_list1, the function imputes missing values with "unknown" while for the variables in char_var_list2, the function imputes missing values with the **modal class**
 
## replace_charvars()

```R
data("cars2")
table(cars2$Country)
   France   Germany     Japan Japan/USA     Korea    Mexico    Sweden       USA 
        1         2        19         7         3         1         1        26 
 ```
 Now lets say at you want to group all the countries with less than 5% of the observations as other. You can use ```replace_charvar```
 
 ```R
 class(cars2$Country)
 [1] "factor"
 
cars2$Country<- as.character(cars2$Country) # the function does not work on factor class. I will fix it in next release
 
new_df<- replace_charvars(cars2, c("Country"), cutoff = 0.05) # "Classes with frequency less than the **cutoff** will be modified
table(new_df$Country)

    Japan Japan/USA     Korea     Other       USA 
       19         7         3         5        26 
```

If you want to replace the minority class with modal class, use the ```option = "rep_max"```

```R
new_df<- replace_charvars(df, c("charvar1", "charvar2)", cutoff = 0.05, option = "rep_max")
```
This function will will replace minority class in charvar1 and charvar2 with respective modal class

## char_bivariate<- function(df, dep_var)

```R
output1 <- char_bivariate(cars2, c("Reliability")) # Reliability is numeric variable
output2<- char_bivariate(cars2, c("Country")) # Country is categorical variable
```
**Output**

```R
> output1$`3_Type`
  Independent_Var Dependent_Var
1         Compact      3.615385
2           Large      2.333333
3          Medium      3.090909
4           Small      4.000000
5          Sporty      2.714286
6             Van      3.666667

> output2$`2_Type`
           Type
Country     Compact Large Medium Small Sporty Van
  France          1     0      0     0      0   0
  Germany         1     0      0     1      0   0
  Japan           3     0      4     4      4   4
  Japan/USA       4     0      0     3      0   0
  Korea           0     0      1     2      0   0
  Mexico          0     0      0     1      0   0
  Sweden          1     0      0     0      0   0
  USA             5     3      8     2      5   3

```

**Hope you find the package helpful. Please feel free to report the issues.**
