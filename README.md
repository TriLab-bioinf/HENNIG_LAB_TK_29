# HENNIG_LAB_TK_29

## Adapt the input files to point to the correct fastq files
#### be careful, that you have the same order!!!
```
input_1.txt
input_2.txt
```
## Modify the parameters-hg19 file

Change the GENOME variable so it points to the folder with the STAR genome DB
Adjust the OVERHANG variable to the read length used when building the database
(See genomeParameters.txt file in genome DB directory)   

## Adapt the run.swarm file

#### change the date of the log file within run.swarm 
```
> cat run.swarm
#!/bin/sh
#$ -S /bin/sh

sh all-steps-hg19.sh parameters-hg19 input-1.txt input-2.txt LOG-20221025.log
```

## Start the swarm job
```
swarm -f run.swarm -t 40 -g 60 --time 36:00:00 --qos=cv19
```
