#!/bin/sh

if [[ $1 == "" ]];then
	echo "$0 [pc number]"
	exit -1;
fi

ip="192.168.0.0"
ip_a=${ip%.*}
ip_z=${ip##*.}

ipcnt=$(($1 + 2))
for ((bits = 0 ; 2 ** bits < ipcnt ; bits++));do :;done
netblock=$((2 ** bits))
slash=$((32 - bits))

if(( bits <= 8 ));then
	oct1=255;oct2=255;oct3=255
	oct4=$((256 - netblock))
else
	echo "Sorry,we just support class C now!"
	exit -1
fi

#echo $ipcnt $bits $netblock $slash $ip_a $ip_z
#echo $oct1.$oct2.$oct3.$oct4/$slash

llen=72
ch1='#';ch2='-'
line1=$ch1;line2=$ch2
for ((i = 0;i < llen;i++));do
	line1=${line1}$ch1
done
for ((i = 0;i < llen;i++));do
	line2=${line2}$ch2
done

echo
echo $line1
echo
echo "PC Numbers:	$netblock"
echo "Subnet Mask:	$oct1.$oct2.$oct3.$oct4/$slash"
echo
echo "Network		Host				Broadcast Address"
echo $line2
for ((i = 0;i < 256;i += $netblock));do
	echo	"$ip_a.$i	$ip_a.$((i+1))	-$ip_a.$((i+netblock-2))	$ip_a.$((i+netblock-1))"
done
echo $line2
echo
echo $line1

