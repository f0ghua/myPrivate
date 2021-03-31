#!/bin/sh
REMAINING=$(cat /proc/acpi/battery/BAT0/state |grep remaining|cut -d " " -f 8)
LAST=$(cat /proc/acpi/battery/BAT0/info |grep last|cut -d " " -f 9)
PERCENT=$(wcalc ${REMAINING}/${LAST}*100)
#echo $REMAINING / $LAST 
#echo the battary remaining $PERCENT
out=${PERCENT##* }
out=${out%%.*}
echo $out%
