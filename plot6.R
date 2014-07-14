##If Necessary, ensure you have the ggplot2 package installed 
##install.packages("ggplot2")
library("ggplot2")
##If Necessary, ensure you have the reshape2 package installed 
##install.packages("reshape2")
library("reshape2")
library("scales")

##If Necessary, ensure you have the gridExtra package installed 
##install.packages("gridExtra")
library("gridExtra")

## Load NEI data
NEI <- readRDS("summarySCC_PM25.rds")

##Extract Baltimore & LA Data
balLaNEI <- subset(NEI, fips=="24510" | fips=="06037")

## Load Classification data for NEI$SCC data
SCC <- readRDS("Source_Classification_Code.rds")
##Focus on EI.Sectors that have Vehicles
vehicleSCC <- subset(SCC, grepl("Vehicle", EI.Sector))

##Convert year column to factor
balLaNEI$year <- as.factor(balLaNEI$year)


##merge vehicle focused SCC data with NEI data
##match on SCC column
vehicleSCCNEI <- merge(balLaNEI, vehicleSCC, by=c("SCC"))
##Convert type & EI.Sector to factor
vehicleSCCNEI$type <- factor(vehicleSCCNEI$type)
vehicleSCCNEI$EI.Sector <- factor(vehicleSCCNEI$EI.Sector)

##Sum Emissions By Year By EI.Sector
emissionsByYearFips <- as.data.frame(tapply(vehicleSCCNEI$Emissions, 
     INDEX=list(vehicleSCCNEI$year,vehicleSCCNEI$fips), FUN=sum))
##Add year as a column
emissionsByYearFips$year <- rownames(emissionsByYearFips)
##Melt matrix to produce long table with EI.Sector as factor
emissionsPlotEI <- melt(emissionsByYearFips, id="year")
colnames(emissionsPlotEI) <- c("year", "fips", "emission")
##Change Factors to be Names
emissionsPlotEI$fips <- factor(emissionsPlotEI$fips, 
     levels=c('06037', '24510'), labels=c('Los Angeles', 'Baltimore'))


##Create ggplot
p6 <- ggplot(emissionsPlotEI, aes(x=year, y=emission, group=fips,
     color=fips)) + geom_line() + 
     ggtitle ("Vehicle Emissions") + 
     xlab("Year") + ylab("Total Amount of PM2.5 emitted, in tons") + 
     scale_y_continuous(labels = comma) +
     stat_smooth(method = "lm")

##Use ggsave to save the plot to plot6.png
ggsave(filename="plot6.png", plot=p6, scale=1.2)