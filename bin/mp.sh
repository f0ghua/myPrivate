#!/bin/sh
#mplayer $1 -font /usr/share/fonts/optional/fzyuanti/fzy.ttf -subcp cp936 -subfont-text-scale 3
mplayer -vf expand=0:-50:0:0 $1
