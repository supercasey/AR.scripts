

#' Computation of data necessary to compute monthly pie charts for the NAWQA Annual Reporting Mississippi River Section
#'
#' Computes a dataframe to be plotted as a pie chart within the NAWQA Annual Reporting Mississippi River Section
#' @param mload is a data frame with all monthly loads and flows from all NAWQA National Fixed Site Network locations.  This data frame is requires 7 columns
#' "SITE_QW_ID", which is the USGS station ID for the location used to collect water quality samples; "CONSTIT", which are abbreviations of the various water quality constituents;
#' "MODTYPE", which are abbreviations of types of methods used to compute loads, "WY" which is the water year in which loads are computed or flows were measured; "MONTH", the month loads are computed;
#' "TONS", which represent the annual water quality load, in tons; and "ANNFLOW_ACREFEET", which is the annual volume of flow, measured in acre-feet
#' @param consts is a vector of characters representing  the parameters to be computed, options (as of 2014) include TN, TP, and NO23
#' @param wys is a vector of numbers representing the water years desired for the pie chart, generally these will be 1993 to the current water year (expressed as 1993:2013 presently)
#' @return A dataframe with four columns "Value", which is the value to be plotted in the pie chart; "Constit", the constiuent; "Ptype", which indicates the type of load (May for May in this case); "WY", the water year, and "Basin", the basin being plotted

