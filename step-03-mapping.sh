#!/bin/sh
#$ -S /bin/sh

# read in input from command line
# parameter file
PARFILE=$1
source ./$PARFILE

# trimmed fastq
FULLFASTQF_1=$2
FULLFASTQF_2=$3

# output directory
MAPDIR=$4

if [ ! -d $MAPDIR ]; then
    mkdir -p -m 777 $MAPDIR
fi

# working directory
WD=`pwd`


FASTQF_1=`basename $FULLFASTQF_1`
BASEN_1=${FASTQF_1%.*}

FASTQF_2=`basename $FULLFASTQF_2`
BASEN_2=${FASTQF_2%.*}


mkdir -p -m 777 $MAPDIR"/"$BASEN_1

# mk link
ln -fs "../../"$FULLFASTQF_1 $MAPDIR"/"$BASEN_1"/"${FASTQF_1}
ln -fs "../../"$FULLFASTQF_2 $MAPDIR"/"$BASEN_1"/"${FASTQF_2}

cd $MAPDIR"/"$BASEN_1
echo $MAPDIR"/"$BASEN_1

STAR_OUT_B=$BASEN_1
STAR_OUT_SORT=$BASEN_1"_sorted"

INPUT_1=${AD}/$FULLFASTQF_1
INPUT_2=${AD}/$FULLFASTQF_2

echo $INPUT_1

WP=`pwd`


MAPPINGOUT=$WP"/"$STAR_OUT_SORT".bam"
echo $MAPPINGOUT > $AD/env_var5.txt

if [ "$STEP3" =  true ]; then
    cd $WP && STAR \
        --genomeDir ${GENOME} \ #/home/lorenziha/data/Lothar_Hennighausen/TK_29/2way_test/hg19/ \
	    --sjdbOverhang ${OVERHANG} \
	    --readFilesIn $INPUT_1 $INPUT_2 \
	    --outSAMtype BAM SortedByCoordinate \
	    --outFilterMultimapNmax 20 \
	    --outReadsUnmapped Fastx \
	    --runThreadN $STARTHR \
        --readFilesCommand zcat \
	    --outFileNamePrefix $STAR_OUT_B  > $BASEN"_star_$$.log" 2>&1

# 2-pass mapping
#--sjdbFileChrStartEnd 
#--twopassMode 


    ln -fs $STAR_OUT_B"Aligned.sortedByCoord.out.bam" $STAR_OUT_SORT".bam"
    #java -Xmx40g -jar $PICARDJARPATH/picard.jar SortSam INPUT=$STAR_OUT_B"Aligned.sortedByCoord.out.bam" \
	#    		OUTPUT=$STAR_OUT_SORT".bam" SORT_ORDER=coordinate

    $SAMTOOLS index $STAR_OUT_SORT".bam"
fi

if [ $CLEANUP != 0 ]; then
	rm -f $FASTQF
	rm -f $STAR_OUT_B
	rm -f $STAR_OUT_B"Aligned.sortedByCoord.out.bam"
fi

