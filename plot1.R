## Load NEI data
NEI <- readRDS("summarySCC_PM25.rds")

##Convert year column to factor
NEI$year <- as.factor(NEI$year)

##Sum Emissions By Year
emissionsByYear <- as.data.frame(rowsum(NEI$Emissions, NEI$year))


## Open PNG device; create 'plot1.png' in working directory
png(file ="plot1.png") 
##Setup margins for plot
par(mar=c(5.1,8,4.1,2.1))
##Setup base plot of Emissions on y, and year on x
plot(rownames(emissionsByYear), emissionsByYear[,1], ylab="", xlab = "Year", 
     type="l", yaxt="n", main="Total Emissions in United States by Year")
##Add y axis at pretty break points
axis(2, at=pretty(emissionsByYear[,1]), labels=format(pretty(emissionsByYear[,1]), 
     scientific=FALSE), las=2)
##Add y axis label
mtext(side = 2, "Total Amount of PM2.5 emitted, in tons", line = 5)
##Close PNG device
dev.off()