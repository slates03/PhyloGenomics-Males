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

./vast-tools combine -o vast_out -sp Bim
