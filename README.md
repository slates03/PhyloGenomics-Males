# Selection Identification on Male Genes
The selection pipeline identifies selection (dNdS) on orthologs across corbiculate bees (and outgroup Megachile rotundata). The pipeline uses orthologs produced using a Blast across all the species. These orthologs were then used to identify genes of interest and measure selection on these genes using HyPhy. This analysis allows us to look at divergence across corbiculate bees.

# Requirements
- R 3.1 or higher, with the following packages installed:
  - library(data.table)
  - library(stringr)
  - library(dplyr)
  - library(tidyr)
  - library(ape)
  - library(jsonlite)
  - library(rjson)
- muscle 3.8.3
- HyPhy 2.3.13
- BEDTools 2.29.0
- gffread 0.9.10
- bedops 2.4.29
- seqkit

# Species Acronyms
- Apis mellifera=AMEL
- Bombus impatiens=BIMP
- Megachile rotundata=MROT
- Tetragonula carbonaria=TCARB
- Euglossa dilemma=EDIL

# Produce Orthologs
Run blast for each species versus each other using ``` allblast.sh ```. The species include Tetragonula carbonaria (TCARB), Apis mellifera (AMEL),Bombus terrestris (BTER) Bombus impatiens (BIMP), Euglossa dilemma (EDIL) and Megachile rotundata (MROT). It is faster to run each blast in parallel for each species. 

The ortholog list was then produced using ``` blastbest.R ```. The acronyms in the file include:Tetragonula carbonaria (tc), Apis mellifera (am),Bombus terrestris (bt) (BTER) Bombus impatiens (bi), Euglossa dilemma (ed) and Megachile rotundata (mr)

Once the orthlog list is produced, the final ortholog file (orthologs_fullrows) for the analysis is produced by only included species of interest (AMEL,BIMP,EDIL,TCARB and MROT) and ensuring an ortholog is availible for each species. I also add a | between each species so I can run this through the shell later one.

 ```
awk '{print $2 " " $4 " " $5 " " $6 " " $7}' orthologs | sed 's/"//g'> orthologs_2

#Only full row - Remove NAs
awk '!/NA/' orthologs_2 | sed 's/ /|/g' > orthologs_fullrows
 ```

# MAKE FASTA FILE WITH ONLY CODING SEQUENCE (CDS)
FASTA file were produced using only protein coding regions for the analysis. In order to do this, the coding regions were extracted for each species and a FASTA file was produced for each one

First, the GFF files were converted to GFT using gffread 

 ```
 gffread directory/GCF_003254395.2_Amel_HAv3.1_genomic.gff -F -T -o directory/GCF_003254395.2_Amel_HAv3.1_genomic_2.gft
 ```
 
This worked for all species (TCARB,AMEL,BIMP,MROT), except for EDIL because of the lack of annotation. In order to overcome this GFF file, features (transcript_id,gene_id,id) were added. The numbers must differ so a number sequence list was produced and used for each feature
 
 ```
seq 1 227325 > xx 
awk '{print "transcript_id=" "" $1 ";" "geneID=" $1 ";" "ID=" $1}' xx > ID 
paste -d "" Edil_OGS_v1.1.gff ID >  Edil_OGS_v1.1_1.gff
 ```
 
Second, the coding regions (CDS) was filtered from the newly produced GFT file
 ```
awk '$3 == "CDS" {print $0}' directory/GCF_003254395.2_Amel_HAv3.1_genomic_2.gft > Amel_CDS.gft
 ```
Third, bed files were produced using BEDTools, and then filtered for chromosome ID, start,end, and strand direction
 ```
gtf2bed < Amel_CDS.gft > Amel_CDS.bed
awk '{ print $1 " " $2 " " $3 " " $6}' Amel_CDS.bed > Amel_CDS_1.bed
 ```
 
A seperate protein_id file was produced by using GREP to extract protein_id from the GFT file. For TCARB, transcript_id was extracted and Pattern was extracted in EDIL. These can replace protein_id in the code, and it will work well. I also removed any quotation marks. This ID file will be used later to produce the final FASTA file, so make sure it is saved.

 ```
grep "protein_id$pattern" Amel_CDS.bed | grep -o 'protein_id[^;]*'| sed 's/protein_id//g' | sed 's/"//g'  > AMEL_protein_id
 ```

The final bed file was produced by merging the protein_id file with the bed file. I also combined the protein_id and strand direction. This will make it easier to get the reverse complement of negative strand CDS. 

 ```
paste Amel_CDS_1.bed AMEL_protein_id | awk '{ print $1 " " $2 " " $3 " " $5 "_" $4}' | awk '{;$1=$1}1' OFS="\t" > Amel_CDS_final.bed
```
It is also important spaces are converted to tabs or BEDTools with not work. I used awk ```'{;$1=$1}1' OFS="\t"``` to do this, but the file can be checked using ```cat -A Amel_CDS_final.bed| head ```

