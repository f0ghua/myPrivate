#!/bin/sh
i=$1
end=$2

while [ $i -le $end ]
  do
  ping -c 1 172.31.12.$i -w 1 > /dev/null
  case $? in
	#success
      1) echo "172.31.12.$i is free!";;
	#failure
      0) echo "172.31.12.$i is used,continue searching..."
      nmap -e eth1 -P0 -n -sT -p 4080 172.31.12.$i;;
      *) exit;;
  esac
  i=`expr $i + 1`
done
