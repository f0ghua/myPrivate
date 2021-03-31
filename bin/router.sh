#!/bin/sh


#!/bin/sh

wlanInf="wlan0"
elanInf="eth0"

CHOICE=$1

case $CHOICE in
    0) 	echo "set up home vpn network"

        route del default dev tun0
        route add default gw 192.168.1.1
        route add -net 172.0.0.0 netmask 255.0.0.0 gw 172.26.100.248

        ;;
    1)
        ifconfig eth0 192.168.0.2
        #route add -net 10.0.0.0 netmask 255.0.0.0 gw 192.168.0.1
        #route add -net 172.0.0.0 netmask 255.0.0.0 gw 192.168.2.1
        route add -net 172.0.0.0 netmask 255.0.0.0 dev wlan0
        route del default gw 192.168.2.1
        route add default gw 192.168.0.1
        ;;
    *)
        ;;
esac

