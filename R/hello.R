#' Perform univariate analysis on all the categorical variables of the data
#'
#'
#' @param df The data frame on which univariate is to be performed
#' @return The output is a list which includes count of missing values, number of levels and frequency distribution for each character variable. The information contained can be used for missing value treatment and variable transformation
#' @description The function automatically identifies all the categorical variables in the data set and performs univariate analysis
#' @details Information about an individual variable can be pulled using output$variable_name
#' @section Warning: Make sure all the variables in the data set have been assigned to the proper class

# 1. Functions for Exploratory Analysis

# 1.1 Descriptive stats for char var -----------------------

univariate_charvar<- function(df)
{
  df<- as.data.frame(df)
  var_type<- data.frame(summarise_all(df,class))
  char_var<- colnames(df[which(var_type == "character" | var_type == "factor"  )])

  # throw a waning message if all the variables have not been covered. Check this by summing Char_var and Int_Var and check if it is equal to ncol(df)

  # separate int and char variables
  char_df<- df[,c(char_var)]

  # summary for character variables
  # throw out distribution of the variables
  char_summary<- list()
  char_summary$tot_vars<- length(char_var)
  for (i in 1:length(char_var))
  {

    char_summary[[paste0(i,"_" ,char_var[i])]]<- list()
    Level_Cnt<- length(table(char_df[i]))
    Var_Dist<- table(char_df[i])
    Var_Dist_Df<- data.frame(Var_Dist)
    char_summary[[paste0(i,"_" ,char_var[i])]][[paste0("#Levels")]]<- Level_Cnt
    char_summary[[paste0(i,"_" ,char_var[i])]][[paste0("Missing Count")]]<- length(which(is.na(char_df[i])==T))
    char_summary[[paste0(i,"_" ,char_var[i])]][[paste0("Variable_Distribution")]]<- Var_Dist
    char_summary[[paste0(i,"_" ,char_var[i])]][[paste0("Variable_Distribution Percentage")]]<- round(Var_Dist/nrow(df),2)
    char_summary[[paste0(i,"_" ,char_var[i])]][[paste0("Percentage of observations in the levels with less than 5% of the observation")]]<- round(sum(Var_Dist_Df$Freq[which(Var_Dist_Df$Freq<0.05*nrow(df))])/nrow(df)*100,2)

  }

  return(char_summary)

}

# Next step for this function
#1. If the dependent variable is continuous, perform anova and output F-value and intercepts
#2. If the dependent variable is categorical, produce a crosstab

#' Performs univariate analysis on all the numerical variables of the data
#'
#'
#' @param df The data frame on which univariate is to be performed
#' @param outlier_cutoff This is used to calculate the boundary beyond which an observation will be flagged as outlier. Default value is 3. User can change it to 1.5, 2, 2.5 etc. Formula to calculate outlier boundry: Upper outlier boundary =  (upper quartile)+(outlier_cutoff*IQR) , Lower outlier boundary =  (lower quartile)-(outlier_cutoff*IQR).
#' @return The output is a table which includes various descriptive stats for the variables
#' @description The function automatically identifies all the numeric variables in the data set and performs univariate analysis
#' @section Warning: Make sure all the variables in the data set have been assigned to the proper class


# 1.2 Descriptive Statistics for Numerical Variables --------------------------------

