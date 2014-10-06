#' Computation of data necessary to compute the long term mean annual flows for the NAWQA Annual Reporting Website
#'
#' Computes a value to be plotted as a line on bar charts within the detailed site reports
#'
#' @param aflow is a data frame with all annual flows from all NAWQA National Fixed Site Network locations.  This data frame is requires 3 columns
#' "SITE_QW_ID", which is the USGS station ID for the location used to collect water quality samples; "WY" which is the water year in which loads are computed or flows were measured; 
#' "FLOW", which is the annual flow in acre-feet in tons
#' @param staid is a character representing the USGS station ID for the location desired for the mean annual load/flow
#' @param wybeg is a number representing  the first water year desired for the mean annual load/flow, this should be 1993
#' @param wycur is a number representing  last water year desired for the mean annual load/flow, this should be the most recent water year used in the Annual Reporting website
#' @return A numeric value to be represented as a line on the annual flow graphs on the detailed site reports portion on the NAWQA Annual Reporting website, incorrect input of values will produce a NaN value


an.flow<-function(aflow,staid,wybeg,wycur){
	return(mean(aflow[aflow$SITE_QW_ID==staid&aflow$WY %in% wybeg:(wycur-1)&!is.na(aflow$FLOW),"FLOW"]))}
