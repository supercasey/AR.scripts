# SCRIPTS MODIFIED BY CIDA TO COMPUTE BENCHMARK STATISTICS

#2. 5 Year moving average from 1996 on based on either monthly or annual data
#Read in annual and monthly loads data
# Uncomment setwd and assign directory where data files are.
setwd("/home/cschroed/src/nar-services-data/")

#prevent output in scientific notation
options(scipen=999)

aload<-read.table("timeSeries/data/Aloads.txt",header=TRUE,colClasses=c(rep("character",4),rep(NA,7)))
mload<-read.table("timeSeries/data/Mloads.txt",header=TRUE,colClasses=c(rep("character",4),rep(NA,6)))

site<-c("GULF")

aload<-aload[order(aload$SITE_ABB,aload$CONSTIT,aload$WY),]
mload<-mload[order(mload$SITE_ABB,mload$CONSTIT,mload$WY),]

wycur <-2014

constituents <- c("NO3_NO2", "TP", "TN")

df <-data.frame(matrix(vector(), 0, 5, dimnames=list(c(), c("wy", "site_id", "constituent", "mov.ave", "month_mov.ave"))), stringsAsFactors=F)
for (j in 1:length(constituents)) {
	  #compute points for use in 5-year moving average line from 1996 to the current wy (data dont'
	  mov.ave<-as.data.frame(1993:wycur);colnames(mov.ave)<-"wy"
    mov.ave$site_id<-rep(site, wycur - 1992)
    mov.ave$constituent <- rep(constituents[j], wycur - 1992)
	  ave.dat<-aload[aload$SITE_QW_ID==site&aload$CONSTIT==constituents[j]&aload$MODTYPE!="COMP"&aload$WY > 1992&!is.na(aload$TONS),]
    if (nrow(ave.dat) > 0) {
      mov.ave$TONS <-ave.dat[match(mov.ave$wy,ave.dat$WY),"TONS"]
      mov.ave$mov.ave<-rollapply(mov.ave$TONS,5,mean,fill=NA,align="right")
    } else {
      mov.ave$TONS <- rep(NA, wycur - 1992)
      mov.ave$mov.ave <- rep(NA, wycur - 1992)
    }
     
	  #compute points for use in 5-year moving average line from 1996 to the current wy for May(data dont'
	  month_ave.dat<-mload[mload$SITE_QW_ID==site&mload$CONSTIT==constituents[j]&mload$MODTYPE!="COMP"&mload$WY > 1992&mload$MONTH==5&!is.na(mload$TONS),]
	  if (nrow(month_ave.dat) > 0) {
	    mov.ave$MONTH_TONS <-month_ave.dat[match(mov.ave$wy,month_ave.dat$WY),"TONS"]
	    mov.ave$month_mov.ave<-rollapply(mov.ave$MONTH_TONS,5,mean,fill=NA,align="right")
    } else {
      mov.ave$MONTH_TONS <- rep(NA, wycur - 1992)
      mov.ave$month_mov.ave <- rep(NA, wycur - 1992)
    }

    df <- rbind(mov.ave[c(1:3, 5, 7)], df)
}
df <- subset(df, wy>1996)

write.csv(df, file="moving_averages.csv",
            row.names=F)



