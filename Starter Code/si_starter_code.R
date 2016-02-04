library(reshape)

#download the datasets onto your computer first and set appropriate working directory

commodityflow <- read.csv("commodityflow.txt") #read this in using Import Dataset to read it in cleanly
foreigntrade <- read.csv("foreigntrade.csv")

commodityflow$Country <- rep(NA)
commodityflow$Country <- ifelse(commodityflow$EXPORT_CNTRY=="C","Canada", commodityflow$Country)
commodityflow$Country <- ifelse(commodityflow$EXPORT_CNTRY=="M","Mexico", commodityflow$Country)

#dim(commodityflow)

foreigntrade <- rename(foreigntrade, c("CTYNAME"="Country"))
together <- merge(commodityflow,foreigntrade,by="Country")
together2 <- na.omit(together)

#View(together2)