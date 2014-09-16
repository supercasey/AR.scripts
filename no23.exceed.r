
#' Computation of the percentage of instances in which nitrate exceeds 10 mg/L NAWQA Annual Reporting Website for the most recent water year
#'
#' Computes a value to be plotted as a bar within the site summary reports
#'
#' @param dconc is a data frame with all discrete water quality data from all NAWQA National Fixed Site Network locations.  This data frame is requires 4 columns
#' "SITE_QW_ID", which is the USGS station ID for the location used to collect water quality samples; "CONSTIT", which are abbreviations of the various water quality constituents;
#' "WY" which is the water year in which loads are computed or flows were measured; "CONCENTRATION", which is the constituent concentration in milligrams per liter
#' @param staid is a character representing the USGS station ID for the location desired 
#' @param wycur is a number representing the most recent water year with data used in the Annual Reporting website
#' @return A numeric value to be represented as a bar on the site summary reports portion on the NAWQA Annual Reporting website, incorrect input of values will produce a NaN value

no23.exceed<-function(dconc,staid,wycur){
return(100*(nrow(dconc[dconc$CONSTIT=="NO23"&dconc$SITE_QW_ID==staid&dconc$WY==wycur&dconc$CONCENTRATION>10,])/nrow(dconc[dconc$CONSTIT=="NO23"&dconc$SITE_QW_ID==staid&dconc$WY==wycur,])))
}
