#' Writes annual and May slds for all constituents based  on annual and monthly load data
#' This script depends on the presence of a user-input sld file, annual and monthly load data, a user-defined set of nutrient abbreviations for which to compute the files, and set of periods (Annual or May)
#' @param slds is a user input sld file identical in format to the NO3_NO2_wy example provided to Casey via email November 2014, this file should be inputby the user  using the following command: slds<-scan("filename",what="",sep="\n")
#' @param consts is a character vector representing  the constituents to be mapped, currently defined as NO3_NO2, TN, and TP
#' @param ptypes are a character vector of types of loads, currently they include "WY" or "May"
#' @param a.ll is a data frame with all annual loads and flows from all NAWQA National Fixed Site Network locations.  This data frame is requires 6 columns
#' "SITE_QW_ID", which is the USGS station ID for the location used to collect water quality samples; "CONSTIT", which are abbreviations of the various water quality constituents;
#' "MODTYPE", which are abbreviations of types of methods used to compute loads, "WY" which is the water year in which loads are computed or flows were measured;
#' "TONS", which represent the annual water quality load, in tons
#' @param m.ll is a data frame with all monthly loads from all NAWQA National Fixed Site Network locations.  This data frame is requires 7 columns
#' "SITE_QW_ID", which is the USGS station ID for the location used to collect water quality samples; "CONSTIT", which are abbreviations of the various water quality constituents;
#' "MODTYPE", which are abbreviations of types of methods used to compute loads, "WY" which is the water year in which loads are computed or flows were measured; "MONTH", the month loads are computed;

#' This script writes sld fileswith WY and May loads for each segment for all possible constituents

#LOAD THE classInt LIBRARY SO AS TO COMPUTE JENKS BREAKS
library(classInt)

MAX_SHAPEFILE_COLUMN_NAME_LENGTH<-10

#IMPORT SLD FROM A USER-DEFINED DIRECTORY
template_sld<-scan("template.sld",what="",sep="\n")

#DEFINE LIST OF CONSTITUENT ABBREVIATIONS
consts<- c("NO3_NO2","TN","TP")

#DEFINE TIME PERIODS FOR DISPLAY
ptypes<- c("WY","May")


