
# read all the data
tlabels <- read.table("test/y_test.txt", col.names="label")
tsubjects <- read.table("test/subject_test.txt", col.names="subject")
tdata <- read.table("test/X_test.txt")
trlabels <- read.table("train/y_train.txt", col.names="label")
trsubjects <- read.table("train/subject_train.txt", col.names="subject")
trdata <- read.table("train/X_train.txt")

datatable <- rbind(cbind(tsubjects, tlabels, tdata), cbind(trsubjects, trlabels, trdata))

# read the features
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

# increment by 2 because data has subjects and labels in the beginning
datatable.mean.std <- datatable[, c(1, 2, features.mean.std$V1+2)]

# read the labels (activities)
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
# replace labels in data with label names
datatable.mean.std$label <- labels[datatable.mean.std$label, 2]

# first make a list of the current column names and feature names
columnam <- c("subject", "label", features.mean.std$V2)
# removing every non-alphabetic character and converting to lowercase
columnam <- tolower(gsub("[^[:alpha:]]", "", columnam))
# then use the list as column names for data
colnames(datatable.mean.std) <- columnam

# find the mean for each combination of subject and label
avgdata <- aggregate(datatable.mean.std[, 3:ncol(datatable.mean.std)],
                     by=list(subject = datatable.mean.std$subject, 
                             label = datatable.mean.std$label),
                     mean)

write.table(format(avgdata, scientific=T), "tidydata.txt",
            row.names=F, col.names=F, quote=2)