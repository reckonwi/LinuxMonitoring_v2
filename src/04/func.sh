#!/bin/bash

function date_generate {
  DATE=()
  for ((i=$1; i>=1; i--))
  do
    DATES+=($(date --date="$i days ago" +%d/%b/%Y))
  done
  echo ${DATES[@]}
}

function ip_generate {
  IP=$(shuf -i 1-255 -n 1).$(shuf -i 0-255 -n 1).$(shuf -i 0-255 -n 1).$(shuf -i 1-254 -n 1)
  echo $IP
}

function convert_time {
  TIME=$1
  HOURS=$(printf "%02d" $(($TIME/3600)))
  TIME=$((TIME % 3600))
  MINUTES=$(printf "%02d" $(($TIME/60)))
  TIME=$((TIME % 60))
  SECONDS=$(printf "%02d" $(($TIME%60)))
  OUTPUT=$HOURS:$MINUTES:
  if [[ $SECONDS -lt 10 ]]
  then
    OUTPUT+=0
  fi
  OUTPUT+=$SECONDS
  echo $OUTPUT
}