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

## Open PNG device with transparent background and 2x2 area
png(file = "plot4.png", bg = "transparent")
par(mfrow = c(2,2))
## Make top left plot
plot(data$Time, data$Global_active_power, ylab="Global Active Power", xlab = "", pch = NA)
lines(data$Time, data$Global_active_power)
## Make top right plot
plot(data$Time, data$Voltage, pch = NA, xlab="datetime",ylab="Voltage")
lines(data$Time,data$Voltage)
## Make bottom left plot
with(data, {
  plot(Time, Sub_metering_1, pch = NA, ylab = "Energy sub metering", xlab="")
  lines(Time, Sub_metering_1)
  lines(Time, Sub_metering_2, col = "red")
  lines(Time, Sub_metering_3, col = "blue")
  legend("topright", lty = 1,bty="n",col = c("black", "red", "blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
})
## Make bottom right plot 
plot(data$Time, data$Global_reactive_power, pch=NA,xlab="datetime",ylab="Global_reactive_power")
lines(data$Time,data$Global_reactive_power)
dev.off()

