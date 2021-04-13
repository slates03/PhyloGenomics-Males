#!/bin/bash
#FILENAME: Slater_HB_RNAseq
#SBATCH -A lenders
#SBATCH -n 1
#SBATCH -t 75:00:00

module load bioinfo
module load muscle


filename=Gene_list_2
exec 4<$filename
echo $filename
echo Start
while read -u4 k || [ -n "$k" ]; do
pidlist_sampe=""

k=$k
pidlist_sampe=""

end="_aligned_2.fasta"
endAfq="_aligned_3.fasta"

TPQ=$k$end
TP1=$k$endAfq

sed 's/-/ /g' $TPQ | sed 's/ //g' | sed -r '/^\s*$/d' > $TP1


done