# Load dependencies.
library(tidyverse)

# Download dataset (if necessary).
data_archive <- "datset.zip"
if (!file.exists(data_archive)) {
    data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url=data_url, destfile=data_archive)
}

# Extract dataset (if necessary).
data_dir <- "data"
if (!file.exists(data_dir)) {
    dir.create(data_dir, showWarnings = FALSE)
    unzip(zipfile = data_archive, exdir = data_dir)
}

# Set paths for data files.
train_x_path <- file.path(data_dir, "UCI HAR Dataset", "train", "X_train.txt")
train_y_path <- file.path(data_dir, "UCI HAR Dataset", "train", "y_train.txt")
train_sub_path <- file.path(data_dir, "UCI HAR Dataset", "train", "subject_train.txt")
test_x_path <- file.path(data_dir, "UCI HAR Dataset", "test", "X_test.txt")
test_y_path <- file.path(data_dir, "UCI HAR Dataset", "test", "y_test.txt")
test_sub_path <- file.path(data_dir, "UCI HAR Dataset", "test", "subject_test.txt")
features_path <- file.path(data_dir, "UCI HAR Dataset", "features.txt")
activities_path <- file.path(data_dir, "UCI HAR Dataset", "activity_labels.txt")

# Read data from files.
feature_names <- read_table(features_path, col_names = FALSE)
feature_names <- feature_names[[1]]
feature_names <- sub(pattern = "\\d+ ", replacement = "", x = feature_names)
train_x <- read_table(train_x_path, col_names = feature_names)
train_y <- read_table(train_y_path, col_names = "activity.name")
train_sub <- read_table(train_sub_path, col_names = "subject")
test_x <- read_table(test_x_path, col_names = feature_names)
test_y <- read_table(test_y_path, col_names = "activity.name")
test_sub <- read_table(test_sub_path, col_names="subject")
activities <- read_table(activities_path, col_names = FALSE)
activities <- select(activities, X2)

# 1.Merge the training and the test sets to create a single data set.
merged_dataset <- bind_rows(bind_cols(bind_cols(train_x, train_y), train_sub), bind_cols(bind_cols(test_x, test_y), test_sub))

# 2. Extract only the measurements on the mean and standard deviation for each measurement.
names_of_mean_and_std <- names(select(merged_dataset, grep(pattern = "mean\\(\\)|std", x = names(merged_dataset))))
merged_cut_dataset <- select(merged_dataset, names_of_mean_and_std)
merged_data_named <- bind_cols(merged_dataset["subject"], merged_dataset["activity.name"], merged_cut_dataset)

# 3.Use descriptive activity names to name the activities in the data set.
merged_data_named["activity.name"] <- sapply(select(merged_data_named, activity.name), function(x){activities[x,]})
var_names <- names(merged_data_named)

# 4. Appropriately label the data set with descriptive variable names.
var_names <- sapply(var_names, tolower)
var_names <- unname(obj = var_names)
var_names <- sub(pattern = "\\.", replacement = "", x = var_names)
var_names <- sub(pattern = "^t", replacement = "time", x = var_names)
var_names <- sub(pattern = "acc", replacement = "Acceleration", x = var_names)
var_names <- sub(pattern = "f", replacement = "frequency", x = var_names)
var_names <- gsub(pattern = "-", replacement = "", x = var_names)
var_names <- sub(pattern = "gyro", replacement = "Gyroscope", x = var_names)
var_names <- sub(pattern = "std", replacement =  ".standardDeviation", x = var_names)
var_names <- sub(pattern = "\\(\\)", replacement = "", x = var_names)
var_names <- sub(pattern = "mag", replacement = "Magnitude", x = var_names)
var_names <- sub(pattern = "mean", replacement = ".mean", x = var_names)
var_names <- sub(pattern = "y$", replacement = ".Y", x = var_names)
var_names <- sub(pattern = "x$", replacement = ".X", x = var_names)
var_names <- sub(pattern = "z$", replacement = ".Z", x = var_names)
var_names <- sub(pattern = "^activity", replacement = "activity.", x = var_names)
var_names <- sub(pattern = "body", replacement = "Body", x = var_names)
var_names <- sub(pattern = "jerk", replacement = "Jerk", x = var_names)

names(merged_data_named) <- var_names

# 5. From the data set in step 4, create a second, independent tidy data 
by_activity_sub <- merged_data_named %>% group_by(subject, activity.name)
summ <- by_activity_sub %>% summarise_all(.funs = mean)
write.table(x = summ, file = "tidy.txt", row.names = FALSE)
summ