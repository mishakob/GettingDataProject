
# Merging the training and the test sets to create one data set
cnames <- read.table("./features.txt")
clean_cnames <- cnames$V2

# reading train data
train.x <- read.table("./train/X_train.txt", col.names=clean_cnames)
train.subject <- read.table("./train/subject_train.txt", col.names="subject")
train.y <- read.table("./train/y_train.txt", col.names="activity")

# reading test data
test.x <- read.table("./test/X_test.txt", col.names=clean_cnames)
test.subject <- read.table("./test/subject_test.txt", col.names="subject")
test.y <- read.table("./test/y_test.txt", col.names="activity")

# combining to a single data frame
train.df <- cbind(train.x, train.subject, train.y)
test.df <- cbind(test.x, test.subject, test.y)
full.df <- rbind(train.df,test.df)

#######################################################
# Extracting only the measurements on the mean and standard deviation for each measurement

# Creating a new vector including only column names that deal with mean or standard deviation
meanstd.vector <- vector()
for(i in 1:ncol(full.df))
  {
  if (grepl("mean|std", colnames(full.df)[i]) == "TRUE")
  {
    meanstd.vector <- c(meanstd.vector,colnames(full.df)[i])
  }
}
# selecting only relevant columns in the new data frame
meanstd.vector <- c(meanstd.vector,"subject","activity")
meanstd.vector
tidy.df <- full.df[,meanstd.vector]
#######################################################
# Using descriptive activity names to name the activities in the data set
activityLabels <- read.table("./activity_labels.txt")
colnames(activityLabels) <- c("activity", "activityLabel")

# matching activity label for each row
for(i in 1:nrow(tidy.df))
{
  for(j in 1:nrow(activityLabels))
  {
    if(tidy.df$activity[i] == j)
    {
      tidy.df$activityLabel[i] <- as.character(activityLabels$activityLabel[j])
    }
  }
}
#######################################################
# Creating a second, independent tidy data set with the average of each variable for each activity and each subject. 
library(reshape2) # reshape2 package required

# melting the data frame with subject, activity code and activity label as id variables
molten <- melt(tidy.df, id.vars = c("subject", "activity", "activityLabel"))

# recasting into new data frame, grouping by subject and activity, 
# while calculating the mean for each combination
tidy.df2 <- dcast(molten, subject + activityLabel ~ variable, fun.aggregate=mean)

#######################################################
# Giving new (descriptive) names to the variables
# Removing special characters and generally getting the variable names more readable
# Using Camel Case format due to long variable names
names(tidy.df2) <- gsub("Mag", "Magnitude", names(tidy.df2))
names(tidy.df2) <- gsub("Acc", "Acceleration", names(tidy.df2))
names(tidy.df2) <- gsub("\\.", "", names(tidy.df2))
names(tidy.df2) <- gsub("mean", "Mean", names(tidy.df2))
names(tidy.df2) <- gsub("std", "Std", names(tidy.df2))
names(tidy.df2) <- gsub("^t", "time", names(tidy.df2))
names(tidy.df2) <- gsub("^f", "freq", names(tidy.df2))
names(tidy.df2) <- gsub("BodyBody", "Body", names(tidy.df2))
names(tidy.df2)

######################################################
write.table(tidy.df2, "./tidy.txt")