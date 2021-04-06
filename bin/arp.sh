#!/bin/sh
i=$1
end=$2
nif=eth0

while [ $i -le $end ]
do
sudo arping -I $nif -c 1 172.31.12.$i > /dev/null
case $? in
	#success
	1) echo "172.31.12.$i is free!";break;;
	#failure
	0) echo "172.31.12.$i is used,continue searching...";;
	*) exit;;
esac
i=`expr $i + 1`
done
