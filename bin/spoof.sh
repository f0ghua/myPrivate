#!/bin/sh
#
# ED and BT are always not permited at a company,because they use too
# much bandwidth.MIS monitor the ip or mac address to find out who
# is using such a software.
# 
# This script make your computer spoofed by ip and mac address,so you
# will never be catched out :)
#
# You need be root to run the script!
#

i=$(($RANDOM%120))
end=200
nif=eth0

# generate a spoof mac address
mc0=00
mc1=30
j=2
while [ $j -le 5 ];do
    v=0
    while [[ $v -le 16 ]];do v=$(($RANDOM%255)); done;
    eval mc$j=`echo "obase=16;$v"|bc`
    ((j = j + 1))
done

echo "spoof MAC:$mc0:$mc1:$mc2:$mc3:$mc4:$mc5"

# search the free ip address to use
while [ $i -le $end ]; do
  sudo arping -c 1 172.31.12.$i > /dev/null
  case $? in
	# success to find a free entry
      1) 	echo "172.31.12.$i is free!";
		#ifconfig $nif hw ether 
	  break;;
	# failure
      0) 	echo "172.31.12.$i is used,continue searching...";;
      *) 	exit;;
  esac
  i=`expr $i + 1`
done

ifconfig $nif down
ifconfig $nif hw ether $mc0:$mc1:$mc2:$mc3:$mc4:$mc5
ifconfig $nif up
ifconfig $nif 172.31.12.$i netmask 255.255.255.0
route add default gw 172.31.12.249
