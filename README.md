# Run the "run_analysis.R" file for the result.

**Assumptions**

1. The "run_analysis.R" is placed in the working directory.

2. The working directory containes the zipped data "getdata_projectfiles_UCI HAR Dataset.zip".

***
**Workings**

1. The data is unzipped.
2. Columnnames are read from the "features.txt".
3. The indexes of all the columnnames containing MEAN() and STD() are selected according to assignment.
4. The columnnames are adjusted to more 'normal' values.
5. Both the data for the x-test and x-train data are read. Using the colnames option the columnnames are set at the same time. The x-train data is appended.
6. The data with the activity is read (y-test & y-train). The y-train is appended
7. A dataset Z is created with only the columnnames with MEAN and STD (step 3).
8. To the dataset Z is added to the dataset with the activity to created xy. 
9. The activitynames is read from the "activity_labels.txt", and merged with the xy to create xy_act, on the basis of "activity_nr"
10. As the "activity_nr" is now superfluous it is removed.
11. The library "SQLDF" is loaded for creating the final dataset "result".
12. With a SQL-statement the final dataset "result" is created. The SQL is also used to rename the columns.
13. Using the "aggregrate" statement the dataset "agg_ds" is created with the average of every variabele.
14. The dataset "agg_ds" is converted into a text-file.

***