mo.pie<-function(mload,consts,wys){
	mnth <-"5"
for(i in 1:length(wys)){
	for(j in 1:length(consts)){
		wycur <-wys[i]
		#This example computes nitrate+nitrite pie charts for 2013 in the Mississippi River basin by setting the variable "const" to NO23. For TN and TP you would set the "const" variable to "TN" or "TP".  For a different year you would adjust the "wycur" variable.
		const<-consts[j]
#Compute the monthly gulf load and assign it to the variable "mgulfpie"
mgulfpie<-mload[mload$SITE_QW_ID=="07373420"&mload$MONTH==mnth&mload$SITE_ABB=="STFR"&mload$WY==wycur&mload$CONSTIT==const&mload$MODTYPE %in% c("REG","REGHIST"),"TONS"]+mload[mload$SITE_QW_ID=="07381495"&mload$MONTH==mnth&mload$WY==wycur&mload$CONSTIT==const&mload$MODTYPE %in% c("REG","REGHIST"),"TONS"]

#Compute the percentage of the total load from the Red River basin and assign it to the variable "mredpie"
mredpie<-(mload[mload$SITE_QW_ID=="07355500"&mload$MONTH==mnth&mload$WY==wycur&mload$CONSTIT==const&mload$MODTYPE %in% c("REG","REGHIST"),"TONS"])/mgulfpie
if(length(mredpie)<1){mredpie<-NA}

#Compute the percentage of the total load from the Atchafalaya River basin and assign it to the variable "matchpie"
matchpie<-(mgulfpie-mload[mload$SITE_QW_ID=="07373420"&mload$MONTH==mnth&mload$SITE_ABB=="MISS"&mload$WY==wycur&mload$CONSTIT==const&mload$MODTYPE %in% c("REG","REGHIST"),"TONS"]-mredpie*mgulfpie)/mgulfpie
if(length(matchpie)<1){matchpie<-NA}

#Compute the percentage of the total load from the Arkansas River basin and assign it to the variable "markpie"
markpie<-(mload[mload$SITE_QW_ID=="07263620"&mload$MONTH==mnth&mload$WY==wycur&mload$CONSTIT==const&mload$MODTYPE %in% c("REG","REGHIST"),"TONS"])/mgulfpie
if(length(markpie)<1){markpie<-NA}

#Compute the percentage of the total load from the Missouri River basin and assign it to the variable "mmopie"
mmopie<-(mload[mload$SITE_QW_ID=="06934500"&mload$MONTH==mnth&mload$WY==wycur&mload$CONSTIT==const&mload$MODTYPE %in% c("REG","REGHIST"),"TONS"])/mgulfpie
if(length(mmopie)<1){mmopie<-NA}

#Compute the percentage of the total load from the Ohio River basin and assign it to the variable "mohpie"
mohpie<-(mload[mload$SITE_QW_ID=="03612500"&mload$MONTH==mnth&mload$WY==wycur&mload$CONSTIT==const&mload$MODTYPE %in% c("REG","REGHIST"),"TONS"])/mgulfpie
if(length(mohpie)<1){mohpie<-NA}

#Compute the percentage of the total load from the upper Mississippi river basin and assign it to the variable "mupmisspie"
mupmisspie<-(mload[mload$SITE_QW_ID=="05420500"&mload$MONTH==mnth&mload$WY==wycur&mload$CONSTIT==const&mload$MODTYPE %in% c("REG","REGHIST"),"TONS"])/mgulfpie
if(length(mupmisspie)<1){mupmisspie<-NA}

#Compute the percentage of the total load from the upper middle Mississippi river basin and assign it to the variable "mupmidmisspie"
if(is.na(mupmisspie)){mupmidmisspie<-(mload[mload$SITE_QW_ID=="05587455"&mload$MONTH==mnth&mload$WY==wycur&mload$CONSTIT==const&mload$MODTYPE %in% c("REG","REGHIST"),"TONS"])/mgulfpie}else{
mupmidmisspie<-(mload[mload$SITE_QW_ID=="05587455"&mload$MONTH==mnth&mload$WY==wycur&mload$CONSTIT==const&mload$MODTYPE %in% c("REG","REGHIST"),"TONS"]-mupmisspie*mgulfpie)/mgulfpie}
if(length(mupmidmisspie)<1){mupmidmisspie<-NA}

#Compute the percentage of the total load from the lower middle Mississippi river basin and assign it to the variable "mlowmidmisspie"
if(is.na(mupmidmisspie)){mlowmidmisspie<-(mload[mload$SITE_QW_ID=="07022000"&mload$MONTH==mnth&mload$WY==wycur&mload$CONSTIT==const&mload$MODTYPE %in% c("REG","REGHIST"),"TONS"]-mmopie*mgulfpie)/mgulfpie}else{
mlowmidmisspie<-(mload[mload$SITE_QW_ID=="07022000"&mload$MONTH==mnth&mload$WY==wycur&mload$CONSTIT==const&mload$MODTYPE %in% c("REG","REGHIST"),"TONS"]-mload[mload$SITE_QW_ID=="05587455"&mload$MONTH==mnth&mload$WY==wycur&mload$CONSTIT==const&mload$MODTYPE %in% c("REG","REGHIST"),"TONS"]-mmopie*mgulfpie)/mgulfpie}
if(length(mlowmidmisspie)<1){mlowmidmisspie<-NA}

#Compute the percentage of the total load from the lower Mississippi river basin and assign it to the variable "mlowmisspie"
mlowmisspie<-(mload[mload$SITE_QW_ID=="07373420"&mload$MONTH==mnth&mload$SITE_ABB=="MISS"&mload$WY==wycur&mload$CONSTIT==const&mload$MODTYPE %in% c("REG","REGHIST"),"TONS"]-mload[mload$SITE_QW_ID=="07022000"&mload$MONTH==mnth&mload$WY==wycur&mload$CONSTIT==const&mload$MODTYPE %in% c("REG","REGHIST"),"TONS"]-markpie*mgulfpie-mohpie*mgulfpie)/mgulfpie
if(length(mlowmidmisspie)<1){mlowmidmisspie<-NA}

#Aggregate and name columns
if(i==1&j==1){
	mo.pie1<-as.data.frame(c(mredpie,matchpie,markpie,mmopie,mohpie,mupmisspie,mupmidmisspie,mlowmidmisspie,mlowmisspie))
	colnames(mo.pie1)<-"Value"
	mo.pie1$Constit<-consts[j]
	mo.pie1$Ptype<-"May"
	mo.pie1$WY<-wycur
	mo.pie1$Basin<-c("RED","ATCHAFALAYA","ARKANSAS","MISSOURI","OHIO","UPPERMISS","UPPERMIDDLEMISS","LOWERMIDDLEMISS","LOWERMISS")
} else{
	mo.pie<-as.data.frame(c(mredpie,matchpie,markpie,mmopie,mohpie,mupmisspie,mupmidmisspie,mlowmidmisspie,mlowmisspie))
	colnames(mo.pie)<-"Value"
	mo.pie$Constit<-consts[j]
	mo.pie$Ptype<-"May"
	mo.pie$WY<-wycur		
	mo.pie$Basin<-c("RED","ATCHAFALAYA","ARKANSAS","MISSOURI","OHIO","UPPERMISS","UPPERMIDDLEMISS","LOWERMIDDLEMISS","LOWERMISS")
	mo.pie1<-rbind(mo.pie1,mo.pie)
}
	}
}
return(mo.pie1)
}
