# 3_Getting_and_Cleaning_Data

This project demonstrates practical application of the key concepts of the Getting and Cleaning Data course.

Source data: measurements of human body activities, collected from the accelerometers from the Samsung Galaxy S smartphone, 
retrieved from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.


The github repository contains the following files:

1. README.md - an explanation of how the final data set was created
2. tidy_data.txt - the file containing the tidy data set
3. CodeBook.md -  the code book describing the structure of the data set 
4. run_analysis.R  - the code used to create the data set 

Descriprion of steps applied to generate the tidy data according to the task:

1. Download and unzip source data, saving it to the local folder "UCI_HAR_Dataset"
2. Read data into the run_analysis.R
3. Merge the training and the test data sets to generate the single data set
4. Extract only the measurements on the mean and standard deviation for each measurement
5. Use descriptive activity names to name the activities in the data set
6. Appropriately label the data set with descriptive variable names
7. Create a second, independent tidy set with the average of each variable for each activity and each subject
8. Write the data set to the tidy_data.txt file
