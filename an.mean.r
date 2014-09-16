#' Computation of data necessary to compute the long term mean for loads and annual flows for the NAWQA Annual Reporting Website
#'
#' Computes a value to be plotted as a line on bar charts within the detailed site reports
#'
#' @param aload is a data frame with all annual loads and flows from all NAWQA National Fixed Site Network locations.  This data frame is requires 6 columns
#' "SITE_QW_ID", which is the USGS station ID for the location used to collect water quality samples; "CONSTIT", which are abbreviations of the various water quality constituents;
#' MODTYPE, which are abbreviations of types of methods used to compute loads, "WY" which is the water year in which loads are computed or flows were measured; 
#' "TONS", which represent the annual water quality load, in tons; and "ANNFLOW_ACREFEET", which is the annual volume of flow, measured in acre-feet
#' @param staid is a character representing the USGS station ID for the location desired for the mean annual load/flow
#' @param const is a character representing  the parameter to be computed, options (as of 2014) include TN, TP, NO23, SSC, and FLOW
#' @param wybeg is a number representing  the first water year desired for the mean annual load/flow, this should be 1993
#' @param wycur is a number representing  last water year desired for the mean annual load/flow, this should be the most recent water year used in the Annual Reporting website
#' @return A numeric value to be represented as a line on the detailed site reports portion on the NAWQA Annual Reporting website, incorrect input of values will produce a NaN value



an.mean<-function(aload,staid,const,wybeg,wycur){
	if(const!="FLOW"){return(mean(aload[aload$SITE_QW_ID==staid&aload$CONSTIT==const&aload$MODTYPE!="COMP"&aload$WY %in% wybeg:(wycur-1)&!is.na(aload$TONS),"TONS"]))}
	else if(const=="FLOW"){
	return(mean(aload[aload$SITE_QW_ID==staid&aload$WY %in% wybeg:(wycur-1)&!is.na(aload$ANNFLOW_ACREFEET)&aload$CONSTIT=="FLOW","ANNFLOW_ACREFEET"]))}
}
