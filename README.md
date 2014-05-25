## Getting and Cleaning Data Course Project

The script that creates the final "tidy" dataset has 5 main elements - matching the assignment steps
I chose to perform step 5 before step 4, as it is more convenient that way.

### step 1: Merging the training and the test sets to create one data set.

* read all 6 files (".x", ".subject" and ".y" for training and test datasets) using "read.table" - naming the columns using "features.txt" file
* create training data frame and test data frame using "cbind"
* create full data frame using "rbind" on training and test datasets

### step 2: Extracting only the measurements on the mean and standard deviation for each measurement

In this step I've decided to include every variable dealing with mean or standard deviation in any way - including "meanFreq" variables
* create a new vector including only column names that deal with mean or standard deviation by iterating through data frame column names and selecting appropriate names with "grepl" function
* create a new data frame that includes only the columns with names included in the new vector +"activity" and "subject" columns

### step 3: Using descriptive activity names to name the activities in the data set

Here we're matching the activity codes (1 through 6) to the activity labels from "activity_labels.txt" file
* read "activity_labels.txt" using "read.table" with columns named "activity" and "activity label"
* iterate through every row in our full data frame and check for match between "activity" column values against the new "activity" table. Write the matching label for each row into a new "activityLabel" column

### step 5: Creating a second, independent tidy data set with the average of each variable for each activity and each subject. 

Basically, here we're aiming to create unique combinations of subject+activity and calculate an each variable's average value for each such combination.
I've chosen to use reshape2 package here (has to be installed before running the script).
* "melt" the data frame with subject, activity code and activity label as id variables
* recasting into new "tidy" data frame, grouping by subject and activity, while calculating the mean for each combination using "dcast" function

### step 4: Giving new (descriptive) names to the variables

The aim here is to make the variable names both 100% readable by R and more user-friendly
Given the long variable names I've chosen to use Camel Case format instead of lowercasing everything

* use gsub() for removing special characters (such as "." or ()), expand short names into meaningful ones (such as "acceleration", not "Acc") and uppercasing staff like "mean" and "std"

