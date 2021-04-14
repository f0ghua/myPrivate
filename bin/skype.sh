#!/bin/sh
m=$(ps -A|grep artsd)
if [ -z "$m" ];then
	artsd -d&
fi
artsdsp -m /usr/bin/skype&
