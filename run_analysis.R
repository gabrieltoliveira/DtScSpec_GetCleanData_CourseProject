## Getting and Cleaning Data Course Project
## Programming Assignement

# Instruções
# 
# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
#
# Review criteria
# - The submitted data set is tidy.
# - The Github repo contains the required scripts.
# - GitHub contains a code book that modifies and updates the available
# codebooks with the data to indicate all the variables and summaries
# calculated, along with units, and any other relevant information.
# - The README that explains the analysis files is clear and understandable.
# - The work submitted for this project is the work of the student who submitted it.
# 
# Getting and Cleaning Data Course Project
# The purpose of this project is to demonstrate your ability to collect, work
# with, and clean a data set. The goal is to prepare tidy data that can be used
# for later analysis. You will be graded by your peers on a series of yes/no
# questions related to the project. You will be required to submit: 1) a tidy
# data set as described below, 2) a link to a Github repository with your script
# for performing the analysis, and 3) a code book that describes the variables,
# the data, and any transformations or work that you performed to clean up the
# data called CodeBook.md. You should also include a README.md in the repo with
# your scripts. This repo explains how all of the scripts work and how they are
# connected.
# 
# One of the most exciting areas in all of data science right now is wearable
# computing - see for example this article . Companies like Fitbit, Nike, and
# Jawbone Up are racing to develop the most advanced algorithms to attract new
# users. The data linked to from the course website represent data collected
# from the accelerometers from the Samsung Galaxy S smartphone. A full
# description is available at the site where the data was obtained:
#   
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# 
# Here are the data for the project:
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following.
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.


# Setting Working Dir and Loading Libraries
if (!file.exists("data")) {dir.create("data")}
install.packages(c("plyr", "dplyr", "data.table"))
library(plyr)
library(dplyr)
library(data.table)

# Downloading and Unzipping Data File
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dest <- "./data/datazip.zip"
dateDownloaded <- date()
if (!file.exists(dest)) {download.file(fileUrl, dest)}

unzip(dest, list = TRUE) # Listing file to determine which are going to be extracted
unzip(dest, exdir = "./data", 
      files = c("UCI HAR Dataset/README.txt", 
                "UCI HAR Dataset/activity_labels.txt", 
                "UCI HAR Dataset/features.txt", 
                "UCI HAR Dataset/test/X_test.txt", 
                "UCI HAR Dataset/test/y_test.txt", 
                "UCI HAR Dataset/test/subject_test.txt", 
                "UCI HAR Dataset/train/X_train.txt",
                "UCI HAR Dataset/train/y_train.txt",
                "UCI HAR Dataset/train/subject_train.txt"
                )) # Extracting only important files
list.files("./data")

# Reading Data Files
# Features (Variable) names
features <- fread("./data/UCI HAR Dataset/features.txt", sep = " ", col.names = c("ID", "feature"), header = FALSE)
head(features)

# Activities names
activities <- fread("./data/UCI HAR Dataset/activity_labels.txt", sep = " ", col.names = c("ID", "activity"), header = FALSE)
head(activities)

# Importing and Binding Training and Test data sets. Each row is composed by the subject, the activity and the respective data.
train_subject <- fread("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
train_activity <- fread("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE)
train_data <- fread("./data/UCI HAR Dataset/train/X_train.txt", col.names = features$feature, header = FALSE)
train <- cbind(train_subject, train_activity, train_data)

test_subject <- fread("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
test_activity <- fread("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
test_data <- fread("./data/UCI HAR Dataset/test/X_test.txt", col.names = features$feature, header = FALSE)
test <- cbind(test_subject, test_activity, test_data)

# 1. Merges the training and the test sets to create one data set.
# Binding Training and Test data
complete_dt <- rbind(train, test)
colnames(complete_dt)[1:2] <- c("subject", "activity") # Attributing names to subject and activity columns.

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# Finding mean and std values
colnames(complete_dt) <- make.names(colnames(complete_dt), unique=TRUE, allow_ = TRUE) # Removing problematic characters, such as parentheses, from colnames
complete_dt <- select(complete_dt, c(1, 2, grep(pattern = "mean\\.\\.|std\\.\\.", colnames(complete_dt)))) # Only selects mean() and std() variables. However, due to make.names, search is for double dots.

# 3. Uses descriptive activity names to name the activities in the data set
complete_dt$activity <- factor(complete_dt$activity, levels = activities$ID, labels = activities$activity) # Assigning activity name to each row
complete_dt$subject <-  as.factor(complete_dt$subject) # Factorizing subject column
str(complete_dt)

# 4. Appropriately labels the data set with descriptive variable names.
colnames(complete_dt) <- gsub(pattern = "\\.\\.", replacement = "", x = colnames(complete_dt)) # Replaces double dots created by the above make.names function
colnames(complete_dt) <- gsub("^t", "time", colnames(complete_dt)) # Replaces variable names beginning with t with "time"
colnames(complete_dt) <- gsub("^f", "frequency", colnames(complete_dt)) # Replaces variable names beginning with f with "frequency"
colnames(complete_dt) <- gsub("Acc", "Accelerometer", colnames(complete_dt)) # Other replacements to make variable names more understandable
colnames(complete_dt) <- gsub("Gyro", "Gyroscope", colnames(complete_dt))
colnames(complete_dt) <- gsub("Mag", "Magnitude", colnames(complete_dt))
colnames(complete_dt)

# 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.

# Summarizing to include just the mean of each variable for each activity and each subject
tidy_dt <- complete_dt %>%
  group_by(activity, subject) %>%
  summarize_each(funs(mean))
str(tidy_dt)

# Export the tidyData set 
write.table(tidy_dt, './tidy_data.txt', row.names = FALSE)