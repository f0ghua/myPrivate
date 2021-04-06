#!/bin/sh

if [[ $1 == "" ]];then
	echo "please provide the ip address!"
	exit -1;
fi
args="$1"
ip=${args%%/*}
mask=${args##*/}
pre_mask=${pre_mask%.*}
mask_lo=${mask##*.}
last_octet=${ip##*.}
pre_octets=`expr match "$ip" '\(.*\.\)'`
#echo $pre_mask $mask
if [[ "$mask" == "$pre_mask" ]];then
	i=0;mask_lo=1;num=$((8+pre_mask-32))
	echo $num
	while [[ $i < $num ]];do
		mask_lo=$((mask_lo*2))
		((i++))
	done
	mask=${pre_octets}${mask_lo}
fi
pl1=$((256 - mask_lo))
# network last octet
net_lo=$((last_octet / pl1 * pl1))
# broadcast last octet
bdc_lo=$((net_lo + pl1 - 1))
network_addr=${pre_octets}${net_lo}
broadcast_addr=${pre_octets}${bdc_lo}
pcs=$((bdc_lo - net_lo + 1))

line="---------------------------------------"
echo $line
echo
echo "ip address:		$ip"
echo "network address:	${network_addr}"
echo "broadcast address:	${broadcast_addr}"
echo
echo "subnet mask:		$mask"
echo "pc numbers:		$pcs"
echo
echo $line

