#####################################################################################################
### R Script plot1.R that does the following:
###   1. Reads the data (download the zip file and clean and subset the needed data)
###   2. Plot historgram with red color
#####################################################################################################

library(data.table)
library(lubridate)
#library(dplyr)
#library(sqldf)


plot1 <- function ()
{
    ################################## Clean and read the needed data #############################
    
    #Check if needed data file exist. If not create one else read one.
    if (!file.exists('data/power_consumption.txt')) {
        
        # download the zip file and unzip
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile='data/power_consumption.zip')
        unzip('data/power_consumption.zip',exdir='data',overwrite=TRUE)
        
        # read the raw for just two days
        colClass<-c(rep('character',2),rep('numeric',7))
        powerData<-read.table('data/household_power_consumption.txt',header=TRUE, sep=';',na.strings='?',colClasses=colClass)
        powerData<-powerData[powerData$Date=='1/2/2007' | powerData$Date=='2/2/2007',]
        
        # Rename column names to meaningful names
        colnames(powerData)<-c('Date','Time','GlobalActivePower','GlobalReactivePower','Voltage','GlobalIntensity','SubMetering1','SubMetering2','SubMetering3')

        powerData$DateTime<-dmy(powerData$Date)+hms(powerData$Time)    ## Lubridate package function
        powerData<-powerData[,c(10,3:9)]  ##Bring DateTime column first, and drop Date and Time columns
        
        # write a clean data set to the directory
        write.table(powerData,file='data/power_consumption.txt',sep='|',row.names=FALSE)
    } else {
        
        powerData<-read.table('data/power_consumption.txt',header=TRUE,sep='|')
        powerData$DateTime<-as.POSIXlt(powerData$DateTime)
        
    }
    
    ############### Plot the data #####################################################################
    
    png(filename='plot1.png',width=480,height=480,units='px') # turn on the device
    hist(powerData$GlobalActivePower,main='Global Active Power',xlab='Global Active Power (kilowatts)',col='red')
    Exit<-dev.off()  # turn off the device
    
}

