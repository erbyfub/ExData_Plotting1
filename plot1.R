if (!file.exists("exdata_data_household_power_consumption.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "exdata_data_household_power_consumption.zip")
}

if (!file.exists("household_power_consumption.txt")) {
  unzip("exdata_data_household_power_consumption.zip")
}

## Load data and make Date characters
fulldata <- read.table("household_power_consumption.txt",header=TRUE,sep=";",na.strings="?")
fulldata$Date <- as.character(fulldata$Date)

## Remove all observations except Feb 1-2, 2007
library(dplyr)
data <- filter(fulldata,Date == "1/2/2007" | Date == "2/2/2007")

## Convert Date and Time to POSIX
data$Date <- as.Date(data$Date,"%d/%m/%Y")
data$Time <- as.character(data$Time)
data$Time <- strptime(paste(data[,1],data[,2]),"%Y-%m-%d %H:%M:%S")

## Open PNG device
png(file = "plot1.png", bg = "transparent")
## Make plot 1
hist(data$Global_active_power, col = "red", xlab="Global Active Power (kilowatts)", main = "Global Active Power")
dev.off()
