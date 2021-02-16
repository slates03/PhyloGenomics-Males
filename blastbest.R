cd /depot/bharpur/data/projects/slater/Resources/orthologs

ml bioinfo; module load r


#run blasts 
	#Move all protein cds files to the directory. Update the TCARB protein fasta 
	#Add tcarb protein fasta below and into allblast.sh
	#I have put "NAMEHERE" where you need to add TCARB



allblast_2.sh



#extract all protein IDs in the data set for each species and simplify the names for each 
grep '>' /depot/bharpur/data/projects/slater/Resources/Ref_Genome/GCF_000214255.1_Bter_1.0_protein.faa  > BTprot
grep '>' /depot/bharpur/data/projects/slater/Resources/Ref_Genome/GCF_003254395.2_Amel_HAv3.1_protein.faa > AMprot
grep '>' /depot/bharpur/data/projects/slater/Resources/Ref_Genome/GCF_000188095.3_BIMP_2.2_protein.faa  > BIprot
grep '>' /depot/bharpur/data/projects/slater/Resources/Ref_Genome/GCF_000220905.1_MROT_1.0_protein.faa > MRprot
grep '>' /depot/bharpur/data/projects/slater/Resources/Ref_Genome/Tetragonula_carbonaria.proteins.fa | awk '{print $1}'> TCprot #update <-----------------------------------
grep '>' /depot/bharpur/data/projects/slater/Resources/Ref_Genome/Edil_OGS_v1.1_prot.fa > EDprot

sed -i 's/>//g' BTprot
sed -i 's/>//g' AMprot
sed -i 's/>//g' BIprot
sed -i 's/>//g' MRprot
sed -i 's/>//g' TCprot
sed -i 's/>//g' EDprot

cut -f1 -d ' ' BTprot > BTprot_IDs 
cut -f1 -d ' ' AMprot > AMprot_IDs 
cut -f1 -d ' ' BIprot > BIprot_IDs 
cut -f1 -d ' ' MRprot > MRprot_IDs
cut -f1 -d ' ' TCprot > TCprot_IDs
cut -f1 -d ' ' EDprot > EDprot_IDs



#this is R below---------------------------------------------------------------


#recirprocal blasts for orthologs -----------------
library(data.table)
library(stringr)
library(dplyr)
library(tidyr)

#--------------------------------------------------
#functions
#--------------------------------------------------
Read.Fasta.DF <- function(data.frame){
#setwd("/media/data1/forty3/brock/AM45Regions")
r=readLines(data.frame);r=as.vector(r)
x=grep(">", r) #so, regions are from 2:19750
ma=x+1;mi=x-1;mi=mi[-1];mi=c(mi, length(r))
chrom=r[x];chrom=gsub(">", "", chrom)
chrom=gsub(" ","",chrom)
	seqs=c(0,1)
	for (i in 1:length(ma)){x=(r[ma[i]:mi[i]]);x=paste(x, collapse = '');seqs=c(seqs,x)}
	seqs=seqs[-c(1,2)]
	AMEL=data.frame(cbind(chrom, seqs))
	return(AMEL)
}



Write.Fasta.DF <- function(data.frame, fil = 'out.fa'){
	#must have same format as Read.Fasta.DF output
		#col 1 = ID, col 2 = sequence
	seqs=as.character(unlist(data.frame[2]))
	ids=paste(">",as.character(unlist((data.frame[1]))),sep="")
	for (i in 1:nrow(data.frame)){
		sink(file=fil, append=T)
		cat(as.character(ids[i]));cat("\n")
		cat(seqs[i]);cat("\n")	
		sink()
	}
}
#######################################


#--------------------------------------------------
#BI
#--------------------------------------------------
	
	#blastp	-query GCF_000188095.3_BIMP_2.2_protein.faa 
	#-subject GCF_003254395.2_Amel_HAv3.1_protein.faa 
	#-evalue 1e-10 -outfmt 6 -num_alignments 5 > BIvamel
	#blastp	-query GCF_003254395.2_Amel_HAv3.1_protein.faa -subject GCF_000188095.3_BIMP_2.2_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > AMvbimp




q <- read.table('BIvamel', sep='\t') #bimp first here 
s <- read.table('AMvbimp') #amel first


#get best and put a count in there ---------------

q <- q[order(q$V1, q$V11 ), ]
q <- q[ !duplicated(q$V1), ]              # take the first row within each id


s <- s[order(s$V1, s$V11), ]
s <- s[ !duplicated(s$V1), ]              # take the first row within each id


#names(q)[c(1,2)] <- c('bimp', 'amel')
#names(s)[c(1,2)] <- c('amel', 'bimp')

q$id <- paste(q$V1, q$V2, sep=':') #bimp_amel
s$id <- paste(s$V2, s$V1, sep=':')



df <- merge(q,s, by = 'id')
bimp <- df[c(1)]
###################################################



#--------------------------------------------------
#BT
#--------------------------------------------------
q <- read.table('BTvamel', sep='\t') #bimp first here 
s <- read.table('AMvbter') #amel first


#get best and put a count in there ---------------
q <- q[order(q$V1, q$V11 ), ]
q <- q[ !duplicated(q$V1), ]              # take the first row within each id


s <- s[order(s$V1, s$V11), ]
s <- s[ !duplicated(s$V1), ]              # take the first row within each id


#names(q)[c(1,2)] <- c('bimp', 'amel')
#names(s)[c(1,2)] <- c('amel', 'bimp')

