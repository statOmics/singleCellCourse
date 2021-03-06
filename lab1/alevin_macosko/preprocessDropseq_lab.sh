#!/bin/sh

## get fasta
### Too large to download from net in this session; we work with reduced dataset
wget https://raw.githubusercontent.com/statOmics/singleCellCourse/practical1/lab1_preprocessing/alevin_macosko/SRR1853178_1_subsampled40k.fastq

wget https://raw.githubusercontent.com/statOmics/singleCellCourse/practical1/lab1_preprocessing/alevin_macosko/SRR1853178_2_subsampled40k.fastq

## For the full data, we would do
## wget https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR1853178/SRR1853178
## /Applications/sratoolkit.2.11.1-mac64/bin/fasterq-dump SRR1853178

### download transcriptome
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M27/gencode.vM27.transcripts.fa.gz

## build salmon index from transcriptome
salmon index -t gencode.vM27.transcripts.fa.gz -i gencode.vM27.transcripts_index -k 31 --gencode

## download GTF
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M27/gencode.vM27.annotation.gtf.gz
### create tx2gene using GTF
bioawk -c gff '$feature=="transcript" {print $group}' <(gunzip -c gencode.vM27.annotation.gtf.gz) | awk -F ' ' '{print substr($4,2,length($4)-3) "\t" substr($2,2,length($2)-3)}' - > txp2gene.tsv

## quantify subsample
salmon alevin -l ISR \
 -1 SRR1853178_1_subsampled40k.fastq \
 -2 SRR1853178_2_subsampled40k.fastq \
 --dropseq \
 -i gencode.vM27.transcripts_index \
 -p 1 \
 -o SRR1853178_out_40k \
 --tgMap txp2gene.tsv

#  preprocessDropseq_lab.sh
#  
#
#  Created by Koen Van den Berge on 11/5/21, adapted by Jeroen Gilis on 11/23/21
#
