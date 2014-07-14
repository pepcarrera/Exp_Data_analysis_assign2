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

##Extract Baltimore Data
baltimoreNEI <- NEI[NEI$fips == "24510",]

## Load Classification data for NEI$SCC data
SCC <- readRDS("Source_Classification_Code.rds")
##Focus on EI.Sectors that have Vehicles
vehicleSCC <- subset(SCC, grepl("Vehicle", EI.Sector))

##Convert year column to factor
baltimoreNEI$year <- as.factor(baltimoreNEI$year)


##merge vehicle focused SCC data with NEI data
##match on SCC column
vehicleSCCNEI <- merge(baltimoreNEI, vehicleSCC, by=c("SCC"))
##Convert type & EI.Sector to factor
vehicleSCCNEI$type <- factor(vehicleSCCNEI$type)
vehicleSCCNEI$EI.Sector <- factor(vehicleSCCNEI$EI.Sector)

##Sum Emissions By Year By EI.Sector
emissionsByYearEI.Sector <- as.data.frame(tapply(vehicleSCCNEI$Emissions, 
     INDEX=list(vehicleSCCNEI$year,vehicleSCCNEI$EI.Sector), FUN=sum))
##Add year as a column
emissionsByYearEI.Sector$year <- rownames(emissionsByYearEI.Sector)
##Melt matrix to produce long table with EI.Sector as factor
emissionsPlotEI <- melt(emissionsByYearEI.Sector, id="year")
colnames(emissionsPlotEI) <- c("year", "EI.Sector", "emission")

##Create second ggplot
p5 <- ggplot(emissionsPlotEI, aes(x=year, y=emission, group=EI.Sector,
      color=EI.Sector)) + geom_line() + 
      ggtitle ("Vehicle Emissions in Baltimore by Sector") + 
      xlab("Year") + ylab("Total Amount of PM2.5 emitted, in tons") + 
      scale_y_continuous(labels = comma)

##Use ggsave to save the plot to plot5.png
ggsave(filename="plot5.png", plot=p5, scale=1.2)