q$id <- paste(q$V1, q$V2, sep=':') #bimp_amel
s$id <- paste(s$V2, s$V1, sep=':')


df <- merge(q,s, by = 'id')
bter <- df[c(1)]
###################################################



#--------------------------------------------------
#TC
#--------------------------------------------------
q <- read.table('TCvamel', sep='\t') #bimp first here 
s <- read.table('AMvtcarb') #amel first


#get best and put a count in there ---------------
q <- q[order(q$V1, q$V11), ]
q <- q[ !duplicated(q$V1), ]              # take the first row within each id


s <- s[order(s$V1, s$V11), ]
s <- s[ !duplicated(s$V1), ]              # take the first row within each id


#names(q)[c(1,2)] <- c('bimp', 'amel')
#names(s)[c(1,2)] <- c('amel', 'bimp')

q$id <- paste(q$V1, q$V2, sep=':') #bimp_amel
s$id <- paste(s$V2, s$V1, sep=':')



df <- merge(q,s, by = 'id')
tcarb <- df[c(1)]
###################################################



#--------------------------------------------------
#ED
#--------------------------------------------------
q <- read.table('EDvamel', sep='\t') #bimp first here 
s <- read.table('AMvedil') #amel first


#get best and put a count in there ---------------
q <- q[order(q$V1, q$V11), ]
q <- q[ !duplicated(q$V1), ]              # take the first row within each id


s <- s[order(s$V1, s$V11), ]
s <- s[ !duplicated(s$V1), ]              # take the first row within each id


#names(q)[c(1,2)] <- c('bimp', 'amel')
#names(s)[c(1,2)] <- c('amel', 'bimp')

q$id <- paste(q$V1, q$V2, sep=':') #bimp_amel
s$id <- paste(s$V2, s$V1, sep=':')



df <- merge(q,s, by = 'id')
edil <- df[c(1)]
###################################################



#--------------------------------------------------
#MR
#--------------------------------------------------
q <- read.table('MRvamel', sep='\t') #bimp first here 
s <- read.table('AMvmrot') #amel first


#get best and put a count in there ---------------
q <- q[order(q$V1, q$V11), ]
q <- q[ !duplicated(q$V1), ]              # take the first row within each id


s <- s[order(s$V1, s$V11), ]
s <- s[ !duplicated(s$V1), ]              # take the first row within each id


#names(q)[c(1,2)] <- c('bimp', 'amel')
#names(s)[c(1,2)] <- c('amel', 'bimp')

q$id <- paste(q$V1, q$V2, sep=':') #bimp_amel
s$id <- paste(s$V2, s$V1, sep=':')


df <- merge(q,s, by = 'id')
mrot <- df[c(1)]
###################################################



mrot <- mrot %>% separate(id, c("mrot", "amel"), ":")
edil <- edil %>% separate(id, c("edil", "amel"), ":")
tcarb <- tcarb %>% separate(id, c("tcarb", "amel"), ":")
bimp <- bimp %>% separate(id, c("bimp", "amel"), ":")
bter <- bter %>% separate(id, c("bter", "amel"), ":")


#contains orthologs RBH hits
df <- merge(mrot,edil, by = 'amel', all=T)
df <- merge(tcarb,df, by = 'amel', all=T)
df <- merge(bimp,df, by = 'amel', all=T)
df <- merge(bter,df, by = 'amel', all=T)

#now I need to read in and write all the proteomes and output just these proteins. 

bt <- Read.Fasta.DF('GCF_000214255.1_Bter_1.0_protein.faa')
bi <- Read.Fasta.DF('GCF_000188095.3_BIMP_2.2_protein.faa')
mr <- Read.Fasta.DF('GCF_000220905.1_MROT_1.0_protein.faa')
tc <- Read.Fasta.DF('Tetragonula_carbonaria.proteins_1.fa') #<--------------------------------------------------------- update
ed <- Read.Fasta.DF('Edil_OGS_v1.1_prot.fa')
am <- Read.Fasta.DF('GCF_003254395.2_Amel_HAv3.1_protein.faa')


bt$chrom <- gsub('([.][0-9]).*', '\\1', bt$chrom)
bi$chrom <- gsub('([.][0-9]).*', '\\1', bi$chrom)
mr$chrom <- gsub('([.][0-9]).*', '\\1', mr$chrom)
tc$chrom <- gsub('([.][0-9]).*', '\\1', tc$chrom)
ed$chrom <- gsub('([.][0-9]).*', '\\1', ed$chrom)
am$chrom <- gsub('([.][0-9]).*', '\\1', am$chrom)


am <- (am[which(am$chrom %in% df$amel),])
bi <- (bi[which(bi$chrom %in% df$bimp),])
bt <- (bt[which(bt$chrom %in% df$bter),])
mr <- (mr[which(mr$chrom %in% df$mrot),])
tc <- (tc[which(tc$chrom %in% df$tcarb),])
ed <- (ed[which(ed$chrom %in% df$edil),])



Write.Fasta.DF(am, fil = 'am.fa')
Write.Fasta.DF(bi, fil = 'bi.fa')
Write.Fasta.DF(bt, fil = 'bt.fa')
Write.Fasta.DF(mr, fil = 'mr.fa')
Write.Fasta.DF(tc, fil = 'tc.fa')
Write.Fasta.DF(ed, fil = 'ed.fa')
write.table(df, file ='orthologs')

#########################################################################











