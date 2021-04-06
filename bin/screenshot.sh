#!/bin/bash

NOW=`date '+%Y%m%d'`
FNAME=img${NOW}
EXT=png

FN=$1
: ${FN:="$FNAME.${EXT}"} 
#cd /home/fog/Desktop/screenshots
#echo $FN
sleep 5

import $FN

#import -window root ${FNAME}.${EXT}

#convert -resize 400x300 ${FNAME}.${EXT} fvwm${NOW}_thumb.${EXT}

#mv fvwm${NOW}_thumb.${EXT} thumbs/



