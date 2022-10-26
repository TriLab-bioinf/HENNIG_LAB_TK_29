#!/bin/sh
#$ -S /bin/sh


# LOAD MODULES
module load htseq
module load samtools



# read in input from command line
# parameter file
PARFILE=$1

# bam files
MAPREADS=$2

# output file
MAPDIR=$3

# load parameters
source ./$PARFILE


# make working path
mkdir -p $MAPDIR

WD=`pwd`

FASTQF=`basename $MAPREADS`
BASEN=${FASTQF%.*}


cd $MAPDIR


htseq-count -i $ATTR -r $POS -t $FEAT -f $FORMAT -s $STRAND $MAPREADS $GTF >  $BASEN".txt"

