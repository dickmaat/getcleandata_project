# =============================================================================
# Getting and cleaning data project
# Dick ter Maat
# 23-aug-2015 
#
# ------------------------------------------------------------------------------
# Used environment:
#
# Fedora 22 Running on a AMD A8-7600 Radeon R7, 10 Compute Cores 4C+6G 
#
# > R.version.string  --> [1] "R version 3.2.1 (2015-06-18)"

# ------------------------------------------------------------------------------
# ASSUMPTIONS
# 1. The data present in the working directory.
# 2. The data is zipped in a file called 
#    "getdata_projectfiles_UCI HAR Dataset.zip".
# ==============================================================================

# setwd("/home/dick/Documenten/Coursera/Getting_and_cleaning_data/project")

# ==============================================================================
# 1. Extract the testdata en traindata from the ZIP-file.

unzip("getdata_projectfiles_UCI HAR Dataset.zip")

# Get the column-names from FEATURES.TXT, only 2nd column!
feat <- read.table("UCI HAR Dataset/features.txt")$V2

# Assigment: select only the columns with "MEAN" and "STANDARD DEVIATION".
# Meaning all columns with MEAN() or STD() in their name:
feat_mean <- grep("mean[(]",feat)
feat_std <- grep("std[(]",feat)

# Adjust then column
feat<-gsub("BodyBody", "Body", feat)
feat<-gsub(",", "_",feat)
feat<-gsub(" ", "",feat)
feat<-gsub("-", "_",feat)
feat<-gsub("[(][)]", "",feat)



# Read the data.
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names=feat)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names=feat)
# Combine the 2 sets into 1.
x<- rbind(x_test,x_train)
remove("x_test","x_train")

# === Add a column for the activity ====
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names=c("Activity_nr"))
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names=c("Activity_nr"))
y <- rbind(y_test,y_train)
remove("y_test", "y_train")


# And create a new dataset with only the columns with MEAN/ STD.
z <- x[,c(feat_mean,feat_std)]
remove("x")
xy=cbind(y,z)
remove("y","z")
remove("feat_std", "feat_mean")

# We want the ACTIVITY as text, but we have now only the number --> replace.
# Read the file with the activity label.
act_label <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("Activity_nr","Activity"))

# MERGE; but that sorts...
xy_act <- merge(xy, act_label, by.x="Activity_nr", by.y="Activity_nr")
remove("act_label"); remove("xy")
# Remove the Activity_nr column;
xy_act$Activity_nr <- NULL

