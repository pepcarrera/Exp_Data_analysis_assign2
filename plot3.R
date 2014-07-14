##If Necessary, ensure you have the ggplot2 package installed 
##install.packages("ggplot2")
library("ggplot2")
##If Necessary, ensure you have the reshape2 package installed 
##install.packages("reshape2")
library("reshape2")
## Load NEI data
NEI <- readRDS("summarySCC_PM25.rds")
## Load Classification data for NEI$SCC data
SCC <- readRDS("Source_Classification_Code.rds")
##Convert year column to factor
NEI$year <- as.factor(NEI$year)

##Extract Baltimore Data
baltimoreNEI <- NEI[NEI$fips == "24510",]

##merge SCC data with baltimoreNEI data
##match on SCC column
baltimoreSCCNEI <- merge(baltimoreNEI, SCC, by=c("SCC"))

##Sum Emissions By Year By type
emissionsByYearType <- as.data.frame(tapply(baltimoreSCCNEI$Emissions, 
    INDEX=list(baltimoreSCCNEI$year,baltimoreSCCNEI$type), FUN=sum))
##Add year as a column
emissionsByYearType$year <- rownames(emissionsByYearType)
##Melt matrix to produce long table with type as factor
emissionsPlot <- melt(emissionsByYearType, id="year")
colnames(emissionsPlot) <- c("year", "type", "emission")
##Save facet based qplot to g
g <- qplot(year, emission, facets=.~type, data=emissionsPlot, 
      main="Baltimore Emissions by Type By Year", xlab="Year", 
      ylab="Total Amount of PM2.5 emitted, in tons")
##Use ggsave to save the plot to plot3.png
ggsave(filename="plot3.png", plot=g, scale=.75)