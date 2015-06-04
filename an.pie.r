
#' Computation of data necessary to compute annual pie charts for the NAWQA Annual Reporting Mississippi River Section
#'
#' Computes a dataframe to be plotted as a pie chart within the NAWQA Annual Reporting Mississippi River Section
#' @param aload is a data frame with all annual loads and flows from all NAWQA National Fixed Site Network locations.  This data frame is requires 6 columns
#' "SITE_QW_ID", which is the USGS station ID for the location used to collect water quality samples; "CONSTIT", which are abbreviations of the various water quality constituents;
#' "MODTYPE", which are abbreviations of types of methods used to compute loads, "WY" which is the water year in which loads are computed or flows were measured; 
#' "TONS", which represent the annual water quality load, in tons; and "ANNFLOW_ACREFEET", which is the annual volume of flow, measured in acre-feet
#' @param consts is a vector of characters representing  the parameters to be computed, options (as of 2014) include TN, TP, and NO3+NO2
#' @param wys is a vectors of numbers representing the water years desired for the pie chart, generally these will be 1993 to the current water year (expressed as 1993:2014 presently)
#' @return A dataframe with five columns "Value", which is the value to be plotted in the pie chart; "Constit", the constiuent; "Ptype", which indicates the type of load (WY for water year in this case);"WY", the water year, and "Basin", the basin being plotted

an.pie<-function(aload,consts,wys){

for(i in 1:length(wys)){
	for(j in 1:length(consts)){
wycur <-wys[i]
const<-consts[j]
#Compute the total gulf load and assign it to the variable "gulfpie"
gulfpie<-aload[aload$SITE_QW_ID=="07373420"&aload$SITE_ABB=="STFR"&aload$WY==wycur&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"]+aload[aload$SITE_QW_ID=="07381495"&aload$WY==wycur&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"]
#Compute the percentage of the total load from the Red River basin and assign it to the variable "redpie"
redpie<-(aload[aload$SITE_QW_ID=="07355500"&aload$WY==wycur&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"])/gulfpie
if(length(redpie)<1){redpie<-NA}
#Compute the percentage of the total load from the Atchafalaya River basin and assign it to the variable "atchpie"
atchpie<-(gulfpie-aload[aload$SITE_ABB=="MISS"&aload$WY==wycur&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"]-redpie*gulfpie)/gulfpie

if(length(atchpie)<1){atchpie<-NA}
#Compute the percentage of the total load from the Arkansas River basin and assign it to the variable "arkpie"
arkpie<-(aload[aload$SITE_QW_ID=="07263620"&aload$WY==wycur&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"])/gulfpie
if(length(arkpie)<1){arkpie<-NA}
#Compute the percentage of the total load from the Missouri River basin and assign it to the variable "mopie"
mopie<-(aload[aload$SITE_QW_ID=="06934500"&aload$WY==wycur&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"])/gulfpie
if(length(mopie)<1){mopie<-NA}
#Compute the percentage of the total load from the Ohio River basin and assign it to the variable "ohpie"
ohpie<-(aload[aload$SITE_QW_ID=="03612500"&aload$WY==wycur&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"])/gulfpie
if(length(ohpie)<1){ohpie<-NA}
#Compute the percentage of the total load from the upper Mississippi river basin and assign it to the variable "upmisspie"
upmisspie<-(aload[aload$SITE_QW_ID=="05420500"&aload$WY==wycur&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"])/gulfpie
if(length(upmisspie)<1){upmisspie<-NA}
#Compute the percentage of the total load from the upper middle Mississippi river basin and assign it to the variable "upmidmisspie"
if(is.na(upmisspie)){upmidmisspie<-(aload[aload$SITE_QW_ID=="05587455"&aload$WY==wycur&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"])/gulfpie}else{
upmidmisspie<-(aload[aload$SITE_QW_ID=="05587455"&aload$WY==wycur&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"]-upmisspie*gulfpie)/gulfpie}
if(length(upmidmisspie)<1){upmidmisspie<-NA}
#Compute the percentage of the total load from the lower middle Mississippi river basin and assign it to the variable "lowmidmisspie"
if(is.na(upmidmisspie)){lowmidmisspie<-(aload[aload$SITE_QW_ID=="07022000"&aload$WY==wycur&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"]-mopie*gulfpie)/gulfpie}else{
lowmidmisspie<-(aload[aload$SITE_QW_ID=="07022000"&aload$WY==wycur&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"]-aload[aload$SITE_QW_ID=="05587455"&aload$WY==wycur&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"]-mopie*gulfpie)/gulfpie}
if(length(lowmidmisspie)<1){lowmidmisspie<-NA}

#Compute the percentage of the total load from the lower Mississippi river basin and assign it to the variable "lowmisspie"
lowmisspie<-(aload[aload$SITE_ABB=="MISS"&aload$WY==wycur&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"]-aload[aload$SITE_QW_ID=="07022000"&aload$WY==wycur&aload$CONSTIT==const&aload$MODTYPE %in% c("REG","REGHIST"),"TONS"]-arkpie*gulfpie-ohpie*gulfpie)/gulfpie
if(length(lowmisspie)<1){lowmisspie<-NA}

#Aggregate and name columns
if(i==1&j==1){
	an.pie1<-as.data.frame(c(redpie,atchpie,arkpie,mopie,ohpie,upmisspie,upmidmisspie,lowmidmisspie,lowmisspie))
	colnames(an.pie1)<-"Value"
	an.pie1$Constit<-consts[j]
	an.pie1$Ptype<-"WY"
	an.pie1$WY<-wycur
	an.pie1$Basin<-c("RED","ATCHAFALAYA","ARKANSAS","MISSOURI","OHIO","UPPERMISS","UPPERMIDDLEMISS","LOWERMIDDLEMISS","LOWERMISS")
} else{
	an.pie<-as.data.frame(c(redpie,atchpie,arkpie,mopie,ohpie,upmisspie,upmidmisspie,lowmidmisspie,lowmisspie))
	colnames(an.pie)<-"Value"
							an.pie$Constit<-consts[j]
							an.pie$Ptype<-"WY"
							an.pie$WY<-wycur		
	an.pie$Basin<-c("RED","ATCHAFALAYA","ARKANSAS","MISSOURI","OHIO","UPPERMISS","UPPERMIDDLEMISS","LOWERMIDDLEMISS","LOWERMISS")
	an.pie1<-rbind(an.pie1,an.pie)
}
	}
}
return(an.pie1)
}
