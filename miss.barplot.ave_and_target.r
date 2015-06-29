# SCRIPTS MODIFIED BY CIDA TO COMPUTE BENCHMARK STATISTICS


#1. 1980-1996 Baseline average and 45 % reduction line for either monthly or annual data
#Read in annual and monthly loads data for the GULF site.
# Uncomment setwd and set to the directory containing the data files
setwd("/home/cschroed/src/nar-services-data/")

#prevent output in scientific notation
options(scipen=999)

aload<-read.table("timeSeries/data/Aloads.txt",header=TRUE,colClasses=c(rep("character",4),rep(NA,7)))
mload<-read.table("timeSeries/data/Mloads.txt",header=TRUE,colClasses=c(rep("character",4),rep(NA,6)))

site<-c("GULF")

#functions to calculate averages
annual_mean_1980_1996 <- function(const, site) {
  return(mean(aload[aload$SITE_QW_ID==site&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$WY %in% 1980:1996&!is.na(aload$TONS),"TONS"]))
}

may_mean_1980_1996 <- function(const, site) {
  return(mean(mload[mload$SITE_QW_ID==site&mload$CONSTIT==const&mload$MODTYPE!="COMP"&mload$WY %in% 1980:1996&mload$MONTH==5&!is.na(mload$TONS),"TONS"]))
}

constituents <- c("NO3_NO2", "TP", "TN")

m1 <- matrix(, nrow=length(constituents), ncol=6) 
for (j in 1:length(constituents)) {
    annual_mean <- annual_mean_1980_1996(constituents[j], site)
    may_mean <- may_mean_1980_1996(constituents[j], site)
    m1[j,] <- cbind(site, constituents[j], annual_mean, .55*annual_mean, may_mean, .55*may_mean)
}
write.table(m1, file="mean_and_targets.csv",
          sep=',',
          row.names=FALSE,
          col.names=c("site_id", "constituent", "annual_mean", "annual_target", "may_mean", "may_target"), na="null")
	
