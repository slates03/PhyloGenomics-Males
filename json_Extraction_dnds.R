module load bioinfo
module load r

R


dnds<-matrix(nrow=0,ncol=16)
colnames(dnds)<-c("protein_id","AMEL_dN","AMEL_dS","AMEL_dNdS","BIMP_dN","BIMP_dS","BIMP_dNdS","MROT_dN","MROT_dS","MROT_dNdS","TCARB_dN","TCARB_dS",
"TCARB_dNdS","EDILL_dN","EDIL_dS","EDIL_dNdS")

json<-read.table("/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/hyphy/dnds/json_4.txt")
json<-as.character(json[,1])

for(i in json){
  
  
  attach<-"_aligned_4.fasta.FITTER.json"
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

  
  x<-data.frame(matrix(nrow=1,ncol=16))
  
  x[,1]<-i
  x[,2]<-AMEL_DN
  x[,3]<-AMEL_DS
  x[,4]<-(as.numeric(x[,2]))/(as.numeric(x[,3]))
  x[,5]<-BIMP_DN
  x[,6]<-BIMP_DN
  x[,7]<-(as.numeric(x[,5]))/(as.numeric(x[,6]))
  x[,8]<-MROT_DN
  x[,9]<-MROT_DS
  x[,10]<-(as.numeric(x[,8]))/(as.numeric(x[,9]))
  x[,11]<-TCARB_DN
  x[,12]<-TCARB_DS
  x[,13]<-(as.numeric(x[,11]))/(as.numeric(x[,12]))
  x[,14]<-EDIL_DN
  x[,15]<-EDIL_DS
  x[,16]<-(as.numeric(x[,14]))/(as.numeric(x[,15]))
  
  colnames(x)<-c("protein_id","AMEL_dN","AMEL_dS","AMEL_dNdS","BIMP_dN","BIMP_dS","BIMP_dNdS","MROT_dN","MROT_dS","MROT_dNdS","TCARB_dN","TCARB_dS",
                     "TCARB_dNdS","EDILL_dN","EDIL_dS","EDIL_dNdS")
  
  dnds<-rbind(dnds,x)
  
  
}

write.table(dnds,"/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/hyphy/dnds/dnds_4.txt")

