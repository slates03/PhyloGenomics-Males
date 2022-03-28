module load bioinfo
module load r

R


phylo<-matrix(nrow=0,ncol=3)
colnames(phylo)<-c("ID","DNDS","Species")
json<-read.table("/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/hyphy/asBREL/ASBREL.txt")
json<-as.character(json[,1])

for(i in json){

attach<-"_aligned_2.fasta.ABSREL.json"
file<-gsub(" ", "", paste(i, attach))

#Packages
library(jsonlite)
library(rjson)

#Working Directory
setwd("/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/hyphy/asBREL")

#Get file of interest
my.JSON <- fromJSON(file=file)


AMEL<-my.JSON$`branch attributes`$`0`$GEN_apis_mellifera$`Rate Distributions`[[1]][[1]]
BIMP<-my.JSON$`branch attributes`$`0`$GEN_bombus_impatiens$`Rate Distributions`[[1]][[1]]
TCARB<-my.JSON$`branch attributes`$`0`$TR_tetragonula_carbonaria$`Rate Distributions`[[1]][[1]]
EDIL<-my.JSON$`branch attributes`$`0`$TR_euglossa_dilemma$`Rate Distributions`[[1]][[1]]
MROT<-my.JSON$`branch attributes`$`0`$GEN_megachile_rotundata$`Rate Distributions`[[1]][[1]]

x<-matrix(nrow=5,ncol=3)

f=1

x[f,1]<-i
x[f,2]<-AMEL
x[f,3]<-"AMEL"
x[(f+1),1]<-i
x[(f+1),2]<-BIMP
x[(f+1),3]<-"BIMP"
x[(f+2),1]<-i
x[(f+2),2]<-TCARB
x[(f+2),3]<-"TCARB"
x[(f+3),1]<-i
x[(f+3),2]<-EDIL
x[(f+3),3]<-"EDIL"
x[(f+4),1]<-i
x[(f+4),2]<-MROT
x[(f+4),3]<-"MROT"


phylo<-rbind(phylo,x)


}

write.table(phylo,"/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/hyphy/asBREL/phylo")