output
```
NC_001566.1^I501^I1503^INP_008082.1_+$
NC_001566.1^I1793^I3359^INP_008083.1_+$
NC_001566.1^I3617^I4295^INP_008084.1_+$
NC_001566.1^I4443^I4602^INP_008085.1_+$
NC_001566.1^I4583^I5264^INP_008086.1_+$
NC_001566.1^I5284^I6064^INP_008087.1_+$
NC_001566.1^I6184^I6538^INP_008088.1_+$
NC_001566.1^I6891^I8556^INP_008089.1_-$
NC_001566.1^I8643^I9987^INP_008090.1_-$
NC_001566.1^I9990^I10254^INP_008091.1_-$
```

Finally, a FASTA file was produced for each species using BEDTools

```
bedtools getfasta -fi directory/GCF_003254395.2_Amel_HAv3.1_genomic.fna -bed Amel_CDS_final.bed -name |sed 's/--//' > AMEL_CDS.fasta
```

EDIL had different chromosome IDs between the GFF and genomic FASTA. To fix this,  I first extracted the chromosome IDs from the genomic FASTA file and the scaffold number from the chromosome description (the GFF chromosomes were name scaffolds) and made a chromosome conversion file
```
grep ">$pattern" GCA_002201625.1_Edil_v1.0_genomic.fna | grep -o '>[^;]*'| sed 's/>//g' | awk '{print $6 " " $1}'|sed 's/,//' >EDIL_Chrom_conversion
```

From here, I was able to change the chromosome IDs in the GFT file.
```
awk 'FNR==NR{a[$1]=$2;next} {print a[$1],$2,$3,$4}' EDIL_Chrom_conversion EDIL_CDS_final.bed | awk '{;$1=$1}1' OFS="\t" > EDIL_CDS_final_1.bed
```

# Convert FASTA to usable format
The FASTA file had to be altered for the alignment and selection analysis.

The produced FASTA file contains multiple sequences for many coding sequences (CDS). I combined these sequences into a single sequence using the shell script ```combine_CDS.sh```. The script used protein_id (produced earlier) for each species and the SPECIES.CDS file. 

The negative strand sequences must also be reversed for the alignment. The file was first seperated into positive and negative strand sequences files, then I used ```seqkit``` to reverse complement the negative strand sequences. Finally, I combined these sequences back. 

```
#Forward Strand
grep -A 1 "+$pattern" MROT_ortho_combined.fasta| sed 's/--//' |sed '/^[[:space:]]*$/d' > MROT_ortho_combined_for.fasta

#Reverse Strand
grep -A 1 "_-$pattern" MROT_ortho_combined.fasta| sed 's/--//' |sed '/^[[:space:]]*$/d' > MROT_ortho_combined_rev.fasta

/depot/bharpur/apps/seqkit seq -r -p MROT_ortho_combined_rev.fasta | awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' > MROT_ortho_combined_rev_rev.fasta

cat MROT_ortho_combined_for.fasta MROT_ortho_combined_rev_rev.fasta > MROT_ortho_combined_final.fasta
```
This is the final FASTA file and it is ready for alignment. However, make sure to check sequences with expassy and hand-check a few within the original CDS file. The EDIL FASTA doesn't contain start codons for many, so this is why the expassy doesn't work as well.

# Produce FASTA file with orthologous sequences

The orthologous sequences from each species was combined into a single file using the shell script ``` alignment_combine.sh ```. This shell finds orthologs from each species specific FASTA and places them into a file named after the AMEL protein ID (this has best annotations). Each sequence was named after the species using the format used in the [phylogeny](https://www.sciencedirect.com/science/article/pii/S1055790318304317#f0005). The order must also be correct in this shell script and the ortholog file. These names can differ so make sure they match the phylogeny you plan to use.

Phylogeny species names
```
GEN_apis_mellifera
GEN_bombus_impatiens
TR_tetragonula_carbonaria
GEN_megachile_rotundata
TR_euglossa_dilemma
```

# Alignment

Muscle was used for the alignment using the ```muscle.sh```. Within the shell, all stop codons were removed so the code could be run through HyPhy

# Pruning Phylogenetic Tree

The phylogenetic tree must only include species within the analysis. I used the ```ape``` package in R. 

```
install.packages("ape")
library(ape)

tree<-read.tree("/directory/file.tre")
species<-c("GEN_apis_mellifera","GEN_bombus_impatiens","GEN_megachile_rotundata")
pruned.tree<-drop.tip(tree,tree$tip.label[-match(species, tree$tip.label)])
write.tree(pruned.tree,"/directory/pruned.tree")
```

# Run Selection Analysis with Hyphy

I ran FEL in HyPhy using the shell ```hyphy.sh```. The parameters were standandard, except I set the p-value to 0.1. The output with be in a file.json. 

# Summarize Data

I extract dNdS and statistical summary using the R script ```json_extraction.R```.



