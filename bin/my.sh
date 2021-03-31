#!/bin/bash
#
# FTP list
#

echo "****************************************************************"
echo "      --下载服务器列表--"
echo " ------------------------------"

# http://bbs.sz.js.cn/dispbbs.asp?boardid=11&id=127227

echo " SerComm :"
echo " ======="
echo " 01. PD6 public ftp             "
echo " 20. Movie ftp             "
echo " "
echo " Dream4Ever论坛 (Music)"
echo " ====================="
echo " 21. eumusic's FTP              22. csljl's ftp"
echo " 23. Music FTP 5                24. FTP2 (Sharin)"
echo " "
echo " Dream4Ever论坛 (Software)"
echo " ====================="
echo " 26. 1900 FTP"
echo " 27. LoginNow FTP                 "
echo " "
echo " SerComm FTP :"
echo " =============="
echo " 25. Quantenna FTP"
echo " 31. RFT630 FTP1                32. RFT630 FTP2"
echo " 33. Broadlight FTP1            34. Broadlight FTP2"
echo "****************************************************************"

while true
do
echo -n "select the server:"
read

num=$REPLY
len=${#num}
port=21
szusr=xiazai
szpwd='tq5?Ye>$Zc,mb>('



if [[ $num != [0-9][0-9] ]];then
    echo "pls select a server!"
    continue
else
    echo "connecting to server..."
    case $num in
	"01") 	ip=ftp.sdc.sercomm.com
	    port=21
	    user=fog
	    psd=foghua;;
	"02") 	ip=58.211.114.97
	    port=2121
	    user=$szusr
	    psd=$szpwd;;
	"03") 	ip=DVD3.sz.js.cn
	    port=2121
	    user=xiazai200
	    psd='DKJ!?lY?19dGEqYV.';;
	"04") 	ip=DVD4.sz.js.cn
	    port=62121
	    user=xiazai200
	    psd='DKJ!?lY?19dGEqYV.';;
	"05") 	ip=music.sz.js.cn
	    port=21
	    user=xiazai200
	    psd='DKJ!?lY?19dGEqYV.';;
	"06") 	ip=DVD5.sz.js.cn
	    port=62121
	    user=$szusr
	    psd=$szpwd;;
	"07") 	ip=SOFTFTP1.sz.js.cn
	    port=2133
	    user=down
	    psd=down;;
	"08") 	ip=SOFTFTP2.sz.js.cn
	    port=62121
	    user=$szusr
	    psd=$szpwd;;
	"09") 	ip=58.211.114.97
	    port=2121
	    user=$szusr
	    psd=$szpwd;;
	"11") 	ip=1033917415
	    port=21
	    user=goldeye@asddsa_DRL
	    psd=994618f7bb173bb4da4111b9f0f5846d;;
	"12") 	ip=222.83.250.17
	    port=2006
	    user=goldeye@oyyl_DRL
	    psd=4855c8c878e0c5f174164a0be0a79723;;
	"13") 	ip=992028169
	    port=2121
	    user=goldeye@TtiGeR_DRL
	    psd=93d99b2e3aa136ec341d275c152458f5;;
	"14") 	ip=3729575982
	    port=2121
	    user=goldeye@TtiGeR_DRL
	    psd=93d99b2e3aa136ec341d275c152458f5;;
	"15") 	ip=61.143.251.75
	    port=555
	    user=drl
	    psd=dsahkdshajdkhsjk2;;
	"16") 	ip=222.77.189.20
	    port=10021
	    user=goldeye@Chocobo_DRL
	    psd=0e99397d59ef0d615c1917e194fc9be8;;
	"17") 	ip=ftp1.dream4ever.org
	    port=21210
	    user=DRL2115@FTP1
	    psd=f4553b84a305a95412914b551d4cb347;;
	"18") 	ip=clm2k2.dream4ever.org
	    port=40008
	    user=goldeye@clm_DRL
	    psd=8e28ddd608290c64835283732b92659c;;
	"19") 	ip=222.77.189.20
	    port=10021
	    user=goldeye@Chocobo_DRL
	    psd=0e99397d59ef0d615c1917e194fc9be8;;
	"20") 	ip=172.21.1.237/others/movie
	    port=21
	    user=mis
	    psd=mis;;
	"21")	ip=ftp://61.153.183.149
	    port=218
	    user=DRL_NEW
	    psd=djakjahzmhnzn3as3ww2;;
        "22")  # https://dream4ever.org/showthread.php?t=206409  
	    ip=dramaz.3322.org
            port=10070
            user=DRL2115@drlshr2
            psd=cbec45a014cb7c4b5ce54ab375f6f86c;;
        "23")   ip=ftp5.dream4ever.org
            port=21210
            user=DRL2115@FTP1
            psd=4d21ff12afcefd07dca671a964f0cc1b;;
        "24")   ip=ftp2.dream4ever.org
            port=21210
            user=DRL2115@FTP1
            psd=4d21ff12afcefd07dca671a964f0cc1b;;
        "25")   ip=ftp.quantenna.com
            port=21
            user=sercomm
            psd=Gw9ho#*;;
        "26")   ip=ftp://drlchinanet.jindui.com
            port=5454
            user=DRL2115
            psd=7191ba644bd4822a41e33b4c710c6570;;
        "27")   ip=202.102.148.10
            port=4321
            user=goldeye@LoginNow_DRL
            psd=0d995b519d5d43e594ae14305bb23c0d;;

        "31")
            ip=ftp.sdc.sercomm.com
            port=21
            user=temp3
            psd=sailor;;
        "32")   
            ip=ftp.sdc.sercomm.com
            port=21
            user=temp9
            psd=foghua;;
	"31") 
            ip=ftp://bl-ftp.broadlight.com
	    port=21
	    user=PONMakerPro
	    psd=pmp1111;;
	"32") 
            ip=ftp://ftp.edom.com.tw
	    port=21
	    user=omci
	    psd=2djv90=;;

	*)	exit -1;;
    esac
    lftp ${ip} -p $port -u $user,$psd
    exit 0;
fi
done

