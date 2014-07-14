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
## Load Classification data for NEI$SCC data
SCC <- readRDS("Source_Classification_Code.rds")
##Focus on EI.Sectors that have Coal and Comb for Combustion
coalSCC<-subset(SCC, grepl("Coal", EI.Sector) & grepl("Comb", EI.Sector), ignore.case=TRUE)

##Convert year column to factor
NEI$year <- as.factor(NEI$year)


##merge coal focused SCC data with NEI data
##match on SCC column
coalSCCNEI <- merge(NEI, coalSCC, by=c("SCC"))
##Convert type & EI.Sector to factor
coalSCCNEI$type <- factor(coalSCCNEI$type)
coalSCCNEI$EI.Sector <- factor(coalSCCNEI$EI.Sector)

##Sum Emissions By Year By type
emissionsByYearType <- as.data.frame(tapply(coalSCCNEI$Emissions, 
      INDEX=list(coalSCCNEI$year,coalSCCNEI$type), FUN=sum))
##Add year as a column
emissionsByYearType$year <- rownames(emissionsByYearType)
##Melt matrix to produce long table with type as factor
emissionsPlot <- melt(emissionsByYearType, id="year")
colnames(emissionsPlot) <- c("year", "type", "emission")
##Create first ggplot
p1 <- ggplot(emissionsPlot, aes(x=year, y=emission, group=type, 
      color=type)) + geom_line() + ggtitle ("Coal Combustible Emissions by Type") + 
      xlab("Year") + ylab("Total Amount of PM2.5 emitted, in tons") + 
      scale_y_continuous(labels = comma)

##Sum Emissions By Year By type
emissionsByYearEI.Sector <- as.data.frame(tapply(coalSCCNEI$Emissions, 
      INDEX=list(coalSCCNEI$year,coalSCCNEI$EI.Sector), FUN=sum))
##Add year as a column
emissionsByYearEI.Sector$year <- rownames(emissionsByYearEI.Sector)
##Melt matrix to produce long table with EI.Sector as factor
emissionsPlotEI <- melt(emissionsByYearEI.Sector, id="year")
colnames(emissionsPlotEI) <- c("year", "EI.Sector", "emission")

##Create second ggplot
p2 <- ggplot(emissionsPlotEI, aes(x=year, y=emission, group=EI.Sector,
      color=EI.Sector)) + geom_line() + 
      ggtitle ("Coal Combustible Emissions by Sector") + 
      xlab("Year") + ylab("Total Amount of PM2.5 emitted, in tons") + 
      scale_y_continuous(labels = comma)

g = arrangeGrob(p1,p2)

##Use ggsave to save the plot to plot4.png
ggsave(filename="plot4.png", plot=g, scale=2)