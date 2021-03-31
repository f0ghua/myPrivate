#!/bin/sh

# convert from flv to avi
IF=$1
OF=$2

n=$(echo $IF | tr A-Z a-z)
IFEXT=${n##*.}

n=$(echo $OF | tr A-Z a-z)
OFEXT=${n##*.}

echo "converting media file from $IFEXT to $OFEXT ..."

if [ "$IFEXT" = wma ] && [ "$OFEXT" = mp3 ]
then
mplayer -ao pcm:file=tmp.wav $IF && lame -h tmp.wav $OF && rm -f tmp.wav
fi

if [ "$IFEXT" = amr ] && [ "$OFEXT" = mp3 ]
then
mplayer -ao pcm:file=tmp.wav $IF && lame -h tmp.wav $OF && rm -f tmp.wav
fi

if [ "$IFEXT" = avi ] && [ "$OFEXT" = avi ]
then
    mencoder $IF -ovc xvid -oac mp3lame -srate 8000 -xvidencopts fixed_quant=4 -o $OF
fi

if [ "$IFEXT" = avi ] && [ "$OFEXT" = flv ]
then
    ffmpeg -i $IF -aspect 4:3 -b 900k -r 29 -f flv -s 434x326 -acodec libmp3lame -ar 44100 -ab 56 $OF
fi

if [ "$IFEXT" = wmv ] && [ "$OFEXT" = flv ]; then
    mencoder $IF -ffourcc FLV1 -of lavf -ovc lavc -lavcopts vcodec=flv:acodec=mp3:abitrate=56 -srate 22050 -oac mp3lame -o $OF
fi

if [ "$IFEXT" = asf ] && [ "$OFEXT" = flv ]; then
    ffmpeg -i $IF -ab 56 -ar 22050 -b 500 -r 15 -s 320×240 $OF
fi

if [ "$IFEXT" = avi ] && [ "$OFEXT" = mpg ]
then
    ffmpeg -i $IF -target vcd $OF
fi

if [ "$IFEXT" = wmv ] && [ "$OFEXT" = avi ]
then
#    mencoder $IF -ofps 23.976 -ovc lavc -oac copy -o $OF

    mencoder $IF -ofps 23.976 -oac mp3lame -ovc xvid -xvidencopts pass=1 -o /dev/null
    mencoder $IF -ofps 23.976 -oac mp3lame -lameopts abr:br=64 -ovc xvid -xvidencopts pass=2:bitrate=250 -o $OF
fi

if [ "$IFEXT" = avi ] && [ "$OFEXT" = mp4 ]
then
#    ffmpeg -i $IF -acodec libfaac -ab 128k -ac 2 -vcodec libx264 -vpre slowfirstpass -crf 22 -threads 0 $OF
    ffmpeg -i $IF -pass 1 -vcodec libx264 -vpre fast_firstpass -b 512k -bt 512k -threads 0 -f rawvideo -an -y /dev/null && ffmpeg -i $IF -pass 2 -acodec libfaac -ab 128k -ac 2 -vcodec libx264 -vpre fast -b 512k -bt 512k -threads 0 $OF
#    ffmpeg -y -i $IF -an -v 1 -threads 0 -vcodec libx264 -deinterlace -b 5000k -bt 175k -flags +loop -coder ac -refs 1 -loop 1 -deblockalpha 0 -deblockbeta 0 -parti4x4 1 -partp8x8 1 -me epzs -subq 1 -me_range 21 -chroma 1 -slice 2 -bf 3 -b_strategy 1 -level 30 -g 300 -keyint_min 30 -sc_threshold 40 -rc_eq 'blurCplx^(1-qComp)' -qcomp 0.7 -qmax 51 -qdiff 4 -i_qfactor 0.71428572 -maxrate 5000k -bufsize 2M -cmp 1 -s 720x480 -f mp4 -pass 1 /dev/null
#    ffmpeg -y -i $IF -v 1 -threads 0 -vcodec libx264 -deinterlace -b 5000k -bt 175k -flags +loop -coder ac -refs 5 -loop 1 -deblockalpha 0 -deblockbeta 0 -parti4x4 1 -partp8x8 1 -me full -subq 6 -me_range 21 -chroma 1 -slice 2 -bf 3 -b_strategy 1 -level 30 -g 300 -keyint_min 30 -sc_threshold 40 -rc_eq 'blurCplx^(1-qComp)' -qcomp 0.7 -qmax 51 -qdiff 4 -i_qfactor 0.71428572 -maxrate 5000k -bufsize 2M -cmp 1 -s 720x480 -acodec libfaac -ab 256k -ar 48000 -ac 2 -f mp4 -pass 2 $OF

#    ffmpeg -y -i $IF -vcodec libx264 -vpre -default $OF
#    ffmpeg -y -i $IF -vcodec libx264 -vpre hq -threads 0 $OF
#    ffmpeg -i $IF -acodec libfaac -ab 96k -vcodec libx264 -vpre hq -crf 22 -threads 0 $OF
#    ffmpeg -i $IF -f h264 -vcodec libx264 -s 672x576 -r 25 $OF
#    ffmpeg -y -i $IF -acodec libfaac -ar 22050 -ab 64k -vcodec libx264 -b 250k -s 320×240 -aspect 4:3 $OF    
fi
