#!/bin/sh

## get fasta
wget https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR1853178/SRR1853178
/Applications/sratoolkit.2.11.1-mac64/bin/fasterq-dump SRR1853178


### index transcriptome self
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M27/gencode.vM27.transcripts.fa.gz
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/Applications/salmon/lib ## specify dyld path
/Applications/salmon/bin/salmon index -t gencode.vM27.transcripts.fa.gz -i gencode.vM27.transcripts_index -k 31 --gencode
### create tx2gene using GTF
bioawk -c gff '$feature=="transcript" {print $group}' <(gunzip -c gencode.vM27.annotation.gtf.gz) | awk -F ' ' '{print substr($4,2,length($4)-3) "\t" substr($2,2,length($2)-3)}' - > txp2gene.tsv


## quantify
/Applications/salmon/bin/salmon alevin -l ISR \
 -1 SRR1853178_1.fastq \
 -2 SRR1853178_2.fastq \
 --dropseq \
 -i gencode.vM27.transcripts_index \
 -p 1 \
 -o SRR1853178_out \
 --tgMap txp2gene.tsv


#  preprocessDropseq.sh
#  
#
#  Created by Koen Van den Berge on 11/5/21.
#  


# Junk
### download tgmap
#wget -O tgMap.gz http://refgenomes.databio.org/v3/assets/archive/0f10d83b1050c08dd53189986f60970b92a315aa7a16a6f1/tgMap
#gunzip tgMap.gz
### remove first line of resulting tgMap file

## get index and tgmap from refgenie
#wget -O mm10SalmonIndex.gz http://refgenomes.databio.org/v3/assets/archive/0f10d83b1050c08dd53189986f60970b92a315aa7a16a6f1/salmon_sa_index
#gunzip mm10SalmonIndex.gz
#
#wget -O mm10tgMap.gz http://refgenomes.databio.org/v3/assets/archive/0f10d83b1050c08dd53189986f60970b92a315aa7a16a6f1/tgMap
#gunzip mm10tgMap.gz
