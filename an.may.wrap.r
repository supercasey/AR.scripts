#' Writes shapefiles computed by annualmay.linemaps.r 
#' This script depends on the presence of a user-input shapefile, "missriv" of mississippi river streams, "a.ll", a file of all annual loads in the basin, and "m.ll" a file of all monthly loads in the basin
#' @param consts is a character vector representing  the constituents to be mapped, currently defined as NO23, TN, and TP
#' @param wycur is a  number representing the most recent water year published on the annual reporting wiste are computed, currently 2013
#' @param wyears is a number vector of the years to be computed, currently from 1993 to wycur
#' @param ptypes are a character vector of types of loads, currently they include "WY" or "May"
#' @param periods represent the periods in which mean loads are to be computed over; this is indicated by the starting year in which loads are to be computed, currently either 1980 or 1993 
#' This script writes shape files with WY and May loads for each segment for all possible constituents and years, the script also computes natural jenks breaks for annual (aljenks.brks) and may (mojenks.brks)  line thickness, this is dependent on the classInt package


consts<- c("NO23","TN","TP")
wycur<-2013
wyears<- 1993:wycur
ptypes<- c("WY","May")
periods<- c(1980,1993)

#write annual and May shape files
for(i in 1:length(wyears)){
	for(j in 1:length(consts)){
		for (k in 1:length(ptypes)){
wys<-wyears[i]
const<-consts[j]
p.type<-ptypes[k]
if(k==1){
	missriv<-annualmay.linemaps(missriv,a.ll,m.ll,wys,const,p.type)
names(missriv)[length(names(missriv))]<-	p.type
if(i==1){aljenks<-missriv@data$WY}else{aljenks<-c(aljenks,missriv@data$WY)}
} else if(k==2){
missriv<-annualmay.linemaps(missriv,a.ll,m.ll,wys,const,p.type)
names(missriv)[length(names(missriv))]<-	p.type
if(i==1){mojenks<-missriv@data$May}else{mojenks<-c(mojenks,missriv@data$May)}
writeSpatialShape(missriv,paste("missrivout",const,wys,".shp",sep="_"))
missriv<-missriv[,1:5]
}
}
		}
}

library(classInt)
aljenks.brks<-classIntervals(as.numeric(quantile(aljenks,seq(.001,1,by=.001))),24,style="jenks",rtimes=1)$brks
mojenks.brks<-classIntervals(as.numeric(quantile(mojenks,seq(.001,1,by=.001))),24,style="jenks",rtimes=1)$brks