univariate_numvar<- function(df, outlier_cutoff = 3)
{
  df<- as.data.frame(df)
  var_type<- data.frame(summarise_all(df,class))
  int_var<- colnames(df[which(var_type == "integer" | var_type == "numeric") ])

  # throw a waning message if all the variables have not been covered. Check this by summing Char_var and Int_Var and check if it is equal to ncol(df)

  # separate int variables
  int_df<- df[,c(int_var)]

  # summary for character variables
  # throw out distribution of the variables
  temp_df0<- summarise_all(int_df, function(x){length(which(is.na(x)==T))})
  temp_df1<- summarise_all(int_df, function(x){x<- mean(x,na.rm = T)})
  temp_df2<- summarise_all(int_df, function(x){x<- median(x,na.rm = T)})
  temp_df3<- summarise_all(int_df, function(x){x<- sd(x,na.rm = T)})
  temp_df4<- round(temp_df3/temp_df1*100, 2)
  temp_df5<- summarise_all(int_df, function(x){x<- min(x,na.rm = T)})
  temp_df6<- summarise_all(int_df, function(x){x<- max(x,na.rm = T)})
  temp_df7<- summarise_all(int_df, function(x){x<- kurtosis(x,na.rm = T)})
  temp_df8<- summarise_all(int_df, function(x){x<- skewness(x,na.rm = T)})
  temp_df9<- summarise_all(int_df, function(x){x<- quantile(x,.25, na.rm = T)})
  temp_df10<- summarise_all(int_df, function(x){x<- quantile(x,.75, na.rm = T)})
  temp_df11<- summarise_all(int_df, function(x){length(which(x>(quantile(x, 0.75, na.rm= T)+(outlier_cutoff*IQR(x, na.rm= T)))))})
  temp_df12<- summarise_all(int_df, function(x){length(which(x<(quantile(x, 0.25, na.rm = T)-(outlier_cutoff*IQR(x, na.rm= T)))))})

  output<-rbind(temp_df0,temp_df1,temp_df2,temp_df3,temp_df4,temp_df5,temp_df6,temp_df7,temp_df8,temp_df9,temp_df10, temp_df11, temp_df12 )
  output<- data.frame(t(output))
  output$Var<- row.names(output)
  output<- mutate_if(output, is.numeric, function(x){round(x, 1)})
  colnames(output)<- c("Count Missing", "Mean", "Median", "Std Dev", "Coeff of Variation", "Min", "Max", "Kurtosis", "Skewness", "25%", "75%", "Potential Upper Outliers Count", "Potential Lower Outlier Count", "Var")
  output<- output[,c("Var", "Count Missing", "Mean", "Median", "Std Dev", "Coeff of Variation", "Min", "Max", "Kurtosis", "Skewness", "25%", "75%", "Potential Upper Outliers Count", "Potential Lower Outlier Count")]
  return(output)

}

#' Produces a summary of missing values for all the variables in a data set
#'
#'
#' @param df The data frame for which the missing value summary is to be produced
#' @return The output is a table which includes count of missing values for all the variables
#' @description The function enables user to qucikly perform missing value check

# 1.3 Summary of missing value in the columns -------------------------------------
col_missing_count<- function(df)
{
  df<- as.data.frame(df)
  missing_count<- data.frame(count_missing=t(summarise_all(df, function(x){x = length(which(is.na(x)==T))})))
  missing_count$var<- c(row.names(missing_count))
  missing_count$var_type<- t(summarise_all(df, class))
  missing_count<- missing_count[order(-missing_count$count_missing),]
  missing_count$percent_missing<- round(missing_count$count_missing/nrow(df)*100,1)
  missing_count <- missing_count[,c("var","var_type", "count_missing","percent_missing")]

  message<- length(missing_count$var[which(missing_count$percent_missing>50)])
  print(paste0(message," variables have more than 50% missing values"))

  return(missing_count)
}


#' Produces a row wise summary of missing values
#'
#'
#' @param df The data frame for which the missing value summary is to be produced
#' @return The output is a frequecny distribution table for number of missing values in each row
#' @description The function enables user to identify rows with multiple missing values

# 1.4 Row wise Summary of missing values
row_missing_count<- function(df)
{
  df<- as.data.frame(df)
  missing_count<- apply(df, 1,  function(x){x = length(which(is.na(x)==T))})
  missing_count<- data.frame(table(missing_count))
  missing_count$percent_missing<- round(as.numeric(levels(missing_count$missing_count))/ncol(df)*100,1)
  return(missing_count)

}


#' Performs missing value treatment for character variables by imputation
#'
#'
#' @param df The data frame on which the missing value treatment needs to be performed
#' @param default T/F. For default = T, the function first drops the variables with missing value percentage more than col.del_cutoff and then imputes all the missing values with unknown
#' @param col.del_cutoff Variables with missing value percentage greater than col.del_cutoff will be dropped. Default value is 50 percent
#' @param char_var_list1 If default = F, then user need to specify the list of variables on which the imputation needs to be performed. In char_var_list1 user can speciy the variables where NA needs to be imputed with unknown
#' @param char_var_list2 Specify the variables for which missing values needs to imputed with mode
#' @return Output is the data set with missing values imputed
#' @description Imputes missing values with unknown or mode. The function also deletes the columns with missing values more than the specified cutoff
#' @section Warning: Enter only categorical variables in char_var_list1 and char_var_list1

