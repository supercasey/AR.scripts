
#' Computation of data necessary to compute mean annual and mean May pie charts for the NAWQA Annual Reporting Mississippi River Section
#'
#' Computes a dataframe to be plotted as a pie chart within the NAWQA Annual Reporting Mississippi River Section
#' @param a.ll is a data frame with all annual loads and flows from all NAWQA National Fixed Site Network locations.  This data frame is requires 6 columns
#' "SITE_QW_ID", which is the USGS station ID for the location used to collect water quality samples; "CONSTIT", which are abbreviations of the various water quality constituents;
#' "MODTYPE", which are abbreviations of types of methods used to compute loads, "WY" which is the water year in which loads are computed or flows were measured;
#' "TONS", which represent the annual water quality load, in tons; and "ANNFLOW_ACREFEET", which is the annual volume of flow, measured in acre-feet
#' @param m.ll is a data frame with all monthly loads and flows from all NAWQA National Fixed Site Network locations.  This data frame is requires 7 columns
#' "SITE_QW_ID", which is the USGS station ID for the location used to collect water quality samples; "CONSTIT", which are abbreviations of the various water quality constituents;
#' "MODTYPE", which are abbreviations of types of methods used to compute loads, "WY" which is the water year in which loads are computed or flows were measured; "MONTH", the month loads are computed;
#' "TONS", which represent the annual water quality load, in tons; and "ANNFLOW_ACREFEET", which is the annual volume of flow, measured in acre-feet
#' @param consts is a vector of characters representing  the parameters to be computed, options (as of 2014) include TN, TP, and NO23
#' @param wys is a vector of numbers representing the water years desired for one of the mean computations the pie chart, generally this will be 1993 to the current water year (expressed as 1993:2013 presently)
#' @return A dataframe with four columns "Value", which is the value to be plotted in the pie chart; "Constit", the constiuent; "Ptype", which indicates the type of load (WY for WY and May for May in this case); "WY", which indicate the water years over which the mean is computed; and "Basin", the basin being plotted

mean.pie<-function(a.ll,m.ll,consts,wys){
	m.ll<-m.ll[m.ll$MONTH==5,]
	mean.type<-as.data.frame(wys)
	mean.type$p2<-c(1980:1996,rep(NA,(length(wys)-17)))
	p.type<-c("WY","May")
	for(i in 1:ncol(mean.type)){
	for(j in 1:length(consts)){
		for(k in 1:length(p.type)){
		wys <-mean.type[,i]
		wys<-wys[!is.na(wys)]
		#This example omputes nitrate+nitrite pie charts for 2013 in the Mississippi River basin by setting the variable "const" to NO23. For TN and TP you would set the "const" variable to "TN" or "TP".  For a different year you would adjust the "wycur" variable.
		const<-consts[j]
		if(p.type[k]=="WY"){aload<-a.ll}else if(p.type[k]=="May"){aload<-m.ll}
		if(i==1){mlab<-paste(min(wys),max(wys),sep="_")}else if(i==2){mlab<-"1980_1996"}
#Compute the total gulf load and assign it to the variable "gulfpie"
gulfpie<-mean(aload[aload$SITE_QW_ID=="07373420"&aload$SITE_ABB=="STFR"&aload$WY %in%wys&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"])+mean(aload[aload$SITE_QW_ID=="07381495"&aload$WY %in%wys&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"])
#Compute the percentage of the total load from the Red River basin and assign it to the variable "redpie"
redpie<-(mean(aload[aload$SITE_QW_ID=="07355500"&aload$WY %in%wys&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"]))/gulfpie
#Compute the percentage of the total load from the Atchafalaya River basin and assign it to the variable "atchpie"
atchpie<-(mean(gulfpie-aload[aload$SITE_ABB=="MISS"&aload$WY %in%wys&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"])-redpie*gulfpie)/gulfpie
#Compute the percentage of the total load from the Arkansas River basin and assign it to the variable "arkpie"
arkpie<-(mean(aload[aload$SITE_QW_ID=="07263620"&aload$WY %in%wys&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"]))/gulfpie
#Compute the percentage of the total load from the Missouri River basin and assign it to the variable "mopie"
mopie<-(mean(aload[aload$SITE_QW_ID=="06934500"&aload$WY %in%wys&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"]))/gulfpie
#Compute the percentage of the total load from the Ohio River basin and assign it to the variable "ohpie"
ohpie<-(mean(aload[aload$SITE_QW_ID=="03612500"&aload$WY %in%wys&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"]))/gulfpie
#Compute the percentage of the total load from the upper Mississippi river basin and assign it to the variable "upmisspie"
upmisspie<-(mean(aload[aload$SITE_QW_ID=="05420500"&aload$WY %in%wys&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"]))/gulfpie
#Compute the percentage of the total load from the upper middle Mississippi river basin and assign it to the variable "upmidmisspie"
upmidmisspie<-(mean(aload[aload$SITE_QW_ID=="05587455"&aload$WY %in%wys&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"])-upmisspie*gulfpie)/gulfpie
#Compute the percentage of the total load from the lower middle Mississippi river basin and assign it to the variable "lowmidmisspie"
lowmidmisspie<-(mean(aload[aload$SITE_QW_ID=="07022000"&aload$WY %in%wys&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"])-mean(aload[aload$SITE_QW_ID=="05587455"&aload$WY %in%wys&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"])-mopie*gulfpie)/gulfpie
#Compute the percentage of the total load from the lower Mississippi river basin and assign it to the variable "lowmisspie"
lowmisspie<-(mean(aload[aload$SITE_ABB=="MISS"&aload$WY %in%wys&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"])-mean(aload[aload$SITE_QW_ID=="07022000"&aload$WY %in%wys&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"])-arkpie*gulfpie-ohpie*gulfpie)/gulfpie

if(i==1&j==1&k==1){mean.pie1<-as.data.frame(c(redpie,atchpie,arkpie,mopie,ohpie,upmisspie,upmidmisspie,lowmidmisspie,lowmisspie))
														colnames(mean.pie1)<-"Value"
														mean.pie1$Constit<-consts[j]
														mean.pie1$Ptype<-p.type[k]
														mean.pie1$WY<-mlab		
														mean.pie1$Basin<-c("RED","ATCHAFALAYA","ARKANSAS","MISSOURI","OHIO","UPPERMISS","UPPERMIDDLEMISS","LOWERMIDDLEMISS","LOWERMISS")
												
														} else{mean.pie<-as.data.frame(c(redpie,atchpie,arkpie,mopie,ohpie,upmisspie,upmidmisspie,lowmidmisspie,lowmisspie))
													colnames(mean.pie)<-"Value"
													mean.pie$Constit<-consts[j]
													mean.pie$Ptype<-p.type[k]
													mean.pie$WY<-mlab		
													mean.pie$Basin<-c("RED","ATCHAFALAYA","ARKANSAS","MISSOURI","OHIO","UPPERMISS","UPPERMIDDLEMISS","LOWERMIDDLEMISS","LOWERMISS")
														mean.pie1<-rbind(mean.pie1,mean.pie)
														}
}
}
}
return(mean.pie1)
}
