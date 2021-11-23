#!/bin/sh

## get salmon index
wget ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh37.75.cdna.all.fa.gz
salmon index -t Homo_sapiens.GRCh37.75.cdna.all.fa.gz  -i salmonIndex_Hs37_75

## get FASTA
awk '{print $8}' filereport_read_run_PRJEB14362_tsv.txt > fastq_ids.tsv
echo "$(tail -n +2 fastq_ids.tsv)" > fastq_ids.tsv
sed -n -e '1,10p' fastq_ids.tsv > fastq_ids_subset.tsv

counter=1
while read s; do

  echo $s

  var1=$(echo $s | cut -f1 -d';')
  var2=$(echo $s | cut -f2 -d';')

  wget -O fastq_1.fastq.gz $var1
  wget -O fastq_2.fastq.gz $var2

  salmon quant -i salmonIndex_Hs37_75 --gcBias --seqBias --dumpEq -l A -1 fastq_1.fastq.gz -2 fastq_2.fastq.gz -o file_${counter}

  rm fastq_1.fastq.gz;   rm fastq_2.fastq.gz

  counter=$((counter+1))

done <fastq_ids_subset.tsv
