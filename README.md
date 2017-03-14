# Coursera Data Science Specialization - JHU
***
# Getting and Cleaning Data Course Project

This is the repository on the Getting and Cleaning Data Course Project, from the John Hopkins School of Science and Public Health Coursera Data Science Specialization.
This README document explains how the main script file (run_analysis.R) works.

## Premises
To run the script one should only clone this repository.

## Method
In order to perform assigned tasks, the script take the following steps:

- **Setting Working Directory and Loading Libraries**: In this step, a data folder is created and `plyr`, `data.table` and `dplyr` R packages are installed and loaded.
- **Downloading and Unzipping Data File**: In this step, data from UCI HAR Dataset is downloaded into local data directory and relevant data files are unzipped.
- **Reading Data Files**: In this step, local data files are importted to R work space. Training and Test data sets are binded with their respective subjects and activities.
- **Merging data sets**: In this step, Training and Test data sets are binded into a complete data set.
- Extracting Relevant Variables: In this step, the complete data set is updated to keep only relevant columns, that is, those that contain mean and standard deviation measures.
- **Adding descriptive activity names to the data set**: In this step, activity column, which was until now only a vector of integers, has its class updated to factor and its levels named accordingly.
- **Labeling data with appropriate descriptive variable names**: In this step, a series of replacements over variable names in the complete data set is undertaken in order for them to be more comprehensible.
- **Creating Tidy Data Set with mean of each variable, grouped by activity and subject**: In this step, a couple of pipelined operations are undertaken in order to calculate the mean of each variable for each activity and each subject. This tidy data set is then exportted.

To better understand the tidy data set exportted, please refer to the [Code Book](https://github.com/gabrieltoliveira/DtScSpec_GetCleanData_CourseProject/blob/master/Code_Book.md).
