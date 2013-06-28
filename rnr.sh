#!/bin/bash
#JOB:    Track execution time of argument param $1 and send email when job is complete to argument param $2
#AUTHOR: Cameron S. Embree
#EDITED: 21-June-2013

USAGE=0         #flag for confirming if minimum amount of arguments were provided 
SPACE=" "       #used for formatting
COUNT=0         #counter for interating through parameters passed to script
ARGUMENTS=      #holder for all arguments passed to the script

#Retrieve and parse arguments to this script
for ARG in "$@"
do
    case "$COUNT" in
    0)
        EMAIL=$1
        echo "REPORT EMAIL WILL BE SENT TO: '$EMAIL'"
        ;;
    1)
        EXECUTABLE=$2
        USAGE=1 #minimum requirments to run have been met
        echo "EXECUTABLE TO RUN WILL BE:    '$EXECUTABLE'"
        ;;
    *)
        ARGUMENTS=$ARGUMENTS$SPACE$ARG
        ;;
    esac
    COUNT=$(($COUNT + 1))
done


#Run executable or tell script usage depending on what arguments were provided earlier
if [ $USAGE = 1 ]; then
    START=`date +%s`
    time $EXECUTABLE$ARGUMENTS 
    END=`date +%s`
    RUNTIME=$((END-START))
    
    echo "Execution of '$EXECUTABLE$ARGUMENTS' finished. RUNTIME: $RUNTIME secs." | mail -s "JOB '$EXECUTABLE' COMPLETE" $EMAIL
    echo "Job complete, email confirmation sent to $EMAIL."
else
    echo "USAGE: Provide 1st arg email to REPORT to; 2nd arg executable to RUN. EX: sh rnr.sh CSEmbree@gmail.com ./exec arg1 arg2 ..."
fi
