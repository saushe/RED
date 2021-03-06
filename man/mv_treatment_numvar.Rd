% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hello.R
\name{mv_treatment_numvar}
\alias{mv_treatment_numvar}
\title{Performs missing value imputation for numeric variables}
\usage{
mv_treatment_numvar(df, col.del_cutoff = 0.5, var_list = num_var,
  treatment_type = mean)
}
\arguments{
\item{df}{The data frame on which the missing value treatment needs to be performed}

\item{col.del_cutoff}{Variables with missing value percentage greater than col.del_cutoff will be dropped. Default value is 50 percent}

\item{var_list}{Specify the list of variable for which the missing value imputation is to be performed}

\item{treatment_type}{Specify imputation type - mean or median}
}
\value{
Output is the data set with missing values imputed
}
\description{
Imputes missing values with mean or median. Also deletes the columns with missing values more than the specified cutoff
}
\section{Warning}{
 Enter only numerical variables in var_list
}

