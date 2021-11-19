module load bioinfo
module load r

R


dnds<-matrix(nrow=0,ncol=3)
colnames(dnds)<-c("protein_id","dNdS","Species")

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
  
  AMEL<-data.frame(my.JSON$`branch attributes`$`0`$GEN_apis_mellifera$`Confidence Intervals`$MLE)
  AMEL<-data.frame(my.JSON$`branch attributes`$`0`$GEN_apis_mellifera$dN[[1]])
  BIMP<-data.frame(my.JSON$`branch attributes`$`0`$GEN_bombus_impatiens$`Confidence Intervals`$MLE)
  MROT<-data.frame(my.JSON$`branch attributes`$`0`$GEN_megachile_rotundata$`Confidence Intervals`$MLE)
  EDIL<-data.frame(my.JSON$`branch attributes`$`0`$TR_euglossa_dilemma$`Confidence Intervals`$MLE)
  TCARB<-data.frame(my.JSON$`branch attributes`$`0`$TR_tetragonula_carbonaria$`Confidence Intervals`$MLE)

  
  x<-data.frame(matrix(nrow=1,ncol=3))
  
  x[1,1]<-i
  x[1,2]<-AMEL
  x[1,3]<-"AMEL"
  x[2,1]<-i
  x[2,2]<-BIMP
  x[2,3]<-"BIMP"
  x[3,1]<-i
  x[3,2]<-MROT
  x[3,3]<-"MROT"
  x[4,1]<-i
  x[4,2]<-TCARB
  x[4,3]<-"TCARB"
  x[5,1]<-i
  x[5,2]<-EDIL
  x[5,3]<-"EDIL"
  
  colnames(x)<-c("protein_id","dNdS","Species")
  
  dnds<-rbind(dnds,x)
  
  
}

write.table(dnds,"/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/hyphy/dnds/dnds_4.txt")

