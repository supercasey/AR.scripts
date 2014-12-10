

#' Writes annual and May slds for all constituents based  on annual and monthly load data
#' This script depends on the presence of a user-input sld file, annual and monthly load data, a user-defined set of nutrient abbreviations for which to compute the files, and set of periods (Annual or May)
#' @param slds is a user input sld file identical in format to the no23_wy example provided to Casey via email November 2014, this file should be inputby the user  using the following command: slds<-scan("filename",what="",sep="\n")
#' @param consts is a character vector representing  the constituents to be mapped, currently defined as NO23, TN, and TP
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

#IMPORT SLD FROM A USER-DEFINED DIRECTORY
sld<-scan("no23_wy.sld",what="",sep="\n")

#DEFINE LIST OF CONSTITUENT ABBREVIATIONS
consts<- c("NO23","TN","TP")

#DEFINE TIME PERIODS FOR DISPLAY
ptypes<- c("WY","May")


sld.wrap <- function (sld,consts,ptypes,a.ll,m.ll){
	
	#DEFINE SITES FOR USE IN MISS RIVER PAGE AND FOR COMPUTING JENKS BREAKS
	misssites<-c("ALEX","BATO","BELL","CALU","CANN","CLIN","DESO","ELKH","GRAF","GRAN","HARR","HAST","HAZL","HERM","KEOS","KERS","LITT","LONG","LOUI","MELV","MISS","MORG","NEWH","NEWP","OMAH","PADU","SEDG","SEWI","SIDN","STFR","STTH","SUMN","THEB","VALL","VICK","WAPE")

	aljenks.brks<-classIntervals(as.numeric(quantile(a.ll[a.ll$SITE_ABB %in% misssites&a.ll$MODTYPE %in% c("REG","REGHIST")&a.ll$CONSTIT %in% c("TN","TP","NO23"),"TONS"],seq(.001,1,by=.001))),23,style="jenks",rtimes=1)$brks
	mojenks.brks<-classIntervals(as.numeric(quantile(m.ll[m.ll$SITE_ABB %in% misssites&m.ll$MODTYPE %in% c("REG","REGHIST")&m.ll$MONTH==5&M.ll$CONSTIT %in% c("TN","TP","NO23"),"TONS"],seq(.001,1,by=.001))),23,style="jenks",rtimes=1)$brks

	for(j in 1:length(consts)){
		for (k in 1:length(ptypes)){
			aljenks.brks
			const<-consts[j]
			p.type<-ptypes[k]
			
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
			sld.title<-sld[grep("Title",sld)]
	#SPLIT UP SUBSET ROWS
			sld.title.split<-t(matrix(unlist(strsplit(sld.title,"[<>]")), ncol = 1))
	
	#REASSIGN TITLE BASED ON CONSTITUENT
	sld.title.split[,3]<-paste(const," Load in the Mississippi",sep="")
			sld[grep("Title",sld)]<-	paste(			sld.title.split[,1],"<",			sld.title.split[,2],">",			sld.title.split[,3],"<",			sld.title.split[,4],">",sep="")	

			
			
	#SUBSET SLD FILE INTO ROWS WITH THE WORD "PropertyName" FOR CHANGING PropertyName VALUES
	sld.property<-sld[grep("PropertyName",sld)]
	#SPLIT UP SUBSET ROWS
	sld.property.split<-t(matrix(unlist(strsplit(	sld.property,"[<>]")), ncol = 1))
			
	#REASSIGN PropertyName BASED ON CONSTITUENT AND TYPE OF ESTIMATE (WY OR MAY)
	sld.property.split[,3]<-paste(const,p.type,sep="_")
			sld[grep("PropertyName",sld)]<-	paste(	sld.property.split[,1],"<",	sld.property.split[,2],">",	sld.property.split[,3],"<",	sld.property.split[,4],">",sep="")	
	
			
	#SUBSET SLD FILE INTO ROWS WITH THE WORD "NAME" FOR CHANGING NAME VALUES
sld.name<-sld[grep("<Name>",sld)]

#SPLIT UP SUBSET ROWS
sld.name.split<-t(matrix(unlist(strsplit(sld.name,"[<>]")), ncol = 1))
			
#REASSIGN Name BASED ON CONSTITUENT AND TYPE OF ESTIMATE (WY OR MAY)
		
sld.name.split[,3]<-tolower(paste(const,p.type,sep="_"))
			sld[grep("<Name>",sld)]<-	paste(sld.name.split[,1],"<",sld.name.split[,2],">",sld.name.split[,3],"<",sld.name.split[,4],">",sep="")	

#WRITE SLD FILE BASED ON CONTITUENT AND PERIOD
			lapply(sld, write, paste(tolower(const),"_",tolower(p.type),".sld",sep=""), append=TRUE, ncolumns=length(sld))
		}
	}
}
