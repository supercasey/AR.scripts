


#' Computation of shapefile illustrating the relative contribution of Mississippi River rivers to the Gulf; for use in the NAWQA Annual Reporting Mississippi River Section
#'
#' Computes a shapefile to be displayed within the NAWQA Annual Reporting Mississippi River Section
#' @param missriv is a shapefile of Mississippi River streams read in using the "readShapeSpatial" function.  This function depends on the maptools package.
#' The missriv shapefile data requires the columns Upstream, which defines the upstream USGS station ID (or identifies it as a headwater stream); "Downstream", which identifies the downstream station ID;
#' and "TYPE", which identifies the order of subssections of streams among monitoring locations
#' @param a.ll is a data frame with all annual loads and flows from all NAWQA National Fixed Site Network locations.  This data frame is requires 6 columns
#' "SITE_QW_ID", which is the USGS station ID for the location used to collect water quality samples; "CONSTIT", which are abbreviations of the various water quality constituents;
#' "MODTYPE", which are abbreviations of types of methods used to compute loads, "WY" which is the water year in which loads are computed or flows were measured;
#' "TONS", which represent the annual water quality load, in tons; and "ANNFLOW_ACREFEET", which is the annual volume of flow, measured in acre-feet
#' @param m.ll is a data frame with all monthly loads and flows from all NAWQA National Fixed Site Network locations.  This data frame is requires 7 columns
#' "SITE_QW_ID", which is the USGS station ID for the location used to collect water quality samples; "CONSTIT", which are abbreviations of the various water quality constituents;
#' "MODTYPE", which are abbreviations of types of methods used to compute loads, "WY" which is the water year in which loads are computed or flows were measured; "MONTH", the month loads are computed;
#' "TONS", which represent the annual water quality load, in tons; and "ANNFLOW_ACREFEET", which is the annual volume of flow, measured in acre-feet
#' @param const is a character representing  the constituent to be computed, options (as of 2014) include TN, TP, and NO3_NO2
#' @param wycur is a  numbers representing the most recent water year published on the annual reporting wiste are computed
#' @param p.type represents the option to pick water year or May Loads, the two options are "WY" or "May"
#' @param period represents the period in which mean loads are to be computed over; this is indicated by the starting year in which loads are to be computed which is either 1980 or 1993 
#' @return The missriv shapefile is appended with a column entitled "load" to be used to computing line widths

