module load bioinfo
module load r

R


relax_AMEL<-matrix(nrow=0,ncol=4)
colnames(relax_AMEL)<-c("protein_id","p-value","k","Species")

json<-read.table("/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/hyphy/Relax/list_3.txt")
json<-as.character(json[,1])

for(i in json){
  
  
  attach<-"_aligned_3.fasta.RELAX.json"
  file<-gsub(" ", "", paste(i, attach))


  #Packages
  library(jsonlite)
  library(rjson)
  
  #Working Directory
  setwd("/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/hyphy/Relax")

  
  #Get file of interest
  my.JSON <- fromJSON(file=file)
  
  pvalue<-data.frame(my.JSON$`test results`$`p-value`)
  k<-data.frame(my.JSON$`test results`$`relaxation or intensification parameter`)

  
  x<-data.frame(matrix(nrow=1,ncol=4))
  
  x[1,1]<-i
  x[1,2]<-pvalue
  x[1,3]<-k
  x[1,4]<-"AMEL"

  
  colnames(x)<-c("protein_id","p-value","k","Species")
  
  relax_AMEL<-rbind(relax_AMEL,x)
}

write.table(relax_AMEL,"/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/hyphy/Relax/relax_AMEL.txt")


