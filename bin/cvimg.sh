#!/bin/bash
FILE="$1"
PREFIX=${FILE%%.*}
EXT=${FILE##*.}
#echo $PREFIX $EXT
#convert $FILE $PREFIX.jpg
convert -resize 400x300 "$FILE" "$PREFIX.jpg"
