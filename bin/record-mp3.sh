# record meeting script
#!/bin/sh
if [ $# == 0 ];then
	echo "Usage: $0 [project]"
	exit
fi
project=$1
date=$(date +%F)
fname="${project}-${date}"

echo recording to $fname.wav ...

#sox -t ossdsp -w -s -r 44100 -c 2 /dev/dsp -t raw - | lame -x -m s - $fname.mp3
sox -d -s -r 44100 -c 2 /dev/dsp -t raw - | lame -x -m s - $fname.mp3

