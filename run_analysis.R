## Coursera: Getting and Cleaning Data Course Project


## 1.Merges the training and the test sets to create one data set.

##1a.Download the file and unzip it. 
library(dplyr)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "UCI HAR Dataset.zip", method="curl")
unzip("UCI HAR Dataset.zip")

## 1b. The data has been downloaded and saved under the work directory.
## This step is to read all required files into tables.

read.table("UCI HAR Dataset/test/subject_test.txt")->test_subject
read.table("UCI HAR Dataset/train/subject_train.txt")->train_subject

read.table("UCI HAR Dataset/test/X_test.txt")->test_X
read.table("UCI HAR Dataset/train/X_train.txt")->train_X
read.table("UCI HAR Dataset/features.txt")->features

read.table("UCI HAR Dataset/train/y_train.txt")->train_y
read.table("UCI HAR Dataset/test/y_test.txt")->test_y
read.table("UCI HAR Dataset/activity_labels.txt")->activity

##1c.To combine all tables into one data set.
##to combine subject table and give the column name as Subject
rbind(test_subject,train_subject)->subject
colnames(subject)<- "Subject"

##to combine features tables and give the column name from features file
rbind(test_X,train_X)->X
colnames(X)<- t(features[2])

##to combine activity tables and give the column name as Activity
rbind(train_y,test_y)->Y
colnames(Y)<- "Activity"

##to combine all parts into the final full set of data
cbind(subject,X,Y)-> projectdata



##2.Extracts only the measurements on the mean and standard deviation for each measurement. 

##to find column numbers which has either Mean or Std in their column names
grep("mean()|std()", names(projectdata)) -> requiredcolumns

##to return required extracts with column of subjects and activities
extracts<-projectdata[,c(1,563,requiredcolumns)]


##3.Uses descriptive activity names to name the activities in the data set
activity_group <- factor(extracts$Activity)
levels(activity_group) <- activity[,2]
extracts$Activity <- activity_group

##4.Appropriately labels the data set with descriptive variable names. 
names(extracts)<-gsub("^t", "Time", names(extracts))
names(extracts)<-gsub("^f", "Frequency", names(extracts))
names(extracts)<-gsub("Acc", "Accelerometer", names(extracts))
names(extracts)<-gsub("Gyro", "Gyroscope", names(extracts))
names(extracts)<-gsub("BodyBody", "Body", names(extracts))
names(extracts)<-gsub("Mag", "Magnitude", names(extracts))
names(extracts)<-gsub("tBody", "TimeBody", names(extracts))
names(extracts)<-gsub("-mean()", "Mean", names(extracts), ignore.case = TRUE)
names(extracts)<-gsub("-std()", "STD", names(extracts), ignore.case = TRUE)
names(extracts)<-gsub("-freq()", "Frequency", names(extracts), ignore.case = TRUE)
names(extracts)<-gsub("angle", "Angle", names(extracts))
names(extracts)<-gsub("gravity", "Gravity", names(extracts))


##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
extracts %>%
        group_by(Subject, Activity) %>%
        summarise_all(list(mean)) -> tidydata

write.table(tidydata, file = "Tidydata.txt")

