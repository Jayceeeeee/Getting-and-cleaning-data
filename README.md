# This is the description of getting and cleaning data code
## tidydata
tidydata.txt contants the final tidy data, variables are unique, every row represent an observation and every colunm represent a variable.
tidydata.txt has 500 columns, first 477 columns represent the test/train data come from X_test.txt, Y_test.txt, X_train.txt, Y_train.txt; and "label" means the number of the activity, "labelname" means the name of the activity; "rank" is the raw rank of data, "subjectid" represent the id of subject; next 18 columns of data come from inertail signals, it has 9 meansure methods and I calucate it's mean and standrad deviation, this has 18 columns; final column named "class", this's the mark of test data or train data
since the tidydata is too large (60Mb), I only show the first 2000 rows of the data in tidydata.txt

## sub tidy data
it shows the average of each variable for each activity and each subject.
