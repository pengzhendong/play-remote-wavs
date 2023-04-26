#!/bin/bash

if [ $# -lt 2 ] ; then
  echo "Usage: ./play.sh [user@]host:<wavs_dir> <wavlist> [start_index]"
  exit
fi

IFS=$'\n' read -d '' -r -a wavs < $2
i=0
if [ $# -eq 3 ] ; then
  i=$3
fi

while [ $i -lt ${#wavs[@]} ] ; do
  wav=${wavs[$i]}
  scp $1/$wav .
  sox $wav -d
  rm $wav
  echo "=================================================================="
  echo "Played ($((i+1))/${#wavs[@]}): $wav."
  echo "Press [r]eplay [n]ext [p]revious [q]uit"
  echo "=================================================================="
  read -rsn1 key
  if [ "$key" = "q" ] ; then
    exit
  elif [ "$key" = "n" ] ; then
    i=$((i+1))
    if [ $i -ge ${#wavs[@]} ]; then
      let i=${#wavs[@]}-1
      echo "=======================Reached end of list.======================="
    fi
  elif [ "$key" = "p" ] ; then
    i=$((i-1))
    if [ $i -lt 0 ]; then
      i=0
      echo "====================Reached beginning of list.===================="
    fi
  elif [ "$key" != "r" ] ; then
    echo "Unknown key: $key"
    exit
  fi
done
