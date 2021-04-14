#!/bin/sh

iface_list="eth0 wlan0"
iface_wire=eth0
iface_wireless=wlan0

ip_wire=`/sbin/ifconfig ${iface_wire} | grep -A 1  "$iface" | grep -i "inet addr" | awk -F ":" '{print $2}' | awk '{print $1}'`;

ip_wireless=`/sbin/ifconfig ${iface_wireless} | grep -A 1  "$iface" | grep -i "inet addr" | awk -F ":" '{print $2}' | awk '{print $1}'`;

net_wire=${ip_wire%.*}
net_wireless=${ip_wireless%.*}

case "${ip_wireless}" in
    192.*)
        echo "wireless interface ip: ${ip_wireless}"
        route del default gw ${net_wire}.248
        route add -net 172.0.0.0 netmask 255.0.0.0 gw ${net_wire}.248
        route add default gw ${net_wireless}.1
        ;;
    *)
        echo "NONE useful wireless found, wire net ${net_wire}"
        if [[ "${net_wire}" == "172.21.8" ]]; then
            route del default gw ${net_wire}.248
            route add default gw ${net_wire}.226
            route add -net 172.0.0.0 netmask 255.0.0.0 gw ${net_wire}.248
        fi
        ;;
esac

route -n
