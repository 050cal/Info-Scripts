#!/bin/bash

#error handling w/ command statements
if [ $# -eq 0 ]
    then
        echo "Usage: bash show.sh <processName>"
        exit 0
fi

#variables
PROCID=$(pidof $1)
USERTIME=$(echo "scale=2; $(cat /proc/$PROCID/stat | cut -d' ' -f14) / $(getconf CLK_TCK)" | bc)
SYSTIME=$(echo "scale=2; $(cat /proc/$PROCID/stat | cut -d' ' -f15) / $(getconf CLK_TCK)" | bc)
TOTAL=$(echo "scale=2; $USERTIME + $SYSTIME" | bc )

echo "Process $PROCID Information"
grep ctxt /proc/$PROCID/status       #nonvoluntary/voluntary ctxt switches
echo "User Time: $USERTIME"          #user time
echo "System Time: $SYSTIME"         #system time
echo "Total Time: $TOTAL"            #total time
echo "Start Time: $(ps -p ${PROCID} -o start | tr -dc '0-9,:')"