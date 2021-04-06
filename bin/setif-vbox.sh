# user Host-only adapter to setup vbox network
echo "1">/proc/sys/net/ipv4/ip_forward
iptables -A POSTROUTING -t nat -s 192.168.56.101 -o wlan0 -j MASQUERADE

