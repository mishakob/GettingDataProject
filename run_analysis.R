
# 1. Merging the training and the test sets to create one data set
cnames <- read.table("./features.txt")
clean_cnames <- cnames$V2
head(clean_cnames)

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
str(full.df)

#######################################################
# 2. Extracting only the measurements on the mean and standard deviation for each measurement
meanstd.vector <- vector()
# pushing into the new vector only columns that deal with mean or standart deviation
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
# 3. Using descriptive activity names to name the activities in the data set
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