# Missing value treatment for variables-----------------------------

# 1.5 For character variables - Missing value Treatment
mv_treatment_charvar<- function(df, default = T, col.del_cutoff = 0.5, char_var_list1 = "EMPTY_99", char_var_list2 = "EMPTY_99")
{
  df<- as.data.frame(df)
  # Get list of all the character variables
  var_type<- data.frame(summarise_all(df,class))
  char_var<- colnames(df[which(var_type == "character" | var_type == "factor"  )])

  # Get count of missing values for all the character variables
  temp_df1<- data.frame(missing_count = apply(df[,c(char_var)],  2, function(x){x = length(which(is.na(x)==T))}))
  temp_df1$vars_name= row.names(temp_df1)

  # Based on the % of missing values, delete the rows with missig values beyond the cut off
  # Also update char var
  del_cols<- temp_df1$vars_name[which(temp_df1$missing_count/nrow(df)>col.del_cutoff)]
  if (length(del_cols>0))
  {
    keep_cols<- setdiff(colnames(df),del_cols)
    df<- df[,c(keep_cols)]
    char_var<- setdiff(char_var,del_cols)
    temp_df1<- temp_df1[-which(temp_df1$vars_name %in% del_cols),]
  }

  if (default == T)
  {
    # Replace missing values with "unknown"
    df<- mutate_at(df, c(char_var), function(x){ifelse(is.na(x)==T, "Unknown", x)})
  }

  if (default != T) # if default option is False
  {

    # replace with 'unknown' for variables mentioned in list char_varlist1
    if (char_var_list1 != "EMPTY_99")
    {
      if (length(del_cols>0))
      {
        char_var_list1<- setdiff(char_var_list1,del_cols)
      }
      df<- mutate_at(df, c(char_var_list1), function(x){ifelse(is.na(x)==T, "Unknown", x)})
    }
    # replace with mode for variables mentioned in list char_varlist2
    if (char_var_list2 != "EMPTY_99")
    {
      if (length(del_cols>0))
      {
        char_var_list2<- setdiff(char_var_list2,del_cols)
      }
      col_index<- which(colnames(df) %in% char_var_list2)
      for (i in 1:length(char_var_list2))
      {
        Var_Dist<- data.frame(table(df[col_index[i]]))
        # To be replaced with
        Max_Var<- as.character(Var_Dist$Var1[which(Var_Dist$Freq== max(Var_Dist$Freq))])
        # Replace
        df[which(is.na(df[,col_index[i]])==T),col_index[i]]<- Max_Var
      }

    }

  }
  return(df)
}

#' Performs missing value imputation for numeric variables
#'
#'
#' @param df The data frame on which the missing value treatment needs to be performed
#' @param col.del_cutoff Variables with missing value percentage greater than col.del_cutoff will be dropped. Default value is 50 percent
#' @param var_list Specify the list of variable for which the missing value imputation is to be performed
#' @param treatment_type Specify imputation type - mean or median
#' @return Output is the data set with missing values imputed
#' @description Imputes missing values with mean or median. Also deletes the columns with missing values more than the specified cutoff
#' @section Warning: Enter only numerical variables in var_list

# 1.6 Missing value treatment for numeric variales

mv_treatment_numvar<- function(df, col.del_cutoff = 0.5, var_list = num_var, treatment_type = mean)
{
  df<- as.data.frame(df)
  # Get list of all the character variables
  var_type<- data.frame(summarise_all(df,class))
  num_var<- colnames(df[which(var_type == "integer" | var_type == "numeric") ])

  # Get count of missing values for all the character variables
  temp_df1<- data.frame(missing_count = apply(df[,c(num_var)],  2, function(x){x = length(which(is.na(x)==T))}))
  temp_df1$vars_name= row.names(temp_df1)

  # Based on the % of missing values, delete the rows with missig values beyond the cut off
  # Also update char var
  del_cols<- temp_df1$vars_name[which(temp_df1$missing_count/nrow(df)>col.del_cutoff)]
  if (length(del_cols>0))
  {
    keep_cols<- setdiff(colnames(df),del_cols)
    df<- df[,c(keep_cols)]
    num_var<- setdiff(num_var,del_cols)
    temp_df1<- temp_df1[-which(temp_df1$vars_name %in% del_cols),]
  }

  if (length(var_list) == length(num_var))
  {
    col_index<- which(colnames(df) %in% var_list)
    for (i in 1:length(var_list))
    {
      # To be replaced with
      Replacement <- treatment_type(df[,col_index[i]], na.rm = T)

      # Replace
      df[which(is.na(df[,col_index[i]])==T),col_index[i]]<- Replacement
    }
  }

  if (length(var_list)< length( num_var))
  {
    col_index<- which(colnames(df) %in% var_list)
    for (i in 1:length(var_list))
    {
      # To be replaced with
      Replacement <- treatment_type(df[,col_index[i]], na.rm = T)

      # Replace
      df[which(is.na(df[,col_index[i]])==T),col_index[i]]<- Replacement
    }
  }
  return(df)
}