annualmay.meanlinemaps <- function (missriv,a.ll,m.ll,wycur,const,p.type,period){
	missriv<-missriv[order(missriv$TYPE),]
	if(p.type=="WY"){aload<-a.ll}else if(p.type=="May"){aload<-m.ll}
	if(period==1980){wycur<-1980:1996}else if(period==1993){wycur<-1993:wycur-1}
	missriv$load <-NA
	
	#POPULATE LOADS FOR THE WHITE RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="03374100"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		whi<-mean(aload[aload$SITE_QW_ID=="03374100"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="03374100","load"]<-seq(.1,whi,length.out=nrow(missriv@data[missriv@data$Downstream=="03374100",]))
	}else{missriv@data[missriv@data$Downstream=="03374100","load"]<-.011;whi<-.011}
	
	#POPULATE LOADS FOR THE WABASH RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="03378500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		wab<-mean(aload[aload$SITE_QW_ID=="03378500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="03378500","load"]<-seq(.1,wab-whi,length.out=nrow(missriv@data[missriv@data$Downstream=="03378500",]))
		#ADD WHITE RIVER LOADS AT THE CORRECT LOCATION ON THE WABASH
		missriv@data[missriv@data$Downstream=="03378500"&missriv@data$TYPE>32,"load"]<-missriv@data[missriv@data$Downstream=="03378500"&missriv@data$TYPE>32,"load"]+whi
	}else{missriv@data[missriv@data$Downstream=="03378500","load"]<-.011;wab<-.011}
	missriv@data[missriv@data$Downstream=="03378500",]
	
	#POPULATE LOADS FOR THE TENNESSEE RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="03609750"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		ten<-mean(aload[aload$SITE_QW_ID=="03609750"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="03609750","load"]<-seq(.1,ten,length.out=nrow(missriv@data[missriv@data$Downstream=="03609750",]))
	}else{missriv@data[missriv@data$Downstream=="03609750","load"]<-.011;ten<-.011}
	
	
	#POPULATE LOADS FOR THE UPSTREAM OHIO RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="03303280"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		ohi.1<-mean(aload[aload$SITE_QW_ID=="03303280"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="03303280","load"]<-seq(.1,ohi.1,length.out=nrow(missriv@data[missriv@data$Downstream=="03303280",]))
	}else{missriv@data[missriv@data$Downstream=="03303280","load"]<-.011;ohi.1<-.011}
	missriv@data[missriv@data$Downstream=="03303280","load"]
	
	
	#POPULATE LOADS FOR THE DOWNSTREAM OHIO RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET ALL OHIO LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="03612500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		ohi.2<-mean(aload[aload$SITE_QW_ID=="03612500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="03612500","load"]<-seq(ohi.1,ohi.2-ten-wab,length.out=nrow(missriv@data[missriv@data$Downstream=="03612500",]))
		#adding wabash/white at appropriate location
		missriv@data[missriv@data$Downstream=="03612500"&missriv@data$TYPE>9,"load"]<-missriv@data[missriv@data$Downstream=="03612500"&missriv@data$TYPE>9,"load"]+wab
		#adding tennesee at appropriate location
		missriv@data[missriv@data$Downstream=="03612500"&missriv@data$TYPE>16,"load"]<-missriv@data[missriv@data$Downstream=="03612500"&missriv@data$TYPE>16,"load"]+ten
	}else{missriv@data[missriv@data$Downstream=="03612500","load"]<-.011;missriv@data[missriv@data$Downstream=="03303280","load"]<-.011;ohi.1<-.011;ohi.2<-.011}	
	
	#POPULATE LOADS FOR THE ILLINOIS BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="05586100"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		ill<-mean(aload[aload$SITE_QW_ID=="05586100"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="05586100","load"]<-seq(.1,ill,length.out=nrow(missriv@data[missriv@data$Downstream=="05586100",]))
	}else{missriv@data[missriv@data$Downstream=="05586100","load"]<-.011;ill<-.011}
	
	#POPULATE LOADS FOR THE UPSTREAM MISSISSIPPI BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="05331580"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		mis.1<-mean(aload[aload$SITE_QW_ID=="05331580"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="05331580","load"]<-seq(.1,mis.1,length.out=nrow(missriv@data[missriv@data$Downstream=="05331580",]))
	}else{missriv@data[missriv@data$Downstream=="05331580","load"]<-.011;mis.1<-.011}
	
	#POPULATE LOADS FOR THE UPSTREAM MISSISSIPPI FROM HASTINGS TO CLINTON BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="05420500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		mis.2<-mean(aload[aload$SITE_QW_ID=="05420500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="05420500","load"]<-seq(mis.1,mis.2,length.out=nrow(missriv@data[missriv@data$Downstream=="05420500",]))
	}else{missriv@data[missriv@data$Downstream=="05420500","load"]<-.011;missriv@data[missriv@data$Downstream=="05331580","load"]<-.011;mis.1<-.011;mis.2<-.011}
	
	#POPULATE LOADS FOR THE IOWA RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="05465500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		iow<-mean(aload[aload$SITE_QW_ID=="05465500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="05465500","load"]<-seq(.1,iow,length.out=nrow(missriv@data[missriv@data$Downstream=="05465500",]))
	}else{missriv@data[missriv@data$Downstream=="05465500","load"]<-.011;iow<-.011}
	
	#POPULATE LOADS FOR THE DES MOINES RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="05490500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		des<-mean(aload[aload$SITE_QW_ID=="05490500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="05490500","load"]<-seq(.1,des,length.out=nrow(missriv@data[missriv@data$Downstream=="05490500",]))
	}else{missriv@data[missriv@data$Downstream=="05490500","load"]<-.011;des<-.011}
	
	#POPULATE LOADS FOR THE UPSTREAM MISSISSIPPI FROM CLINTON TO GRAFTON BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="05587455"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		mis.3<-mean(aload[aload$SITE_QW_ID=="05587455"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="05587455","load"]<-seq(mis.2,mis.3-iow-des-ill,length.out=nrow(missriv@data[missriv@data$Downstream=="05587455",]))
		#adding iowa at appropriate location
		missriv@data[missriv@data$Downstream=="05587455"&missriv@data$TYPE>7,"load"]<-missriv@data[missriv@data$Downstream=="05587455"&missriv@data$TYPE>7,"load"]+iow
		#adding desmoines at appropriate location
		missriv@data[missriv@data$Downstream=="05587455"&missriv@data$TYPE>15,"load"]<-missriv@data[missriv@data$Downstream=="05587455"&missriv@data$TYPE>15,"load"]+des
		#adding illinois at appropriate location
		missriv@data[missriv@data$Downstream=="05587455"&missriv@data$TYPE>29,"load"]<-missriv@data[missriv@data$Downstream=="05587455"&missriv@data$TYPE>29,"load"]+ill
	}else{missriv@data[missriv@data$Downstream=="05587455","load"]<-.011;mis.3<-.011}
	
	#POPULATE LOADS FOR THE YELLOWSTONE RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="06329500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		yel<-mean(aload[aload$SITE_QW_ID=="06329500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="06329500","load"]<-seq(.1,yel,length.out=nrow(missriv@data[missriv@data$Downstream=="06329500",]))
	}else{missriv@data[missriv@data$Downstream=="06329500","load"]<-.011;yel<-.011}
	
	#POPULATE LOADS FOR THE UPSTREAM MISSOURI BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="06610000"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		mo.1<-mean(aload[aload$SITE_QW_ID=="06610000"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="06610000","load"]<-seq(.1,mo.1-yel,length.out=nrow(missriv@data[missriv@data$Downstream=="06610000",]))
		#adding yellow at appropriate location
		missriv@data[missriv@data$Downstream=="06610000"&missriv@data$TYPE>41,"load"]<-missriv@data[missriv@data$Downstream=="06610000"&missriv@data$TYPE>41,"load"]+yel
	}else{missriv@data[missriv@data$Downstream=="06610000","load"]<-.011;mo.1<-.011}
	
	#POPULATE LOADS FOR THE ELKHORN RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="06800500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		elk<-mean(aload[aload$SITE_QW_ID=="06800500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="06800500","load"]<-seq(.1,elk,length.out=nrow(missriv@data[missriv@data$Downstream=="06800500",]))
	}else{missriv@data[missriv@data$Downstream=="06800500","load"]<-.011;elk<-.011}
	
	#POPULATE LOADS FOR THE PLATTE RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="06805500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		pla<-mean(aload[aload$SITE_QW_ID=="06805500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="06805500","load"]<-seq(.1,pla-elk,length.out=nrow(missriv@data[missriv@data$Downstream=="06805500",]))
		#adding elkhorn at appropriate location
		missriv@data[missriv@data$Downstream=="06805500"&missriv@data$TYPE>48,"load"]<-missriv@data[missriv@data$Downstream=="06805500"&missriv@data$TYPE>48,"load"]+elk
	}else{missriv@data[missriv@data$Downstream=="06805500","load"]<-.011;pla<-.011}	
	
	#POPULATE LOADS FOR THE KANSAS RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="06892350"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		kan<-mean(aload[aload$SITE_QW_ID=="06892350"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="06892350","load"]<-seq(.1,kan,length.out=nrow(missriv@data[missriv@data$Downstream=="06892350",]))
	}else{missriv@data[missriv@data$Downstream=="06892350","load"]<-.011;kan<-.011}	
	
	
	#POPULATE LOADS FOR THE GRAND RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="06902000"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		grand<-mean(aload[aload$SITE_QW_ID=="06902000"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="06902000","load"]<-seq(.1,grand,length.out=nrow(missriv@data[missriv@data$Downstream=="06902000",]))
	}else{missriv@data[missriv@data$Downstream=="06902000","load"]<-.011;grand<-.011}	
	
	#POPULATE LOADS FOR THE OSAGE RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="06926510"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		osag<-mean(aload[aload$SITE_QW_ID=="06926510"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="06926510","load"]<-seq(.1,osag,length.out=nrow(missriv@data[missriv@data$Downstream=="06926510",]))
	}else{missriv@data[missriv@data$Downstream=="06926510","load"]<-.011;osag<-.011}	
	
	#POPULATE LOADS FOR THE DOWNSTREAM MISSOURI RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="06934500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		mo.2<-mean(aload[aload$SITE_QW_ID=="06934500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="06934500","load"]<-seq(mo.1,mo.2-pla-kan-grand-osag,length.out=nrow(missriv@data[missriv@data$Downstream=="06934500",]))
		#adding platte at appropriate location
		missriv@data[missriv@data$Downstream=="06934500"&missriv@data$TYPE>7,"load"]<-missriv@data[missriv@data$Downstream=="06934500"&missriv@data$TYPE>7,"load"]+pla
		#adding kansas at appropriate location
		missriv@data[missriv@data$Downstream=="06934500"&missriv@data$TYPE>15,"load"]<-missriv@data[missriv@data$Downstream=="06934500"&missriv@data$TYPE>15,"load"]+kan
		#adding kansas at appropriate location
		missriv@data[missriv@data$Downstream=="06934500"&missriv@data$TYPE>25,"load"]<-missriv@data[missriv@data$Downstream=="06934500"&missriv@data$TYPE>25,"load"]+grand
		#adding kansas at appropriate location
		missriv@data[missriv@data$Downstream=="06934500"&missriv@data$TYPE>32,"load"]<-missriv@data[missriv@data$Downstream=="06934500"&missriv@data$TYPE>32,"load"]+osag
	}else{missriv@data[missriv@data$Downstream=="06934500","load"]<-.011;missriv@data[missriv@data$Downstream=="06610000","load"]<-.011;mo.1<-.011;mo.2<-.011}		
	
	
	#POPULATE LOADS FOR THE LITTLE ARKANSAS RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="07144100"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		lark<-mean(aload[aload$SITE_QW_ID=="07144100"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="07144100","load"]<-seq(.1,lark,length.out=nrow(missriv@data[missriv@data$Downstream=="07144100",]))
	}else{missriv@data[missriv@data$Downstream=="07144100","load"]<-.011;lark<-.011}	
	
	
	#POPULATE LOADS FOR THE DOWNSTREAM MISSOURI RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="06934500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		mo.2<-mean(aload[aload$SITE_QW_ID=="06934500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="06934500","load"]<-seq(mo.1,mo.2-pla-kan,length.out=nrow(missriv@data[missriv@data$Downstream=="06934500",]))
		#adding platte at appropriate location
		missriv@data[missriv@data$Downstream=="06934500"&missriv@data$TYPE>7,"load"]<-missriv@data[missriv@data$Downstream=="06934500"&missriv@data$TYPE>7,"load"]+pla
		#adding kansas at appropriate location
		missriv@data[missriv@data$Downstream=="06934500"&missriv@data$TYPE>15,"load"]<-missriv@data[missriv@data$Downstream=="06934500"&missriv@data$TYPE>15,"load"]+kan
	}else{missriv@data[missriv@data$Downstream=="06934500","load"]<-.011;missriv@data[missriv@data$Downstream=="06610000","load"]<-.011;mo.1<-.011;mo.2<-.011}		
	
	#POPULATE LOADS FOR THE MISSISSIPPI RIVER FROM GRAFTON TO THEBES BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="07022000"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		mis.4<-mean(aload[aload$SITE_QW_ID=="07022000"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="07022000","load"]<-seq(mis.3,mis.4-mo.2,length.out=nrow(missriv@data[missriv@data$Downstream=="07022000",]))
		#adding missouri at appropriate location
		missriv@data[missriv@data$Downstream=="07022000"&missriv@data$TYPE>0,"load"]<-missriv@data[missriv@data$Downstream=="07022000"&missriv@data$TYPE>0,"load"]+mo.2
	}else{missriv@data[missriv@data$Downstream=="07022000","load"]<-.011;mis.4<-.01}	
	
	#POPULATE LOADS FOR THE NORTH CANADIAN RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="07241550"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		nca<-mean(aload[aload$SITE_QW_ID=="07241550"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="07241550","load"]<-seq(.1,nca,length.out=nrow(missriv@data[missriv@data$Downstream=="07241550",]))
	}else{missriv@data[missriv@data$Downstream=="07241550","load"]<-.011;nca<-.011}	
	
	#POPULATE LOADS FOR THE ARKANSAS RIVER BASED ON LINEAR INTERPOLATION, IF NO DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="07263620"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		ark<-mean(aload[aload$SITE_QW_ID=="07263620"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="07263620","load"]<-seq(.1,ark-nca,length.out=nrow(missriv@data[missriv@data$Downstream=="07263620",]))
		#adding north canadian at appropriate location
		missriv@data[missriv@data$Downstream=="07263620"&missriv@data$TYPE>43,"load"]<-missriv@data[missriv@data$Downstream=="07263620"&missriv@data$TYPE>43,"load"]+nca
	}else{missriv@data[missriv@data$Downstream=="07263620","load"]<-.011;ark<-.011}	
	
	#POPULATE LOADS FOR THE MISSISSIPPI FROM THEBES TO VICKSBURG BASED ON LINEAR INTERPOLATION, IF NOT DATA, INTERPOLATE BASED ON DATA ABOVE THE OLD RIVER OUTFLOW DIVERSION
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="322023090544500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		mis.5<-mean(aload[aload$SITE_QW_ID=="322023090544500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="322023090544500","load"]<-seq(mis.4,mis.5-ohi.2-ark,length.out=nrow(missriv@data[missriv@data$Downstream=="322023090544500",]))
		#adding ohio at appropriate location
		missriv@data[missriv@data$Downstream=="322023090544500"&missriv@data$TYPE>3,"load"]<-missriv@data[missriv@data$Downstream=="322023090544500"&missriv@data$TYPE>3,"load"]+ohi.2
		#adding ark at appropriate location
		missriv@data[missriv@data$Downstream=="322023090544500"&missriv@data$TYPE>30,"load"]<-missriv@data[missriv@data$Downstream=="322023090544500"&missriv@data$TYPE>30,"load"]+ark
	}else{mis.5.1<-mean(aload[aload$SITE_ABB=="MISS"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])-((mean(aload[aload$SITE_ABB=="MISS"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])-mis.4-ohi.2-ark)*.2)
							missriv@data[missriv@data$Downstream=="322023090544500","load"]<-seq(mis.4,mis.5.1-ohi.2-ark,length.out=nrow(missriv@data[missriv@data$Downstream=="322023090544500",]))
							#adding ohio at appropriate location
							missriv@data[missriv@data$Downstream=="322023090544500"&missriv@data$TYPE>3,"load"]<-missriv@data[missriv@data$Downstream=="322023090544500"&missriv@data$TYPE>3,"load"]+ohi.2
							#adding ark at appropriate location
							missriv@data[missriv@data$Downstream=="322023090544500"&missriv@data$TYPE>30,"load"]<-missriv@data[missriv@data$Downstream=="322023090544500"&missriv@data$TYPE>30,"load"]+ark}	
	
	#POPULATE LOADS FOR THE YAZOO RIVER ON LINEAR INTERPOLATION, IF NOT DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="07288955"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		yaz<-mean(aload[aload$SITE_QW_ID=="07288955"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="07288955","load"]<-seq(.1,yaz,length.out=nrow(missriv@data[missriv@data$Downstream=="07288955",]))
	}else{missriv@data[missriv@data$Downstream=="07288955","load"]<-.011;yaz<-.011}	
	
	#POPULATE LOADS FOR THE RED ROVER BASED ON LINEAR INTERPOLATION, IF NOT DATA, SET LOADS TO .011
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="07355500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		red<-mean(aload[aload$SITE_QW_ID=="07355500"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="07355500","load"]<-seq(.1,red,length.out=nrow(missriv@data[missriv@data$Downstream=="07355500",]))
	}else{missriv@data[missriv@data$Downstream=="07355500","load"]<-.011;red<-.011}	
	
	#POPULATE LOADS FOR THE MISSISSIPPI RIVER FROM VICKSBURG TO THE OLD RIVER OUTFLOW BASED ON LINEAR INTERPOLATION, IF NOT DATA, SET LOADS TO .011 (THESE DATA SHOULD ALWAYS BE PRESENT)
	if(!is.nan(mean(aload[aload$SITE_ABB=="MISS"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		mis.5.1<-mean(aload[aload$SITE_ABB=="MISS"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="07373420",][1:7,"load"]<-seq(missriv@data[missriv@data$Downstream=="322023090544500","load"][40]+yaz,mis.5.1+yaz,length.out=7)
	}else{missriv@data[missriv@data$Downstream=="07373420",][1:7,"load"]<-.011}
	
	#POPULATE LOADS FOR THE MISSISSIPPI FROM THE OLD RIVER OUTFLOW TO ST FRANCISVILLE USING ST. FRANCISVILLE LOADS (THESE DATA WILL ALWAYS BE PRESENT)
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="07373420"&aload$SITE_ABB=="STFR"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		mis.6<-mean(aload[aload$SITE_QW_ID=="07373420"&aload$SITE_ABB=="STFR"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="07373420",][8:10,"load"]<-rep(mis.6,3)
	}else{missriv@data[missriv@data$Downstream=="07373420",][8:10,"load"]<-.011}
	
	#POPULATE LOADS FOR THE MISSISSIPPI FROM ST. FRANCISVILLE TO BATON ROUGE, IF NO BATON ROUGE DATA USE ST. FRANCISVILLE
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="07374000"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		mis.7<-mean(aload[aload$SITE_QW_ID=="07374000"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="07374000","load"]<-seq(mis.6,mis.7,length.out=nrow(missriv@data[missriv@data$Downstream=="07374000",]))
	}else{missriv@data[missriv@data$Downstream=="07374000","load"]<-mis.6;mis.7<-mis.6}	
	
	#POPULATE LOADS FOR THE MISSISSIPPI FROM BATON ROUGE TO BELLE CHASE, IF NO BELLE CHASE DATA USE BATON ROUGE OR ST. FRANCISVILLE BASED ON AVAILABILITY
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="07374525"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		mis.8<-mean(aload[aload$SITE_QW_ID=="07374525"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="07374525","load"]<-seq(mis.7,mis.8,length.out=nrow(missriv@data[missriv@data$Downstream=="07374525",]))
	}else{missriv@data[missriv@data$Downstream=="07374525","load"]<-mis.7;mis.8<-mis.7}	
	
	#POPULATE LOADS FOR THE MISSISSIPPI FROM BELLE CHASE TO THE GULF, IF NO DATA USE NEXT UPSTREAM STATION
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="07374525"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		mis.9<-mean(aload[aload$SITE_QW_ID=="07374525"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Upstream=="07374525","load"]<-mis.9
	}else{missriv@data[missriv@data$Upstream=="07374525","load"]<-mis.8;mis.9<-mis.8}	
	
	#POPULATE LOADS FOR THE OLD RIVER OUTFLOW DIVERSION BASED ON DIFFERENCE BETWEEN LOADS UP AND DOWNSTREAM FROM THE DIVERSION
	if(length(!is.nan(c(mean(aload[aload$SITE_ABB=="MISS"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]),mean(aload[aload$SITE_QW_ID=="07373420"&aload$SITE_ABB=="STFR"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))))==2){
		missriv@data[missriv@data$Downstream=="07381495","load"]<-mean(aload[aload$SITE_ABB=="MISS"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])-mean(aload[aload$SITE_QW_ID=="07373420"&aload$SITE_ABB=="STFR"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
	}else{missriv@data[missriv@data$Downstream=="07381495","load"]<-.011}
	
	
	#POPULATE LOADS FOR THE ATCHAFALAYA FROM THE DIVERSION TO WAX LAKE BASED ON DATA FROM THE MELVILLE STATION
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="07381495"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		atc.1<-mean(aload[aload$SITE_QW_ID=="07381495"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Downstream=="07381600","load"]<-atc.1
	}else{missriv@data[missriv@data$Downstream=="07381600","load"]<-.011}
	
	#POPULATE LOADS FROM WAX LAKE TO THE GULF, IF NO LOADS POPULATE TO .011 (SUGGEST NOT SHOWING THIS SEGMENT IF LOADS AREN'T AVAILABLE)
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="07381590"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		wax<-mean(aload[aload$SITE_QW_ID=="07381590"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Upstream=="07381590","load"]<-wax
	}else{missriv@data[missriv@data$Upstream=="07381590","load"]<-.011}
	
	#POPULATE LOADS FROM THE DOWNSTREAM ATCHAFALAYA TO THE GULF, IF NO LOADS POPULATE TO .011 (SUGGEST NOT SHOWING THIS SEGMENT IF LOADS AREN'T AVAILABLE)
	if(!is.nan(mean(aload[aload$SITE_QW_ID=="07381600"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"]))){
		atc2<-mean(aload[aload$SITE_QW_ID=="07381600"&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$MODTYPE!="CONTIN"&aload$WY%in%wycur,"TONS"])
		missriv@data[missriv@data$Upstream=="07381600","load"]<-atc2
	}else{missriv@data[missriv@data$Upstream=="07381600","load"]<-.011}
	
	return(missriv)
}
