#!/bin/sh
#$ -S /bin/sh

# read in input from command line
# parameter file
PARFILE=$1
source ./$PARFILE

# raw fastq
FULLRAWFASTQ_1=$2
FULLRAWFASTQ_2=$3

# output directory
TRIMMINGOUT=$4

if [ ! -d $TRIMMINGOUT ]; then
    mkdir -p -m 777 $TRIMMINGOUT
fi

# working directory
WD=`pwd`

# get needed file names
FASTQ_1=`basename $FULLRAWFASTQ_1`
BASEN_1=${FASTQ_1%.*}

FASTQ_2=`basename $FULLRAWFASTQ_2`
BASEN_2=${FASTQ_2%.*}

# generate symbol link
ln -s "../"$FULLRAWFASTQ_1 $TRIMMINGOUT"/"$FASTQ_1
ln -s "../"$FULLRAWFASTQ_2 $TRIMMINGOUT"/"$FASTQ_2


OUT_1_PAIRED=$TRIMMINGOUT"/clean-"$BASEN_1"-paired.fastq.gz"
OUT_2_PAIRED=$TRIMMINGOUT"/clean-"$BASEN_2"-paired.fastq.gz"

OUT_1_UNPAIRED=$TRIMMINGOUT"/clean-"$BASEN_1"-unpaired.fastq.gz"
OUT_2_UNPAIRED=$TRIMMINGOUT"/clean-"$BASEN_2"-unpaired.fastq.gz"

HELPERPATH_1=$OUT_1_PAIRED
HELPERPATH_2=$OUT_2_PAIRED

echo $HELPERPATH_1 > $AD/env_var1.txt
echo $HELPERPATH_2 > $AD/env_var2.txt
echo $OUT_1_UNPAIRED > $AD/env_var3.txt
echo $OUT_2_UNPAIRED > $AD/env_var4.txt

if [ "$STEP2" = true ]; then
    java -jar $TRIMMOJAR $READ -threads $THREADS $FULLRAWFASTQ_1 $FULLRAWFASTQ_2 $OUT_1_PAIRED $OUT_1_UNPAIRED $OUT_2_PAIRED $OUT_2_UNPAIRED $ADAPTER $LEADING $HEADCROP $TRAILING $SLIDINGWINDOW $MINLEN
fi

if [ $CLEANUP != 0 ]; then
	rm -f $FASTQ
fi
