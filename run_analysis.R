## Setup steps
library(dplyr)
library(stringr)
setwd("C:/Coursera/3-GCD/data/proj")

##Step 0: Reading the Files

y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", quote="\"")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", quote="\"")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", quote="\"")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", quote="\"")
features <- read.table("./UCI HAR Dataset/features.txt", quote="\"")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", quote="\"")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", quote="\"")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", quote="\"")

##Step 1: Merging Training and Test Data

test<-cbind(y_test,X_test)

train<-cbind(y_train,X_train)

cnsld<-rbind(train,test)

subject<-rbind(subject_train,subject_test)
names(subject) <-c("Subject")

##Step 3: Uses descriptive activity names to name the activities in the 
##data set

act<-"Activity"

names(cnsld) <- c(act,as.character(features$V2))

##Step 2:Extracts only the measurements on the mean and standard deviation for
##each measurement. 

##String keys
m<-"mean"
sd<-"std"

namelist<-c(act,as.character(features$V2)) ##Setting Column Names

## listing only Columns with Mean, sd and Activity
validlist<-namelist[str_detect(namelist, m) | str_detect(namelist, sd)|
                            str_detect(namelist, act)] 
validdata<-cnsld[,validlist]

##Step 4:Appropriately labels the data set with descriptive variable names. 
names(activity_labels) <- c("Key","Activity.Label")
fvdata<-merge(validdata,activity_labels,by.x="Activity",by.y="Key", all=TRUE)

## Step 5: From the data set in step 4, creates a second, independent tidy 
##data set with the average of each variable for each activity and each subject.
sfvdata<-cbind(fvdata,subject) ## Including Subject Information

## Final Tidy Data Set
tdy.data<-group_by(sfvdata,Subject,Activity.Label) %>% summarise_each(funs(mean))

## Writing to a Text file for Submission
write.table(tdy.data, file="tidy-data.txt",row.name=FALSE,col.names = TRUE)
