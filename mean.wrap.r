			#' Writes shapefiles computed by annualmay.meanlinemaps.r 
			#' This script depends on the presence of a user-input shapefile, "missriv" of mississippi river streams, "a.ll", a file of all annual loads in the basin, and "m.ll" a file of all monthly loads in the basin
			#' @param consts is a character vector representing  the constituents to be mapped, currently defined as NO23, TN, and TP
			#' @param wycur is a  number representing the most recent water year published on the annual reporting wiste are computed, currently 2013
			#' @param ptypes are a character vector of types of loads, currently they include "WY" or "May"
			#' @param periods represent the periods in which mean loads are to be computed over; this is indicated by the starting year in which loads are to be computed, currently either 1980 or 1993 
			#' This script writes shape files with WY and May loads for each segment for May and Annual loads, shapefiles are named by constituent and type of mean value

				consts<- c("NO3+NO2","TN","TP")
				wycur<-2014
				ptypes<- c("WY","May")
				periods<- c(1980,1993)
				
				#write annual and May shape files
				for(i in 1:length(periods)){
					for(j in 1:length(consts)){
						for (k in 1:length(ptypes)){
							period<-periods[i]
							if(i==1){wylast<-1996}else if(i==2){wylast<-wycur}
							const<-consts[j]
							p.type<-ptypes[k]
							if(k==1){
								missriv<-annualmay.meanlinemaps(missriv,a.ll,m.ll,wycur,const,p.type,period)
								names(missriv)[length(names(missriv))]<-	p.type
							}
								else if(k==2){
									missriv<-annualmay.meanlinemaps(missriv,a.ll,m.ll,wycur,const,p.type,period)
									names(missriv)[length(names(missriv))]<-	p.type
									writeSpatialShape(missriv,paste("missrivout",const,period,wylast,".shp",sep="_"))
									missriv<-missriv[,1:5]
								}
						}
					}
}