template_sld.wrap <- function (template_sld,consts,ptypes,a.ll,m.ll){
	
	#DEFINE SITES FOR USE IN MISS RIVER PAGE AND FOR COMPUTING JENKS BREAKS
	misssites<-c("ALEX","BATO","BELL","CALU","CANN","CLIN","DESO","ELKH","GRAF","GRAN","HARR","HAST","HAZL","HERM","KEOS","KERS","LITT","LONG","LOUI","MELV","MISS","MORG","NEWH","NEWP","OMAH","PADU","SEDG","SEWI","SIDN","STFR","STTH","SUMN","THEB","VALL","VICK","WAPE")

	aljenks.brks<-classIntervals(as.numeric(quantile(a.ll[a.ll$SITE_ABB %in% misssites&a.ll$MODTYPE %in% c("REG","REGHIST")&a.ll$CONSTIT %in% c("TN","TP","NO3_NO2"),"TONS"],seq(.001,1,by=.001))),23,style="jenks",rtimes=1)$brks
	mojenks.brks<-classIntervals(as.numeric(quantile(m.ll[m.ll$SITE_ABB %in% misssites&m.ll$MODTYPE %in% c("REG","REGHIST")&m.ll$MONTH==5&m.ll$CONSTIT %in% c("TN","TP","NO3_NO2"),"TONS"],seq(.001,1,by=.001))),23,style="jenks",rtimes=1)$brks

	for(j in 1:length(consts)){
		for (k in 1:length(ptypes)){
			aljenks.brks
			const<-consts[j]
			p.type<-ptypes[k]
			sld<-rep(template_sld,1)
			
			##change line thickness values
			#SUBSET SLD FILE INTO ROWS WITH THE WORD "LITERAL" FOR CHANGING LINE THICKNESS VALUES
			sld.literal<-sld[grep("Literal",sld)]

			#SPLIT UP SUBSET ROWS
			sld.literal.split<-t(matrix(unlist(strsplit(	sld.literal,"[<>]")), ncol = 50))

			#TAKE JENKS BREAKS, DUPLICATE THEM, AND REORDER THEM, DEFINE jenks1 as annual for WY or monthly for May
			if(p.type=="WY"){
				jenks1<-c(.011,.011,rep(aljenks.brks,2))}else{jenks1<-c(.011,.011,rep(mojenks.brks,2))}
			jenks1<-as.character(jenks1[order(jenks1)])

			#REASSIGN LINE THICKNESS BASED ON JENKS BREAKS
			sld.literal.split[,3]<-jenks1
					
			#TAKE SPLIT UP, SUBSET DATA AND REINSERT INTO THE SLD
			sld[grep("Literal",sld)]<-paste(	sld.literal.split[,1],"<",	sld.literal.split[,2],">",	sld.literal.split[,3],"<",	sld.literal.split[,4],">",sep="")
					
			#SUBSET SLD FILE INTO ROWS WITH THE WORD "TITLE" FOR CHANGING TITLE VALUES
			sld.title<-sld[grep("TITLE",sld)]
			#SPLIT UP SUBSET ROWS
			sld.title.split<-t(matrix(unlist(strsplit(sld.title,"[<>]")), ncol = 1))
      
			#REASSIGN TITLE BASED ON CONSTITUENT
			sld.title.split[,3]<-paste(const," Load in the Mississippi",sep="")
			sld[grep("TITLE",sld)]<-	paste(			sld.title.split[,1],"<",			sld.title.split[,2],">",			sld.title.split[,3],"<",			sld.title.split[,4],">",sep="")	

      #REASSIGN MINIMUM BASED on minimum break
      sld.min<-sld[grep("MINIMUM",sld)]
      sld.min.split<-t(unlist(strsplit(sld.min, "[<>]")))
      sld.min.split[,3]<-paste("Minimum (&#60; ", formatC(round(as.numeric(jenks1[3])),format="d",big.mark=','), " tons)", sep="")
			sld[grep("MINIMUM", sld)]<- paste( sld.min.split[,1],"<",  sld.min.split[,2],">", sld.min.split[,3],"<",   sld.min.split[,4],">", sep="")
      
			#REASSIGN MEDIAN BASED on median break
			sld.median<-sld[grep("MEDIAN",sld)]
			sld.median.split<-t(unlist(strsplit(sld.median, "[<>]")))
			sld.median.split[,3]<-paste("Median (", formatC(round(as.numeric(jenks1[28])),format="d",big.mark=','), " tons)", sep="")
			sld[grep("MEDIAN", sld)]<- paste( sld.median.split[,1],"<",  sld.median.split[,2],">", sld.median.split[,3],"<",   sld.median.split[,4],">", sep="")
      
			#REASSIGN MAXIMUM BASED on maximum break
			sld.max<-sld[grep("MAXIMUM",sld)]
			sld.max.split<-t(unlist(strsplit(sld.max, "[<>]")))
			sld.max.split[,3]<-paste("Maximum (&#62; ", formatC(round(as.numeric(jenks1[length(jenks1)])),format="d",big.mark=','), " tons)", sep="")
			sld[grep("MAXIMUM", sld)]<- paste( sld.max.split[,1],"<",  sld.max.split[,2],">", sld.max.split[,3],"<",   sld.max.split[,4],">", sep="")
			 
			#SUBSET SLD FILE INTO ROWS WITH THE WORD "PropertyName" FOR CHANGING PropertyName VALUES
			sld.property<-sld[grep("PropertyName",sld)]
			#SPLIT UP SUBSET ROWS
			sld.property.split<-t(matrix(unlist(strsplit(	sld.property,"[<>]")), ncol = 1))
			
			#REASSIGN PropertyName BASED ON CONSTITUENT AND TYPE OF ESTIMATE (WY OR MAY)
			sld.property.split[,3]<-paste(const,p.type,sep="_")
			sld[grep("PropertyName",sld)]<-	paste(	sld.property.split[,1],"<",	sld.property.split[,2],">",	strtrim(sld.property.split[,3], MAX_SHAPEFILE_COLUMN_NAME_LENGTH),"<",	sld.property.split[,4],">",sep="")
      
			#REASSIGN STYLE Name
			sld.layerName<-sld[grep("LAYER_NAME", sld)]
			sld.layerName.split<-t(unlist(strsplit(sld.layerName, "[<>]")))
			sld.layerName.split[,3]<-paste(tolower(const),"_",tolower(p.type), sep="")
			sld[grep("LAYER_NAME", sld)]<- paste( sld.layerName.split[,1],"<",  sld.layerName.split[,2],">", sld.layerName.split[,3],"<",   sld.layerName.split[,4],">", sep="")
			
	
			#WRITE SLD FILE BASED ON CONTITUENT AND PERIOD
			lapply(sld, write, paste(tolower(const),"_",tolower(p.type),".sld",sep=""), append=TRUE, ncolumns=length(sld))
		}
	}
}

#example usage commented out below

#a.ll<-read.table("../timeSeries/data/Aloads.txt",header=TRUE,colClasses=c(rep("character",4),rep(NA,7)))
#m.ll<-read.table("../timeSeries/data/Mloads.txt",header=TRUE,colClasses=c(rep("character",4),rep(NA,6)))

#template_sld.wrap(template_sld, consts, ptypes, a.ll, m.ll)