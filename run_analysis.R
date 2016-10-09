library(dplyr)
#read inertial test data
setwd("~/Rd/UCI HAR Dataset/test/Inertial Signals")
rawfiletest<- list("baxts"="","bayts"="","bazts"="",
               "bgxts"="","bgyts"="","bgzts"="",
               "taxts"="","tayts"="","tazts"="")
filenametest <- c("body_acc_x_test.txt","body_acc_y_test.txt","body_acc_z_test.txt",
              "body_gyro_x_test.txt","body_gyro_y_test.txt","body_gyro_z_test.txt",
              "total_acc_x_test.txt","total_acc_y_test.txt","total_acc_z_test.txt")
for (i in 1:9){
        rawfiletest[[i]] <- read.table(filenametest[i], quote = "")
        #rawfiletest[[i]] <- as.matrix(rawfiletest[[i]])
        #dim(rawfiletest[[i]]) <- c(dim(rawfiletest[[i]])[1]*dim(rawfiletest[[i]])[2],1) 
}



# read inertial train data
setwd("~/Rd/UCI HAR Dataset/train/Inertial Signals")
rawfiletrain<- list("baxta"="","bayta"="","bazta"="",
               "bgxta"="","bgyta"="","bgzta"="",
               "taxta"="","tayta"="","tazta"="")
filenametrain <- c("body_acc_x_train.txt","body_acc_y_train.txt","body_acc_z_train.txt",
              "body_gyro_x_train.txt","body_gyro_y_train.txt","body_gyro_z_train.txt",
              "total_acc_x_train.txt","total_acc_y_train.txt","total_acc_z_train.txt")
for (i in 1:9){
        rawfiletrain[[i]] <- read.table(filenametrain[i], quote = "")
       # rawfiletrain[[i]] <- as.matrix(rawfiletrain[[i]])
        #dim(rawfiletrain[[i]]) <- c(dim(rawfiletrain[[i]])[1]*dim(rawfiletrain[[i]])[2],1) 
}


# read test data
setwd("~/Rd/UCI HAR Dataset/test")
subjecttest <- read.table("subject_test.txt", quote = "")
names(subjecttest) <- "subjectid"
xtest <- read.table("X_test.txt", quote = "")
ytest <- read.table("Y_test.txt", quote = "")

# read train data
setwd("~/Rd/UCI HAR Dataset/train")
subjecttrain <- read.table("subject_train.txt", quote = "")
names(subjecttrain) <- "subjectid"
xtrain <- read.table("X_train.txt", quote = "")
ytrain <- read.table("Y_train.txt", quote = "")

# read labels
setwd("~/Rd/UCI HAR Dataset")
features <- read.table("features.txt", quote = "")
names(features) <- c("count", "names")

activitylabels <- read.table("activity_labels.txt", quote = "")
#names(activitylabels) <- c("count", "names")

# merge data
names(ytest) <- "labelcount"
names(ytrain) <- "labelcount"
names(activitylabels) <- c("labelcount", "labelname")

ytest <- mutate(ytest, rank = 1:nrow(ytest))
ytest <- merge( activitylabels,ytest, by="labelcount")
ytest <- arrange(ytest,rank)

ytrain <- mutate(ytrain, rank = 1:nrow(ytrain))
ytrain <- merge( activitylabels,ytrain, by="labelcount")
ytrain <- arrange(ytrain,rank)


names(xtest) <- c(as.character(features[,2]))
names(xtrain) <- c(as.character(features[,2]))
testset <- cbind(xtest,ytest); trainset <- cbind(xtrain,ytrain)
#testset <- merge(xtest, ytest, by = rank)
#trainset <- merge(xtrain, ytrain, by = rank); 
names(testset)[562] <- "label"; names(trainset)[562] <- "label"
#testset <- cbind(testset, rank = 1:nrow(testset))
#trainset <- cbind(trainset, rank = 1:nrow(trainset))

testset <- cbind(testset,subjecttest); trainset <- cbind(trainset,subjecttrain)


# get mean and deviation
testmeanvalue <- lapply(rawfiletest, rowMeans)
trainmeanvalue <- lapply(rawfiletrain, rowMeans)

testmeanvalue <- data.frame(matrix(unlist(testmeanvalue), nrow=2947, byrow=T),
                 stringsAsFactors=FALSE)
names(testmeanvalue) <- c("baxmean","baymean","bazmean",
                          "bgxmean","bgymean","bgzmean",
                          "taxmean","taymean","tazmean")

trainmeanvalue <- data.frame(matrix(unlist(trainmeanvalue), nrow=7352, byrow=T),
                            stringsAsFactors=FALSE)
names(trainmeanvalue) <- c("baxmean","baymean","bazmean",
                          "bgxmean","bgymean","bgzmean",
                          "taxmean","taymean","tazmean")

mysd <- function(ss){
        return(apply(ss, 1, sd))
}
testsdvalue <- sapply(rawfiletest, mysd)
trainsdvalue <- sapply(rawfiletrain, mysd)

# merge mean and sd

testset <- cbind(testset,testmeanvalue); trainset <- cbind(trainset,trainmeanvalue)
testset <- cbind(testset,testsdvalue); trainset <- cbind(trainset,trainsdvalue)

# add labels
testset <- cbind(testset, class = rep("test",nrow(testset)))
trainset <- cbind(trainset, class = rep("train",nrow(trainset)))

# combine to data set
names(testset)[575:583] <- c("baxsd","baysd","bazsd",
                           "bgxsd","bgysd","bgzsd",
                           "taxsd","taysd","tazsd")
names(trainset)[575:583] <- c("baxsd","baysd","bazsd",
                             "bgxsd","bgysd","bgzsd",
                             "taxsd","taysd","tazsd")
myset <- rbind(testset,trainset)

myset <- myset[,-(475:502)]
myset <- myset[,-(396:423)]
myset <- myset[,-(317:344)]

myset <- tbl_df(myset)
myset <- group_by(myset,as.factor(labelname),as.factor(subjectid))

a <- summarize(myset, baxsd = mean(baxsd))

write.table(a,file = "data.txt",row.names = FALSE)

#myset <- group_by(myset,as.factor(subjectid))

#b <- summarize(myset, baxsd = mean(baxsd))





