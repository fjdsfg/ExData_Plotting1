library(dplyr)
dataset <- read.csv("household_power_consumption.txt", sep = ";")
dataset <- mutate(dataset, Date = as.Date(Date,format="%d/%m/%Y"))

min_date <- as.Date("01/02/2007",format = "%d/%m/%Y")
max_date <- as.Date("02/02/2007",format = "%d/%m/%Y")
dataset<-filter(dataset, Date>=min_date & Date<=max_date)

#Normalize the Active Global Power from factor to numeric
data <- as.numeric(
    levels(dataset$Global_active_power))[dataset$Global_active_power]

#Clean the missing values
data <- data[!is.na(data)]

#Save to graphics device, i.e. to a png file
png(file="plot1.png", width = 480, height = 480)
hist(data, main = "Global Active Power", 
     col = "red", xlab = "Global Active Power (kilowatts)")
dev.off()
