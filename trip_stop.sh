#!/bin/bash
#FILENAME: Slater_HB_RNAseq
#SBATCH -A lenders
#SBATCH -n 1
#SBATCH -t 75:00:00

module load bioinfo
module load muscle


filename=Gene_list_4
exec 4<$filename
echo $filename
echo Start
while read -u4 k || [ -n "$k" ]; do
pidlist_sampe=""


k=$k
pidlist_sampe=""
endAfq="_aligned_3.fasta"
end="_aligned_4.fasta"

TP1=$k$endAfq
TPQ=$k$end


sed 's/$/ /' $TP1 | sed 's/TAG //I' | sed 's/TAA //I' | sed 's/TGA //I' > $TPQ

done