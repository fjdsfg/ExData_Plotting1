#Load the library and the file
library(dplyr)
dataset <- read.csv("household_power_consumption.txt", sep = ";")
dataset <- select(dataset, Date, Time, Global_active_power)

#Filter-out the dates
min_date <- as.Date("01/02/2007",format = "%d/%m/%Y")
max_date <- as.Date("02/02/2007",format = "%d/%m/%Y")
dataset <- mutate(dataset, DateFilter = as.Date(Date,format="%d/%m/%Y"))
dataset<-filter(dataset, DateFilter>=min_date & DateFilter<=max_date)

#Retrieve the levels of the active power as numeric
numeric <- as.numeric(
    levels(dataset$Global_active_power))

#Join the date and time columns
#and select the datetime and global active power columns
dataset<-mutate(
    dataset, 
    Datetime= as.POSIXct(strptime(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")), 
    Global_active_power = numeric[Global_active_power])  %>%
    select(Datetime,Global_active_power)

#Plot the data and save it as a png
png(file="plot2.png", width = 480, height = 480)
with(dataset, plot(Datetime, Global_active_power,"n", xlab="", 
                   ylab="Global Active Power (kilowatts)"))
with(dataset,lines(Datetime, Global_active_power))
dev.off()
