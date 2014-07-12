##If Necessary, enusre you have the calibrate package installed
##install.packages("calibrate")
##Load Calibrate package for use of textxy function
library("calibrate")

## Load NEI data
NEI <- readRDS("summarySCC_PM25.rds")

##Convert year column to factor
NEI$year <- as.factor(NEI$year)

##Extract Baltimore Data
baltimoreNEI <- NEI[NEI$fips == "24510",]

##Sum Emissions By Year
emissionsByYear <- as.data.frame(rowsum(baltimoreNEI$Emissions, baltimoreNEI$year))


## Open PNG device; create 'plot2.png' in working directory
png(file ="plot2.png") 
##Setup margins for plot
par(mar=c(5.1,8,4.1,2.1))
##Setup base plot of Emissions on y, and year on x
plot(rownames(emissionsByYear), emissionsByYear[,1], ylab="", xlab = "Year", type="l", yaxt="n", main="Total Emissions in Baltimore by Year")
##Add y axis at pretty break points
axis(2, at=pretty(emissionsByYear[,1]), labels=format(pretty(emissionsByYear[,1]), scientific=FALSE), las=2)
##Add y axis label
mtext(side = 2, "Total Amount of PM2.5 emitted, in tons", line = 5)
##Add points labels with total emissions
textxy(rownames(emissionsByYear), emissionsByYear[,1], labs=format(emissionsByYear[,1], scientific=FALSE, digits=4), cex=.7, offset= 0)
##Close PNG device
dev.off()