#' Performs variable transformations on character variables
#'
#'
#' @param df The data frame on which variable transformation is to be performed
#' @param col Variable names on which the transformation is to be performed
#' @param cutoff Classes with frequency less than the cutoff will be modified. Default is 5 percent
#' @param option Specify other to group classes with frequency less than the cutoff as other or specify rep_max to replace minority classes with modal class
#' @return Output is the data set with transformed variables
#' @description Groups minority classes as others or replaces them with the modal class


# Variable Transformation

# 1.7 The following function replaces/groups the levels for which we have very less observations

replace_charvars<- function(df, col, option = "other", cutoff = 0.05)
{
  df<- as.data.frame(df)
  col_index<- which(colnames(df) %in% col)
  Row_Cnt<- nrow(df)
  for (i in 1:length(col))
  {
    Var_Dist<- data.frame(table(df[col_index[i]]))
    if (option == "rep_max")
    {
      # Variables which need to be replaced
      Vars_TBR<- as.character(Var_Dist$Var1[which(Var_Dist$Freq/Row_Cnt<cutoff)])
      # To be replaced with
      Max_Var<- as.character(Var_Dist$Var1[which(Var_Dist$Freq== max(Var_Dist$Freq))])
      # Replace
      df[which(df[,col_index[i]]%in% Vars_TBR),col_index[i]]<- Max_Var
    }
    else
    {
      # Variables which need to be replaced
      Vars_TBR<- as.character(Var_Dist$Var1[which(Var_Dist$Freq/Row_Cnt<cutoff)])

      # Replace
      df[which(df[,col_index[i]]%in% Vars_TBR),col_index[i]]<- "Other"
    }
  }
  return(df)

}

#' Performs bivariate analysis on the character variables
#'
#'
#' @param df The data frame on which bivariate analysis is to be performed
#' @param dep_var Specify the dependent variable of the data frame
#' @return Output is a list with bivariate summary
#' @description For numeric dependent variable, the function outputs mean of the dependent variable for all the classes and for categorical dependent variable the function returns crosstabs

# 1.8 Bivariate for Categorical Vraiables

char_bivariate<- function(df, dep_var)
{
  df<- as.data.frame(df)
  var_type<- data.frame(summarise_all(df,class))
  char_var<- colnames(df[which(var_type == "character" | var_type == "factor"  )])

  # summary for character variables
  # throw out distribution of the variables
  if(class(df[,dep_var])=="character"|class(df[,dep_var])=="factor")
  {
    char_bivariate<- list()
    char_var<- setdiff(char_var, dep_var)
    char_df<- df[,c(char_var)]
    temp_dep_var<- df[dep_var]
    for (i in 1:length(char_var))
    {
      temp_ind_var<- char_df[i]
      temp_df<- cbind(temp_dep_var, temp_ind_var)
      char_bivariate[[paste0(i,"_" ,char_var[i])]]<- xtabs(~., temp_df)
    }
  }
  else
  {
    # separate int and char variables
    char_df<- df[,c(char_var)]
    temp_dep_var<- df[dep_var]
    char_bivariate<- list()
    for (i in 1:length(char_var))
    {
      temp_ind_var<- char_df[i]
      temp_df<- cbind(temp_dep_var, temp_ind_var)
      colnames(temp_df)<- c("Dependent_Var", "Independent_Var")
      char_bivariate[[paste0(i,"_" ,char_var[i])]]<- aggregate(Dependent_Var ~ Independent_Var, data=temp_df, FUN=mean, na.rm = T)

    }
  }

  return(char_bivariate)

}
