library(dplyr)
library(tidyr)

#### 1. Obtain the data: download, unzip, result sub-directory UCI HAR Dataset####

dataset_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataset_url, "FUCI_HAR_Dataset.zip")
unzip("FUCI_HAR_Dataset.zip", exdir = "FUCI_HAR_Dataset")


#### 2. Reading data into R ####

# Read training subject actitivity data
train_subj <- read.table(file.path("FUCI_HAR_Dataset", "UCI HAR Dataset/train", "subject_train.txt"))
train_x_data <- read.table(file.path("FUCI_HAR_Dataset", "UCI HAR Dataset/train", "X_train.txt"))
train_y_data <- read.table(file.path("FUCI_HAR_Dataset", "UCI HAR Dataset/train", "y_train.txt"))

# Read test subject actitivity data
test_subj <- read.table(file.path("FUCI_HAR_Dataset", "UCI HAR Dataset/test", "subject_test.txt"))
test_x_data <- read.table(file.path("FUCI_HAR_Dataset", "UCI HAR Dataset/test", "X_test.txt"))
test_y_data <- read.table(file.path("FUCI_HAR_Dataset", "UCI HAR Dataset/test", "y_test.txt"))

# Read features and activity labels data (as characters)
features <- read.table(file.path("FUCI_HAR_Dataset/UCI HAR Dataset", "features.txt"))
features[,2] <- as.character(features[,2])

activity_labels <- read.table(file.path("FUCI_HAR_Dataset/UCI HAR Dataset", "activity_labels.txt"))
activity_labels[,2] <- as.character(activity_labels[,2])

#### 3. Merge the training and the test data sets to generate the single data set ####

# Create a train + test data set
activity_merged <- rbind(
  cbind(train_subj, train_x_data, train_y_data),
  cbind(test_subj, test_x_data, test_y_data)
)

# Add column names to the table
colnames(activity_merged) <- c("subject", features[, 2], "activity")

#### 4. Extract only the measurements on the mean and standard deviation for each measurement ####

# Determine columns of data set containing "mean" and "standard deviation" 
col_wanted <- grep("subject|activity|mean|std", colnames(activity_merged))

# Create the data set containing these columns only
activity_merged <- activity_merged[, col_wanted]

#### 5. Use descriptive activity names to name the activities in the data set ####
activity_merged$activity <- factor(activity_merged$activity, 
                                 levels = activity_labels[, 1], labels = activity_labels[, 2])

#### 6. Appropriately label the data set with descriptive variable names ####

# Obtain column names from merged data
cols_activity <- colnames(activity_merged)

# Remove special characters and rename columns of the merged data set
cols_activity <- gsub("[\\(\\)-]", " ", cols_activity)
cols_activity <- gsub("^f", "frequencyDomain", cols_activity)
cols_activity <- gsub("^t", "timeDomain", cols_activity)
cols_activity <- gsub("Acc", "Accelerometer", cols_activity)
cols_activity <- gsub("Gyro", "Gyroscope", cols_activity)
cols_activity <- gsub("Mag", "Magnitude", cols_activity)
cols_activity <- gsub("Freq", "Frequency", cols_activity)
cols_activity <- gsub("mean", "Mean", cols_activity)
cols_activity <- gsub("std", "StandardDeviation", cols_activity)
cols_activity <- gsub("BodyBody", "Body", cols_activity)

colnames(activity_merged) <- cols_activity

#### 7. Create a second, independent tidy set with the average of each variable for each activity and each subject ####

means_data <- activity_merged %>% 
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

#### 8. Write the data set to the tidy_data.txt file ####

write.table(means_data, "tidy_data.txt", row.names = FALSE, quote = FALSE)


# Export data to xls 
library(openxlsx)
write.xlsx(means_data, "tidy_data.xlsx")

str(activity_merged)

