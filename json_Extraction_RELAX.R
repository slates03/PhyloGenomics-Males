module load bioinfo
module load r

R


relax_AMEL<-matrix(nrow=0,ncol=5)
colnames(relax_AMEL)<-c("protein_id","p-value","k","dnds","set")

json<-read.table("/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/hyphy/Relax/list_3.txt")
json<-as.character(json[,1])

for(i in json){
  
  
  attach<-"_aligned_3.fasta.RELAX.json"
  file<-gsub(" ", "", paste(i, attach))


file="XP_394396.2_aligned_3.fasta.RELAX.json"

  #Packages
  library(jsonlite)
  library(rjson)
  
  #Working Directory
  setwd("/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/hyphy/Relax")

  
  #Get file of interest
  my.JSON <- fromJSON(file=file)
  
  pvalue<-data.frame(my.JSON$`test results`$`p-value`)
  k<-data.frame(my.JSON$`test results`$`relaxation or intensification parameter`)
  
  dnds_ref<-data.frame(my.JSON$fits$`MG94xREV with separate rates for branch sets`$`Rate Distributions`$`non-synonymous/synonymous rate ratio for *Reference*`[[1]][1])
  
  dnds_test<-data.frame(my.JSON$fits$`MG94xREV with separate rates for branch sets`$`Rate Distributions`$`non-synonymous/synonymous rate ratio for *Test*`[[1]])


  x<-data.frame(matrix(nrow=1,ncol=5))
  
  x[1,1]<-i
  x[1,2]<-pvalue
  x[1,3]<-k
  x[1,4]<-dnds_ref
  x[1,5]<-"reference"
  x[2,1]<-i
  x[2,2]<-pvalue
  x[2,3]<-k
  x[2,4]<-dnds_test
  x[2,5]<-"test"


  
  colnames(x)<-c("protein_id","p-value","k","dnds","set")
  
  relax_AMEL<-rbind(relax_AMEL,x)
}

write.table(relax_AMEL,"/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/hyphy/Relax/relax_AMEL.txt")
