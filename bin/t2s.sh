#!/bin/sh
i=0
n=$1
f=$2
SP=' '
while((i<n));do SP=${SP}' ';((i++));done
cat $f|sed -e "s/\t/${SP}/g"
