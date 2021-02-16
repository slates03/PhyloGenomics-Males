#!/bin/bash
#FILENAME: Slater_HB_RNAseq
#SBATCH -A lenders
#SBATCH -n 1
#SBATCH -t 75:00:00


filename=gene_list
exec 4<$filename
echo $filename
echo Start
while read -u4 k || [ -n "$k" ]; do
pidlist_sampe=""

module load bioinfo
module load muscle

k=$k
pidlist_sampe=""
endfq=".fasta"
endAfq="_aligned.fasta"
end="_aligned_2.fasta"

fq1=$k$endfq
TP1=$k$endAfq
TPQ=$k$end


muscle -in $fq1 -out $TP1

sed 's/$/ /' $TP1 | sed 's/TAG /---/I' | sed 's/TAA /---/I' | sed 's/TGA /---/I' | sed 's/ //g' > $TPQ

done
