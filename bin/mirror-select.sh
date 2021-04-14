#!/bin/bash

if [[ $# < 2 ]]; then
    echo "USAGE: mirror-select.sh <mirror file> <little file path>"
    exit
fi

MIRROR_SITE_FILE="$1"
URL="$2" #/kernel/COPYING" #"/kernel/v2.6/linux-2.6.35.tar.bz2"

TIME="/usr/bin/time -o timer.txt -f %e"
WGET="wget --cache=off -T 20 -t 1 -w 0 -O /dev/null"
PAYTIME=1000
TEMPTIME=1000

SITE="NONE"

while read -r mirror; do
  echo "Testing $mirror ..."

  TEMPTIME=$($TIME $WGET $mirror$URL)
  if [ "$?" = 0 ] ; then
    TEMPTIME=$(cat timer.txt)
    echo "wget $1: $TEMPTIME CurrMinTime: $PAYTIME"
    TEMPTIME2=$(echo "$PAYTIME> $TEMPTIME"|bc)
    if [ $TEMPTIME2 = 1 ] ; then
      PAYTIME=$TEMPTIME
      SITE=$mirror
      echo "Set best site($PAYTIME): $SITE"
    fi
  fi
  rm timer.txt
done < ${MIRROR_SITE_FILE}

echo "fatest mirror is $SITE, enjoy!"
