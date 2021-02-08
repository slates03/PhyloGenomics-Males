# Conserved Exon Identification

The Conserved Exons (CE) pipeline identifies conserved- and non-conserved sites within a protein alignment for a focal species against closely and more distantly-related taxa. The piepline makes use of OrthoDB v 9.1. This database contains orthologous proteins for 172 vertebrates, 133 arthropods, 227 fungi, 25 basal metazoans, 3663 bacteria and 31 plants. While a great resource, the database does change IDs and formats between iterations, so use extreme caution if you are applying this pipeline to any database beyond v9.1.

By downloading the peptide data, extracting relevant taxa, aligning the output, and outputing conservation scores, this pipeline identifies conserved peptides across a given phylogeny within known orthologs.

This workflow is rough (v0.01) at the moment and has some scripting steps I need to remove and assumptions I need to test.

# Requirements
- R 3.1 or higher, with the following packages installed:
  - taxize
- muscle 3.8.3
- Database files from OrthoDB v9.1:
  - odb9_species.tab
  - odb9_OG2genes.tab
  - odb9_fasta_metazoa.tgz (very large data set)

# Extract Orthologs
Orthologs were produced from a previous analysis, so I used this list for genes of interest. 

Filter Orholog list to include orthologs conserved across all corbiculate bees
``` 
awk '!/NA/' /depot/bharpur/data/ref_genomes/AMEL/resources/orthologs/orthologs > orthologs_fullrows
```
I then made an ortholog list for all bee species

Honey Bee -AMEL
``` 
awk '{print $2}' orthologs_fullrows > AMEL_ortho_2
``` 

Bombus terrestris -BTER

``` 
awk '{print $3}' orthologs_fullrows > BTER_ortho
``` 

Bombus impatiens -BIMP

``` 
awk '{print $4}' orthologs_fullrows > BIMP_ortho
``` 
Tetragonula carbonara 

``` 
awk '{print $5}' orthologs_fullrows > TCARB_ortho
``` 
Megachile rotundata -MROT

``` 
awk '{print $6}' orthologs_fullrows > MROT_ortho
``` 
Euglossa dilemma -EDIL

``` 
awk '{print $7}' orthologs_fullrows > EDIL_ortho
``` 

# Produce Species specific FASTA
Here, I make a new .fasta with the species of interest and the orthologs conserved across the bee species

## Make a FASTA file with only CDS sequences for .bed file
I convert the GFF to a GFT (non necessary really), and then extract only CDS (very necessary). I needed to produce a .bed file, but I could have produced this from the GFT

```
module load bioinfo
module load gffread 

gffread /depot/bharpur/data/projects/slater/genome/GCF_003254395.2_Amel_HAv3.1_genomic.gff -F -T -o GCF_003254395.2_Amel_HAv3.1_genomic_2.gft
awk '$3 == "CDS" {print $0}'  /depot/bharpur/data/projects/slater/genome/GCF_003254395.2_Amel_HAv3.1_genomic_2.gft > Amel_CDS.gft
```
## Make .bed file from CDS FASTA file
I made a .bed file by using the gft2bed, and then I converted the bed file to include 4 columns: 1)chromosome, 2)start, 3)end, 4)protein_id. The first 3 are necesssary, but the 4th I needed for the ortholog document


```
module load bioinfo
module load bedops


gtf2bed < Amel_CDS.gft > Amel_CDS.bed
awk '{ print $1 " " $2 " " $3 }' Amel_CDS.bed > Amel_CDS_1.bed
grep "protein_id$pattern" Amel_CDS.bed  | grep -o 'protein_id[^;]*'| sed 's/protein_id//g' > AMEL_protein_id
paste Amel_CDS_1.bed AMEL_protein_id > Amel_CDS_2.bed
```
For MROT, I made the .bed file straight from the GFT CDS file. I did something similar for EDIL, except I made it from the GFF and extracted "Parent" instead of protein_id. 

```
awk '{ print $1 " " $4 " " $5 }' MROT_CDS.gft > MROT_CDS_1.bed
grep "protein_id$pattern" MROT_CDS.gft  | grep -o 'protein_id[^;]*'| sed 's/protein_id//g' > MROT_protein_id
```

## CDS FASTA file
I made a CDS FASTA file, which I will need to produce sequence specific fasta. This includes cleaning and removing (i.e. remove ") and changing spaces to tabs, which is necessary for bedtools

```
awk -F"[:-]" 'BEGIN{ OFS="\t"; }{ print $1, $2, $3, $4;}' Amel_CDS_2.bed | sed 's/"//' | sed 's/"//' > Amel_CDS_final_1.bed
awk '{;$1=$1}1' OFS="\t" Amel_CDS_final_1.bed > Amel_CDS_final.bed
bedtools getfasta -fi /depot/bharpur/data/ref_genomes/AMEL/GCF_003254395.2_Amel_HAv3.1_genomic.fna -bed Amel_CDS_final.bed -name > AMEL_CDS.fasta
```
This tool verifies whether the document is tabs-delineated

```
cat -A Amel_CDS_final.bed| head
```



# ID Species of interest, extract genes
Here, I am extracting all Apis mellifera genes

```
grep 7460: odb9_OG2genes.tab > ortho_test_genes 
cut -f1 ortho_test_genes > orthoIDs
sort orthoIDs | uniq -u > orthoIDsuniq
```

# Extract gene(s) of interest and align
## Extract sequences
I first make a new .fasta with only species of interest

```
grep -A 1 -f  lower_spp_IDs /home/blencowe/blencowe31/harpurbr/orthodb/metazoa/metas.fs > focal.fs
```

I then extract sequences of interest

grep -f orthoIDsuniq  odb9_OG2genes.tab  > ortho_IDs	
./extract_fasta.sh


# Align
I use muscle v3.8 to align the orthologs. As of right now, I use default options, but this will be need to be optimized.

```
./muscle.sh
```

This results in an alignment file in .fasta format.

# Quantify conservation
I use [Capra and Singh's 2007](https://compbio.cs.princeton.edu/conservation/score.html) method to quantify conservation across the alignment


