#!/bin/bash
#FILENAME: Slater_HB_RNAseq
#SBATCH -A lenders
#SBATCH -n 1
#SBATCH -t 75:00:00

# load the modules
	module load bioinfo
	module load R
	module load bowtie

	cd /depot/bharpur/apps/vast-tools

k=$1
pidlist_sampe=""
endfq="_1.fq.gz"
endfq2="_2.fq.gz"
fq1=$k$endfq
fq2=$k$endfq2
end="VASToutput_"
end2=$end$k

./vast-tools align /depot/bharpur/data/projects/slater/Phylo_MaleEvolution/RNASeq/TCARB_Male_RNAseq/$fq1 /depot/bharpur/data/projects/slater/Phylo_MaleEvolution/RNASeq/TCARB_Male_RNAseq/$fq2 -sp Tec --expr --expr $end2

echo " "