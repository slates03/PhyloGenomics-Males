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

# Extract ORTHODB IDs
I've provided an R script that extracts the relevant taxonomic levels of all species within orthodb v9.1 using taxize. It is important to check the output of this file by eye before proceeding. Occasionally, taxize can misplace taxonomic levels (e.g. Loa loa is apparently a Hymenopteran).

``` 
output_taxa.r 
```

Depending on how you've run this script, it will output species lists for you to check and continue with that looks like this (focal_spp)

```
7460 Apis mellifera 12101 83040 C
7461 Apis cerana 8915 64537 C
7462 Apis dorsata 10452 75545 C
7463 Apis florea 11816 80899 C
7493 Trichogramma pretiosum 11988 43779 C
The first column contains the OrthoDB species ID and the second is the species name and can be cut out of the file (in this case, by file is 'lower_spp').
```
```
cut -f1 -d' ' lower_spp > lower_spp_IDs
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


