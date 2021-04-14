#!/bin/sh

proxyBin="/home/fog/soft/tool/3proxy-0.6.1/src/3proxy"
proxyCfgFile="/tmp/3proxy.cfg"

: ${ifaceWire:="eth0"}

ifaceTuns=(`ifconfig|grep "^tun"|cut -f 1 -d " "`)
ifaceTunnel=${ifaceTuns[0]}

ipWire=`/sbin/ifconfig ${ifaceWire} | grep -A 1  "${ifaceWire}" | grep -i "inet addr" | awk -F ":" '{print $2}' | awk '{print $1}'`;
ipTunnel=`/sbin/ifconfig ${ifaceTunnel} | grep -A 1  "${ifaceTunnel}" | grep -i "inet addr" | awk -F ":" '{print $2}' | awk '{print $1}'`;

cat <<EOF > ${proxyCfgFile}
daemon
auth iponly
log /var/log/3proxy.log D
rotate 5
#fakeresolve
#dnspr
#internal ${ipTunnel}
#allow * 127.0.0.1 *
allow *
#parent 1000 socks5+ 127.0.0.1 7777
#proxy -a -i127.0.0.1 -p3128
#proxy -a -i${ipWire} -p3128
#proxy -a -p3128
proxy
socks
EOF

killall -9 3proxy
sleep 1
$proxyBin $proxyCfgFile
