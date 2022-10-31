# HENNIG_LAB_TK_29

## Adapt the input files to point to the correct fastq files
Fastq files ahould be gzipped.

```
input_1.txt
input_2.txt
```
File *input_1.txt* should contain the full path to Forward read fastq files
File *input_2.txt* should contain the full path to Reverse read fastq files
Paths pointing to Fwd and Rev fastq files for a given sample should be in 
the same relative position in the input files.  

## Modify the parameters-hg19 file, if necessary

Change the *GENOME* variable so it points to the folder with the STAR genome DB
Adjust the *OVERHANG* variable to the read length used when building the database
(See genomeParameters.txt file in genome DB directory)   
set STEP1-5 variables to false if you want to skip one or more steps. Note: later steps depend on initial step results. Therefore, use these workflow control switches only to avoid rerunning some initial steps that have been already run or for testing purposes.     

## Adjust the run.swarm file if necessary

Change the date or name of the log file (LOG-20221025.log) within run.swarm: 

```
> cat run.swarm
#!/bin/sh
#$ -S /bin/sh

sh all-steps-hg19.sh parameters-hg19 input-1.txt input-2.txt *LOG-20221025.log*
```

## Start the swarm job by running the following command
```
swarm -f run.swarm -t 40 -g 60 --time 36:00:00 --qos=cv19
```
