# HENNIG_LAB_TK_29

# ADAPT THE INPUT FILE
### be careful, that you have the same order!!!
```
input_1.txt
input_2.txt
```

# ADAPT THE run.swarm FILE

## change the date of the log file within run.swarm 
```
> cat run.swarm
#!/bin/sh
#$ -S /bin/sh

sh all-steps-hg19.sh parameters-hg19 input-1.txt input-2.txt LOG-20221025.log
```

# START THE SWARM JOB (2hr/sample)
```
swarm -f run.swarm -t 40 -g 60 --time 36:00:00 --qos=cv19
```
