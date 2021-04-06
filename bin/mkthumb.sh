#!/bin/sh

set -e # exit on any error

THUMBSIZ="480x270" #"64x48"
SECONDS="2"

INPUT=$1

if [ ! -z "$2" ]; then
  SECONDS=$2
fi

THUMB="${INPUT%.*}.jpg"

if [ -f "$THUMB" ]; then
  echo "Recreating by increasing thumb value by 3 sec"
  SECONDS=$(($SECONDS + 3))
  rm -f "$THUMB"
fi

ffmpeg -y -ss $SECONDS -i $INPUT -vcodec mjpeg -vframes 1 -an -f rawvideo -s $THUMBSIZ $THUMB
exit

echo "=== Processing $input ==="
echo -ne "Step 1: extracting frame ...\t"
mplayer -ss $SECONDS -nosound -vo jpeg -frames 2 "$INPUT" > /dev/null 2>&1 \
   && echo "[ OK ]" || echo "[ FAIL ]";

echo -ne "Step 2: renaming thumb ...\t"
OUTPUT=`ls -t 00000*.jpg | tail -1`

convert -resize $THUMBSIZ "$OUTPUT" "$THUMB" \
    && echo "[ OK ]" || echo "[ FAIL ]"

#mv "$OUTPUT" "$THUMB" && echo "[ OK ]" || echo "[ FAIL ]"

rm -f 00000*.jpg
