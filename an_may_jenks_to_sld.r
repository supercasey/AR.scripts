

#' Writes annual and May slds for all constituents based on jenks breaks computed in an.may.wrap.r 
#' This script depends on the presence of a user-input sld file,"aljenks.brks", a vector of annual jenks breaks and "mojenks.brks", a vector of monthly jenks breaks
#' @param slds is a user input sld file identical in format to the no23_wy example provided to Casey via email November 2014, this file should be inputby the user  using the following command: slds<-scan("filename",what="",sep="\n")
#' @param consts is a character vector representing  the constituents to be mapped, currently defined as NO23, TN, and TP
#' @param ptypes are a character vector of types of loads, currently they include "WY" or "May"
#'@param aljenks.brks is a numeric vector of jenks breaks for annual loads
#'@param mojenks.brks is a numeric vector of jenks breaks for monthly loads
#' This script writes sld fileswith WY and May loads for each segment for all possible constituents

slds<-scan("no23_wy.sld",what="",sep="\n")
consts<- c("NO23","TN","TP")
ptypes<- c("WY","May")


sld.wrap <- function (slds,consts,ptypes,aljenks.brks,mojenks.brks){
	
	for(j in 1:length(consts)){
		for (k in 1:length(ptypes)){
			
			gg<-slds
			const<-consts[j]
			p.type<-ptypes[k]
			
			##change line thickness values
			ggg<-gg[grep("Literal",gg)]
			
			gggg<-t(matrix(unlist(strsplit(ggg,"[<>]")), ncol = 50))
			
			if(p.type=="WY"){
				jenks1<-rep(aljenks.brks,2)}else{jenks1<-rep(mojenks.brks,2)}
			jenks1<-as.character(jenks1[order(jenks1)])
			gggg[,3]<-aljenks1
			
			gg[grep("Literal",gg)]<-paste(gggg[,1],"<",gggg[,2],">",gggg[,3],"<",gggg[,4],">",sep="")
			
			##change title
			ggg<-gg[grep("Title",gg)]
			ggg
			gggg<-t(matrix(unlist(strsplit(ggg,"[<>]")), ncol = 1))
			
			gggg
			gggg[,3]<-paste(const," Load in the Mississippi",sep="")
			gg[grep("Title",gg)]<-	paste(gggg[,1],"<",gggg[,2],">",gggg[,3],"<",gggg[,4],">",sep="")	
			gg	
			
			
			##change property name
			ggg<-gg[grep("PropertyName",gg)]
			ggg
			gggg<-t(matrix(unlist(strsplit(ggg,"[<>]")), ncol = 1))
			
			gggg
			
			gggg[,3]<-paste(const,p.type,sep="_")
			gg[grep("PropertyName",gg)]<-	paste(gggg[,1],"<",gggg[,2],">",gggg[,3],"<",gggg[,4],">",sep="")	
			gg	
			
			
			##change name
			ggg<-gg[grep("<Name>",gg)]
			ggg
			gggg<-t(matrix(unlist(strsplit(ggg,"[<>]")), ncol = 1))
			
			gggg
			
			gggg[,3]<-tolower(paste(const,p.type,sep="_"))
			gg[grep("<Name>",gg)]<-	paste(gggg[,1],"<",gggg[,2],">",gggg[,3],"<",gggg[,4],">",sep="")	
			gg	
			
			
			
			
			lapply(gg, write, paste(tolower(const),"_",tolower(p.type),".sld",sep=""), append=TRUE, ncolumns=length(gg))
		}
	}
}
