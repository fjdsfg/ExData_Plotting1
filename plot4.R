#Load the library and the file
library(dplyr)
dataset <- read.csv("household_power_consumption.txt", sep = ";")

#Filter-out the dates
min_date <- as.Date("01/02/2007",format = "%d/%m/%Y")
max_date <- as.Date("02/02/2007",format = "%d/%m/%Y")
dataset <- mutate(dataset,
                  DateFilter = as.Date(Date,format="%d/%m/%Y"))

dataset<-filter(dataset, DateFilter>=min_date & DateFilter<=max_date)

#Select Date and Time as Datetime and select
#the only relevant columns
dataset<-mutate(dataset, 
    Datetime = 
        as.POSIXct(strptime(paste(Date, Time), format="%d/%m/%Y %H:%M:%S"))) %>%
    select(Datetime,Global_active_power:Voltage,Sub_metering_1:Sub_metering_3)

#Retrieve the names of the columns that are factors
columns <- names(dataset)[2:6]

#Convert the factors into numerics
for(column in columns){
    numeric <- levels(dataset[,column])
    dataset[,column]<-as.numeric(numeric[dataset[,column]])
}

#Setup the graphics device
png("plot4.png",width = 480,height = 480)

#Parametrize the group of charts 
par(mfrow=c(2,2))

#Global Active Power - position (1,1)
with(dataset, plot(Datetime, Global_active_power,"n", xlab="", 
                   ylab="Global Active Power (kilowatts)"))
with(dataset,lines(Datetime, Global_active_power))

#Voltage - position (1,2)
with(dataset, plot(Datetime, Voltage,"n", xlab="", 
                   ylab="Voltage (V)"))
with(dataset,lines(Datetime, Voltage))

#Energy sub-metering (2,1)
with(dataset,
     plot(Datetime,Sub_metering_1,"n", xlab = "", ylab="Energy sub metering"))
with(dataset,lines(Datetime,Sub_metering_1, col="black"))
with(dataset,lines(Datetime,Sub_metering_2, col="red"))
with(dataset,lines(Datetime,Sub_metering_3, col="blue"))
legend("topright", 
       legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), 
       col = c("black","red","blue"),
       lty = "solid",
       bty = "n")

#Global Reactive Power
with(dataset, plot(Datetime, Global_reactive_power,"n", xlab="", 
                   ylab="Global Reactive Power (kilowatts)"))
with(dataset,lines(Datetime, Global_reactive_power))
dev.off()