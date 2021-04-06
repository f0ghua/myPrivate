#!/bin/bash

killall lv2tc > /dev/null 2>&1

iface_list="eth0 wlan0"
iface_wire="eth0"
iface_wlan="wlan0"

lv2t_path=/home/fog/private/tool/lv2t

ip_wire=`/sbin/ifconfig ${iface_wire} | grep -A 1  "${iface_wire}" | grep -i "inet addr" | awk -F ":" '{print $2}' | awk '{print $1}'`;
ip_wlan=`/sbin/ifconfig ${iface_wlan} | grep -A 1  "${iface_wlan}" | grep -i "inet addr" | awk -F ":" '{print $2}' | awk '{print $1}'`;

#if [ "${ip_wire}" != "" -o "${ip_wire}" != 192.168.* ];then
#    iface="eth0"
#else
#    iface="wlan0"
#fi
iface=`route -n -v|grep "^0.0.0.0"|sed 's/ \+/ /g'|cut -f 8 -d " "`

if [ ! -z $1 ]; then
    iface=$1
fi

if [ "$iface" != "${iface_wire}" ] && [ "$iface" != "${iface_wlan}" ];then
       echo "interface error"	
       exit
fi
local_ip=`/sbin/ifconfig $iface | grep -A 1  "$iface" | grep -i "inet addr" | awk -F ":" '{print $2}' | awk '{print $1}'`;
local_net=${local_ip%.*}

echo "use ${iface} with local network ${local_net}"
#exit
return_string=`ping f0g.homeunix.net -c 1 -t 1`
server_ip=`echo ${return_string}|sed 's/.*f0g\.homeunix\.net (\([^)]*\)).*/\1/'`
echo "f0g.homeunix.net: <${server_ip}>"
#exit

${Q} ${lv2t_path}/lv2tc -i $iface -s f0g.homeunix.net -p 123 >/dev/null &

sleep 5

GW1=${local_net}.248
GW2=${local_net}.200
#GW=${local_net}.254
#GW=172.21.8.248
#GW=172.26.240.248
#GW=172.26.10.248
#GW=172.21.11.248

${Q} route del default gw $GW1
${Q} route add default dev tun0
${Q} route add -net ${server_ip} netmask 255.255.255.255 gw $GW1
${Q} route add -net 172.0.0.0 netmask 255.0.0.0 gw $GW1
${Q} route add -net 172.21.67.0 netmask 255.255.255.0 gw $GW2

#route add -net 172.31.0.0 netmask 255.255.0.0 gw $GW

# QQ
#route add -net 219.133.0.0 netmask 255.255.0.0 gw $GW
