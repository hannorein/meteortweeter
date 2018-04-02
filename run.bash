#!/bin/bash
rm -rf todaysmeteors
mkdir todaysmeteors
DIRNAME=`date -u +'%Y%m%d'`
#DIRNAME='20180401'
#scp hrein@142.1.98.162:~/events/$DIRNAME/\*.avi todaysmeteors
scp hrein@rein008.utsc.utoronto.ca:~/events/$DIRNAME/\*.mp4 todaysmeteors
LATESTPROC=`cat latest.txt`
LATEST=`ls todaysmeteors | tail -n 1`
LATESTLEN=${#LATEST} 
if [ "$LATESTPROC" == "$LATEST" ]; then
    echo "no new match"
else
    if [ "$LATESTLEN" -lt "5" ]; then
        echo "no new files"
    else
        echo "new match"
        echo "$LATEST" >latest.txt
        avconv -y -re -r:v 25  -i todaysmeteors/$LATEST -s 640x480 latest.mp4
        ./uploadVideoToTwitter.bash
    fi
fi
