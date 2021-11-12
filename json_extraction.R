module load bioinfo
module load r

R


phylo<-matrix(nrow=0,ncol=7)
colnames(phylo)<-c("ID","dN","dS","dNdS","LogL","AIC","Param")
json<-read.table("/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/hyphy/Fel/json_3")
json<-as.character(json[,1])

for(i in json){


attach<-"_aligned_3.fasta.FEL.json"
file<-gsub(" ", "", paste(i, attach))


#Packages
library(jsonlite)
library(rjson)

#Working Directory
setwd("/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/hyphy/Fel")

#Get file of interest
my.JSON <- fromJSON(file=file)

dNdS<-data.frame(my.JSON$fits$`Global MG94xREV`$`Rate Distributions`$`non-synonymous/synonymous rate ratio for *test*`[[1]])
LogL<-my.JSON$fits$`Global MG94xREV`$`Log Likelihood`
AIC<-my.JSON$fits$`Global MG94xREV`$`AIC-c`
param<-my.JSON$fits$`Global MG94xREV`$`estimated parameters`

x<-matrix(nrow=1,ncol=7)

x[,1]<-i
x[,2]<-dNdS[1,]
x[,3]<-dNdS[2,]
x[,4]<-(as.numeric(x[,2]))/(as.numeric(x[,3]))
x[,5]<-LogL
x[,6]<-AIC
x[,7]<-param

phylo<-rbind(phylo,x)


}

write.table(phylo,"/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/hyphy/Fel/phylo")



