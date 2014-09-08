#' Computation of data necessary for flow exceedance plots for a given site and water year for the NAWQA Annual Reporting Website
#'
#' Computes a data frame which contains two columns necessary to plot flow exceedance;
#' "FLOW" which are daily flows ordered from the maximum to minimum values, and "EXCEED" which is the percentage of time the corresponding flow value is exceeded for a given water year 
#' To create the plot, plot the "EXCEED" column on the x axis and the "FLOW" values on the y-axis as a line
#'
#' @param q a data frame with all daily flows from all NAWQA National Fixed Site Network locations.  This data frame is requires 4 columns
#' "SITE_QW_ID", which is the USGS station ID for the location used to collect water quality samples; "FLOW", which are daily streamflow values
#' measured in cubic feet per second, and "WY" which is the water year in which flows were measured
#' @param staid is the USGS station ID for the location desired for the flow exceedance plot
#' @param wycur is the water year desired for the flow exceedance graph, this should be the most recent water year used in the Annual Reporting website
#' @return A data frame with the columns "FLOW" and "EXCEED" used for plotting flow exceedance on the NAWQA Annual Reporting website


flowexceed<-function(q,staid,wycur){
q1<-q[q$SITE_QW_ID==staid,]
q1<-q1[q1$WY==wycur,]
q1 <-q1[with(q1,order(-FLOW)),]
q1$EXCEED <-100*(1:nrow(q1))/nrow(q1)
return(q1)
}
