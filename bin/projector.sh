#!/bin/bash
# change display settings to clone mode, 1024x768 pix for VGA and  projector
xrandr --output VGA1 --off
xrandr --output LVDS1 --off
xrandr --fb 1024x768 
xrandr --output VGA1 --mode 1024x768 --rate 60
xrandr --output LVDS1 --mode 1024x768 --same-as VGA1 --auto --scale 1x1 --panning 0x0