library("sqldf")
result <- sqldf("select
                 tBodyAcc_mean_X as TimeSeries_Body_Accelaration_Average_DirectionX
                ,tBodyAcc_mean_Y as TimeSeries_Body_Accelaration_Average_DirectionY
                ,tBodyAcc_mean_Z as TimeSeries_Body_Accelaration_Average_DirectionZ
                ,tGravityAcc_mean_X as TimeSeries_Gravity_Accelaration_Average_DirectionX
                ,tGravityAcc_mean_Y as TimeSeries_Gravity_Accelaration_Average_DirectionY
                ,tGravityAcc_mean_Z as TimeSeries_Gravity_Accelaration_Average_DirectionZ
                ,tBodyAccJerk_mean_X as TimeSeries_Body_AccelarationChange_Average_DirectionX
                ,tBodyAccJerk_mean_Y as TimeSeries_Body_AccelarationChange_Average_DirectionY
                ,tBodyAccJerk_mean_Z as TimeSeries_Body_AccelarationChange_Average_DirectionZ
                ,tBodyGyro_mean_X as TimeSeries_Body_Gyro_Average_DirectionX
                ,tBodyGyro_mean_Y as TimeSeries_Body_Gyro_Average_DirectionY
                ,tBodyGyro_mean_Z as TimeSeries_Body_Gyro_Average_DirectionZ
                ,tBodyGyroJerk_mean_X as TimeSeries_Body_GyroChange_Average_DirectionX
                ,tBodyGyroJerk_mean_Y as TimeSeries_Body_GyroChange_Average_DirectionY
                ,tBodyGyroJerk_mean_Z as TimeSeries_Body_GyroChange_Average_DirectionZ
                ,tBodyAccMag_mean as TimeSeries_Body_AccelarationMagnitude_Average
                ,tGravityAccMag_mean as TimeSeries_Gravity_AccelarationMagnitude_Average
                ,tBodyAccJerkMag_mean as TimeSeries_Body_AccelarationChangeMagnitude_Average
                ,tBodyGyroMag_mean as TimeSeries_Body_GyroMagnitude_Average
                ,tBodyGyroJerkMag_mean as TimeSeries_Body_GyroChangeMagnituede_Average
                ,fBodyAcc_mean_X as Fourier_Body_Accelaration_Average_DirectionX
                ,fBodyAcc_mean_Y as Fourier_Body_Accelaration_Average_DirectionY
                ,fBodyAcc_mean_Z as Fourier_Body_Accelaration_Average_DirectionZ
                ,fBodyAccJerk_mean_X as Fourier_Body_AccelarationChange_Average_DirectionX
                ,fBodyAccJerk_mean_Y as Fourier_Body_AccelarationChange_Average_DirectionY
                ,fBodyAccJerk_mean_Z as Fourier_Body_AccelarationChange_Average_DirectionZ
                ,fBodyGyro_mean_X as Fourier_Body_Gyro_Average_DirectionX
                ,fBodyGyro_mean_Y as Fourier_Body_Gyro_Average_DirectionY
                ,fBodyGyro_mean_Z as Fourier_Body_Gyro_Average_DirectionZ
                ,fBodyAccMag_mean as Fourier_Body_AccelarationMagnitude_Average
                ,fBodyAccJerkMag_mean as Fourier_Body_AccelarationChangeMagnitude_Average
                ,fBodyGyroMag_mean as Fourier_Body_GyroMagnitude_Average
                ,fBodyGyroJerkMag_mean as Fourier_Body_GyroMagnitudeChange_Average
                ,tBodyAcc_std_X as TimeSeries_Body_Accelaration_StdDev_DirectionX
                ,tBodyAcc_std_Y as TimeSeries_Body_Accelaration_StdDev_DirectionY
                ,tBodyAcc_std_Z as TimeSeries_Body_Accelaration_StdDev_DirectionZ
                ,tGravityAcc_std_X as TimeSeries_Gravity_Accelaration_StdDev_DirectionX
                ,tGravityAcc_std_Y as TimeSeries_Gravity_Accelaration_StdDev_DirectionY
                ,tGravityAcc_std_Z as TimeSeries_Gravity_Accelaration_StdDev_DirectionZ
                ,tBodyAccJerk_std_X as TimeSeries_Body_AccelarationChange_StdDev_DirectionX
                ,tBodyAccJerk_std_Y as TimeSeries_Body_AccelarationChange_StdDev_DirectionY
                ,tBodyAccJerk_std_Z as TimeSeries_Body_AccelarationChange_StdDev_DirectionZ
                ,tBodyGyro_std_X as TimeSeries_Body_Gyro_StdDev_DirectionX
                ,tBodyGyro_std_Y as TimeSeries_Body_Gyro_StdDev_DirectionY
                ,tBodyGyro_std_Z as TimeSeries_Body_Gyro_StdDev_DirectionZ
                ,tBodyGyroJerk_std_X as TimeSeries_Body_GyroChange_StdDev_DirectionX
                ,tBodyGyroJerk_std_Y as TimeSeries_Body_GyroChange_StdDev_DirectionY
                ,tBodyGyroJerk_std_Z as TimeSeries_Body_GyroChange_StdDev_DirectionZ
                ,tBodyAccMag_std as TimeSeries_Body_AccelarationMagnitude_StdDev
                ,tGravityAccMag_std as TimeSeries_Gravity_AccelarationMagnitude_StdDev
                ,tBodyAccJerkMag_std as TimeSeries_Body_AccelarationChangeMagnitude_StdDev
                ,tBodyGyroMag_std as TimeSeries_Body_GyroMagnitude_StdDev
                ,tBodyGyroJerkMag_std as TimeSeries_Body_GyroChangeMagnitude_StdDev
                ,fBodyAcc_std_X as Fourier_Body_Accelaration_StdDev_DirectionX
                ,fBodyAcc_std_Y as Fourier_Body_Accelaration_StdDev_DirectionY
                ,fBodyAcc_std_Z as Fourier_Body_Accelaration_StdDev_DirectionZ
                ,fBodyAccJerk_std_X as Fourier_Body_AccelarationChange_StdDev_DirectionX
                ,fBodyAccJerk_std_Y as Fourier_Body_AccelarationChange_StdDev_DirectionY
                ,fBodyAccJerk_std_Z as Fourier_Body_AccelarationChange_StdDev_DirectionZ
                ,fBodyGyro_std_X as Fourier_Body_Gyro_StdDev_DirectionX
                ,fBodyGyro_std_Y as Fourier_Body_Gyro_StdDev_DirectionY
                ,fBodyGyro_std_Z as Fourier_Body_Gyro_StdDev_DirectionZ
                ,fBodyAccMag_std as Fourier_Body_AccelarationMagnitude_StdDev
                ,fBodyAccJerkMag_std as Fourier_Body_AccelarationMagnitudeChange_StdDev
                ,fBodyGyroMag_std as Fourier_Body_GyroMagnitude_StdDev
                ,fBodyGyroJerkMag_std as Fourier_Body_GyroMagnitudeChange_StdDev
                ,Activity as Activity
                
                from xy_act
                ")

# ============= Finished dataset Z_ACT =================

# Now the average; no average on the ACTIVITY as this is text. 
agg_ds <- aggregate(result[-ncol(xy_act)], by=list(result$Activity), FUN="mean")
colnames(agg_ds)[1]<-"Activity"

# write the AGG_DS dataset into a text-file.
write.table(agg_ds , "aggregate_ds.txt", row.names = FALSE)
# -- The End -- 

