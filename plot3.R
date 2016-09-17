#Load the library and the file
library(dplyr)
dataset <- read.csv("household_power_consumption.txt", sep = ";")
dataset <- select(dataset, Date, Time, Sub_metering_1:Sub_metering_3)

#Filter-out the dates
min_date <- as.Date("01/02/2007",format = "%d/%m/%Y")
max_date <- as.Date("02/02/2007",format = "%d/%m/%Y")
dataset <- mutate(dataset, DateFilter = as.Date(Date,format="%d/%m/%Y"))
dataset<-filter(dataset, DateFilter>=min_date & DateFilter<=max_date)

#Define the columns that will be converted to a numeric format
numeric_1 <- levels(dataset$Sub_metering_1)
numeric_2 <- levels(dataset$Sub_metering_2)

#Transform each column for the respective plot
#i.e. have a continuous timeline in terms of date and time
#plus transform the data to numeric
dataset<-mutate(
    dataset, 
    Datetime= as.POSIXct(strptime(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")), 
    Sub_metering_1 = as.numeric(numeric_1[Sub_metering_1]),
    Sub_metering_2 = as.numeric(numeric_2[Sub_metering_2]))  %>%
    select(Datetime, Sub_metering_1, Sub_metering_2, Sub_metering_3)

#Plot the lines from each sub-meter
png(file="plot3.png", width = 480, height = 480)
with(dataset,
     plot(Datetime,Sub_metering_1,"n", xlab = "", ylab="Energy sub metering"))
with(dataset,lines(Datetime,Sub_metering_1, col="black"))
with(dataset,lines(Datetime,Sub_metering_2, col="red"))
with(dataset,lines(Datetime,Sub_metering_3, col="blue"))
legend("topright", 
       legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), 
       col = c("black","red","blue"),
       lty = "solid")
dev.off()