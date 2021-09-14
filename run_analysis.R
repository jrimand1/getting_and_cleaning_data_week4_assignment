setwd("./UCI HAR dataset")

#Reading the training data
xtraindata <- read.table("./train/X_train.txt")
ytraindata <- read.table("./train/Y_train.txt")
subjecttrain<-read.table("./train/subject_train.txt")

#Reading the test data
xtestdata<-read.table("./test/X_test.txt")
ytestdata<-read.table("./test/Y_test.txt")
subjecttest<-read.table("./test/subject_test.txt")

#Reading features description and activity labels
features<-read.table("./features.txt")
activitylabels<-read.table("./activity_labels.txt")

#Merging training and test datasets
xall<-rbind(xtraindata, xtestdata)
yall<-rbind(ytraindata,ytestdata)
subjecttotal<-rbind(subjecttrain, subjecttest)

#naming the variables
names(subjecttotal)<-c("subject")
names(yall)<-c("activity")
names(xall)<-features$V2

#Merging columns to get the complete data frame
combineddata<-cbind(subjecttotal, yall)
fulldataset<-cbind(xall,combineddata)

#Subsetting name of features by measurements on the mean and standard deviation
subsetfeaturesnames<-features$V2[grep("mean\\(\\)|std\\(\\)",features$V2)]

#Subsetting data based on selected names of features
subset_fulldataset<-subset(fulldataset,select=selectednames)

#Turning activities and subjects into factors
subset_fulldataset$activity<-factor(subset_fulldataset$activity, levels=activitylabels[,1],labels=activitylabels[,2])
subset_fulldataset$subject<-as.factor(subset_fulldataset$subject)

#Creating a summary independent tidy dataset from the final dataset
dataset_mean<- subset_fulldataset %>% group_by(activity, subject) %>% summarize_all(funs(mean))
write.table(dataset_mean, file="./dataset_mean_final.txt", row.names=FALSE,col.names=TRUE)