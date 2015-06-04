
#' Computation of data required to produce a lowess line for discrete sample plots on the Detailed site reports portion of the Annual reporting website
#'
#' Computes a data frame which contains two columns necessary to plot loess values;
#' "DEC_DATE", which is the x-axis of the plot and "low.plot", which are the values to be plotted on the y-axis. This script depends on the lubridate package
#'
#' @param dconc is a data frame with all discrete water quality data from all NAWQA National Fixed Site Network locations.  This data frame is requires 6 columns
#' "SITE_QW_ID", which is the USGS station ID for the location used to collect water quality samples; "CONSTIT", which are abbreviations of the various water quality constituents;
#' "DATE", which is the date the sample was collected; "WY" which is the water year in which loads are computed or flows were measured; 
#' "CONCENTRATION", which is the constituent concentration in milligrams per liter; and "REMARK" which is the remark that pertains to the concentration value
#' @param staid is a character representing the USGS station ID for the location desired 
#' @param const is a character representing  the parameter to be computed, options (as of 2014) include TN, TP, NO3+NO2, SSC, and FLOW
#' @param wybeg is a number representing the first water year with data used in the Annual Reporting website, this will likely be 1993
#' @param wycur is a number representing the most recent water year with data used in the Annual Reporting website
#' @return A data frame with two values; "DEC_DATE", which is the x-axis of the plot and "low.plot", which are the values to be plotted on the y-axis

ar.lowess<-function(dconc,const,staid,wybeg,wycur){
library(lubridate)
 #First create a temporary dataframe for the specified years
temp.file<-dconc[dconc$CONSTIT==const&dconc$SITE_QW_ID==staid&dconc$WY%in% wybeg:wycur,]
#Create a decimal date for developing the lowess fit, this function relies upon the "lubridate" package
temp.file$DEC_DATE<-round(decimal_date(temp.file$DATE),2)
# Assign lowess fit to an object
low.fit<-loess(temp.file$CONCENTRATION~temp.file$DEC_DATE,span=.4)
# Create a daily time-series data frame from the start to the end of the period for application of the lowess fit
temp.fit<-as.data.frame(seq(as.Date(paste((wybeg-1),"-10-01",sep="")),as.Date(paste(wycur,"-09-30",sep="")),by="day"));colnames(temp.fit)<-"DATE"
#Compute water year from the date series
tmp <- as.POSIXlt(temp.fit$DATE)$year+1900
temp.fit$WY <- ifelse( format(temp.fit$DATE,'%b') %in% c('Oct','Nov','Dec'), tmp+1, tmp)
#Get decimal date from date
temp.fit$DEC_DATE <-decimal_date(temp.fit$DATE)
#Predict lowess fit from daily time series
temp.fit$low.fit<-predict(low.fit,temp.fit$DEC_DATE)
#For lowess plots, the line is only plotted if there are 4 or more samples per year, and if less than 25% of those samples are censored
 #Create a dataframe with the number of total and censored samples per year and restrict it to only those WYs with 4 or more samples and with <25% censored values
nsamp<-as.data.frame(table(temp.file[,"WY"]))
colnames(nsamp)<-c("WY","N")
nsampc<-as.data.frame(table(temp.file[temp.file$REMARK %in% "<","WY"]))
colnames(nsampc)<-c("WY","Nc")
nsamp$Nc<-nsampc[match(nsamp$WY,nsampc$WY),"Nc"]
nsamp[is.na(nsamp$Nc),"Nc"]<-0	
nsamp$perc.c<-100*nsamp$Nc/nsamp$N
nsamp<-	nsamp[nsamp$N>3&nsamp$perc.c<25,]
#Create a blank lowess plotting field
temp.fit$low.plot<-NA
#Assign the existing lowess fit to the plotting field if values are in Water years with more than 4 samples and less than 25% censored samples (as defined previously in nsamp)
temp.fit[temp.fit$WY %in% nsamp$WY,"low.plot"]<-	temp.fit[temp.fit$WY %in% nsamp$WY,"low.fit"]
return(temp.fit[,c("DEC_DATE","low.plot")])
}
