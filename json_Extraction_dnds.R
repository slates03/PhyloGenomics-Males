module load bioinfo
module load r

R


dnds<-matrix(nrow=0,ncol=5)
colnames(dnds)<-colnames(x)<-c("protein_id","dN","dS","dNdS","Species")

json<-read.table("/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/hyphy/dnds/json_3.txt")
json<-as.character(json[,1])

for(i in json){
  
  
  attach<-"_aligned_3.fasta.FITTER.json"
  file<-gsub(" ", "", paste(i, attach))
  
  
  
  #Packages
  library(jsonlite)
  library(rjson)
  
  #Working Directory
  setwd("/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/hyphy/dnds")
  
  #Get file of interest
  my.JSON <- fromJSON(file=file)
  
  AMEL_DS<-data.frame(my.JSON$`branch attributes`$`0`$GEN_apis_mellifera$dS[[1]])
  AMEL_DN<-data.frame(my.JSON$`branch attributes`$`0`$GEN_apis_mellifera$dN[[1]])
  BIMP_DS<-data.frame(my.JSON$`branch attributes`$`0`$GEN_bombus_impatiens$dS[[1]])
  BIMP_DN<-data.frame(my.JSON$`branch attributes`$`0`$GEN_bombus_impatiens$dN[[1]])
  MROT_DS<-data.frame(my.JSON$`branch attributes`$`0`$GEN_megachile_rotundata$dS[[1]])
  MROT_DN<-data.frame(my.JSON$`branch attributes`$`0`$GEN_megachile_rotundata$dN[[1]])
  EDIL_DS<-data.frame(my.JSON$`branch attributes`$`0`$TR_euglossa_dilemma$dS[[1]])
  EDIL_DN<-data.frame(my.JSON$`branch attributes`$`0`$TR_euglossa_dilemma$dN[[1]])
  TCARB_DS<-data.frame(my.JSON$`branch attributes`$`0`$TR_tetragonula_carbonaria$dS[[1]])
  TCARB_DN<-data.frame(my.JSON$`branch attributes`$`0`$TR_tetragonula_carbonaria$dN[[1]])

  
  x<-data.frame(matrix(nrow=1,ncol=5))
  
  x[1,1]<-i
  x[1,2]<-AMEL_DN
  x[1,3]<-AMEL_DS
  x[1,4]<-(as.numeric(x[1,2]))/(as.numeric(x[1,3]))
  x[1,5]<-"AMEL"
  x[2,1]<-i
  x[2,2]<-BIMP_DN
  x[2,3]<-BIMP_DS
  x[2,4]<-(as.numeric(x[2,2]))/(as.numeric(x[2,3]))
  x[2,5]<-"BIMP"
  x[3,1]<-i
  x[3,2]<-MROT_DN
  x[3,3]<-MROT_DS
  x[3,4]<-(as.numeric(x[3,2]))/(as.numeric(x[3,3]))
  x[3,5]<-"MROT"
  x[4,1]<-i
  x[4,2]<-TCARB_DN
  x[4,3]<-TCARB_DS
  x[4,4]<-(as.numeric(x[4,2]))/(as.numeric(x[4,3]))
  x[4,5]<-"TCARB"
  x[5,1]<-i
  x[5,2]<-EDIL_DN
  x[5,3]<-EDIL_DS
  x[5,4]<-(as.numeric(x[5,2]))/(as.numeric(x[5,3]))
  x[5,5]<-"EDIL"
  
  colnames(x)<-c("protein_id","dN","dS","dNdS","Species")
  
  dnds<-rbind(dnds,x)
  
  
}

write.table(dnds,"/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/hyphy/dnds/dnds_3.txt")

