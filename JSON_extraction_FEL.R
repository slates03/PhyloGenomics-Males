module load bioinfo
module load r

R


phylo<-matrix(nrow=0,ncol=4)
colnames(phylo)<-c("ID","Nucleotide GTR","Global MG94xREV","Species")
json<-read.table("/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/hyphy/Fel/FEL_3.txt")
json<-as.character(json[,1])

for(i in json){

attach<-"_aligned_3.fasta.FEL.json"
file<-gsub(" ", "", paste(i, attach))


#Packages
library(jsonlite)
library(rjson)

#Working Directory
setwd("/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/hyphy/Fel")

#Get file of interest
my.JSON <- fromJSON(file=file)

AMEL_GTR<-my.JSON$`branch attributes`$`0`$GEN_apis_mellifera$`Nucleotide GTR`
AMEL_MG94<-my.JSON$`branch attributes`$`0`$GEN_apis_mellifera$`Global MG94xREV`
BIMP_GTR<-my.JSON$`branch attributes`$`0`$GEN_bombus_impatiens$`Nucleotide GTR`
BIMP_MG94<-my.JSON$`branch attributes`$`0`$GEN_bombus_impatiens$`Global MG94xREV`
TCARB_GTR<-my.JSON$`branch attributes`$`0`$TR_tetragonula_carbonaria$`Nucleotide GTR`
TCARB_MG94<-my.JSON$`branch attributes`$`0`$TR_tetragonula_carbonaria$`Global MG94xREV`
EDIL_GTR<-my.JSON$`branch attributes`$`0`$TR_euglossa_dilemma$`Nucleotide GTR`
EDIL_MG94<-my.JSON$`branch attributes`$`0`$TR_euglossa_dilemma$`Global MG94xREV`
MROT_GTR<-my.JSON$`branch attributes`$`0`$GEN_megachile_rotundata$`Nucleotide GTR`
MROT_MG94<-my.JSON$`branch attributes`$`0`$GEN_megachile_rotundata$`Global MG94xREV`

x<-matrix(nrow=5,ncol=4)

f=1

x[f,1]<-i
x[f,2]<-AMEL_GTR
x[f,3]<-AMEL_MG94
x[f,4]<-"AMEL"
x[(f+1),1]<-i
x[(f+1),2]<-BIMP_GTR
x[(f+1),3]<-BIMP_MG94
x[(f+1),4]<-"BIMP"
x[(f+2),1]<-i
x[(f+2),2]<-TCARB_GTR
x[(f+2),3]<-TCARB_MG94
x[(f+2),4]<-"TCARB"
x[(f+3),1]<-i
x[(f+3),2]<-EDIL_GTR
x[(f+3),3]<-EDIL_MG94
x[(f+3),4]<-"EDIL"
x[(f+4),1]<-i
x[(f+4),2]<-MROT_GTR
x[(f+4),3]<-MROT_MG94
x[(f+4),4]<-"MROT"


phylo<-rbind(phylo,x)


}

write.table(phylo,"/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/hyphy/Fel/phylo")
