#!/bin/bash

if [ $# -lt 1 ] ; then
  echo "Usage: ./play.sh http://ip:port/wav.lst [start_id]"
  exit
fi

i=0
if [ $# -eq 2 ] ; then
  i=$(($2-1))
fi

curl $1 -o wav.lst
IFS=$'\n' read -d '' -r -a wavs < wav.lst
while [ $i -lt ${#wavs[@]} ] ; do
  IFS=' ' read -r -a array <<< ${wavs[$i]}
  wav="audio.wav"
  [ -e $wav ] && rm $wav
  curl ${array[0]} -o $wav
  echo "=================================================================="
  echo "($((i+1))/${#wavs[@]}): ${array[0]}"
  if [ ${#array[@]} -eq 1 ] ; then
    echo "=================================================================="
    sox $wav -d
  elif [ ${#array[@]} -eq 2 ] ; then
    echo ${array[1]}
    echo "=================================================================="
    sox $wav -d
  elif [ ${#array[@]} -eq 3 ] ; then
    echo "=================================================================="
    sox $wav -d trim ${array[1]} ${array[2]}
  elif [ ${#array[@]} -eq 4 ] ; then
    echo ${array[3]}
    echo "=================================================================="
    sox $wav -d trim ${array[1]} ${array[2]}
  fi
  echo "Press [r]eplay [n]ext [p]revious [q]uit"
  read -rsn1 key
  if [ "$key" = "q" ] ; then
    exit
  elif [ "$key" = "n" ] ; then
    i=$((i+1))
    if [ $i -ge ${#wavs[@]} ]; then
      let i=${#wavs[@]}-1
      echo "!!!!Reached end of list!!!!"
    fi
  elif [ "$key" = "p" ] ; then
    i=$((i-1))
    if [ $i -lt 0 ]; then
      i=0
      echo "!!!!Reached beginning of list!!!!"
    fi
  elif [ "$key" != "r" ] ; then
    echo "Unknown key: $key"
    exit
  fi
done
