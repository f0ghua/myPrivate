#!/bin/sh

proxyN=$1
: ${proxyN:="5"}
port=22

case $proxyN in
    "1")
	username="drlccfpublic"
	password="eHSIVK4u8x5a&ktfCTig3g4z "
        server="us02.uapp.info"
        port="36022"
	;;
    "2")
	username="drlccfpublic"
	password="Y03LEK6GoK1ApbLm"
        server="us03.uapp.info"
        port="36022"
	;;
    "3")
	username="drlccfpublic"
	password="eHSIVK4u8x5a&ktfCTig3g4z "
	server="us04.uapp.info"
        port="36022"
	;;
    "4")
	username="drlccfpublic"
	password="eHSIVK4u8x5a&ktfCTig3g4z "
        server="us05.uapp.info"
        port="36022"
	;;
    "5")
        infoFile="/tmp/sshcenter_info.txt"
        cookieFile="/tmp/sshcenter_cookie.txt"
        captchaGet="/tmp/sshcenter_captcha.png"
        tmpFile="/tmp/tmpFile"
        pwntchaPath=/home/fog/study/code/ocr/src/pwntcha/src/
        pwntchaBin=${pwntchaPath}/pwntcha

        server="ssh.sshcenter.info"

        if [ -f $infoFile ]; then
            read username password < $infoFile
        else
            randomStr=`mcookie`
            randomStr=${randomStr:5:5}
	    username="proxy"$randomStr
	    password="123456"

            # Do register first
            :>$tmpFile
            :>$cookieFile
            curl -m 30 -D $tmpFile \
                -H "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.3) Gecko/20100423 Ubuntu/10.04 (lucid) Firefox/3.6.3" \
                -H "Accept-Language: en-us,en;q=0.5" \
                -H "Accept-Encoding: gzip,deflate" \
                -H "Accept-Charset: GB2312,utf-8;q=0.7,*;q=0.7" \
                -H "Keep-Alive: 115" \
                -H "Connection: keep-alive" \
                -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
                http://www.sshcenter.info/signup.php -o /dev/null
            cat $tmpFile >> $cookieFile
            curl -m 30 -b $cookieFile -D $tmpFile $httpOption -H "Accept: image/png,image/*;q=0.8,*/*;q=0.5" http://www.sshcenter.info/showimg.php -o $captchaGet
            cat $tmpFile >> $cookieFile

            cCode=`$pwntchaBin -s $pwntchaPath/share/ $captchaGet 2>/dev/null`
            echo "$username, $cCode"

            postData="username=${username}&email=${username}%40gmail.com&password=${password}&confirm_password=${password}&verifycode=${cCode}&Submit=%E6%B3%A8%E5%86%8C%E6%96%B0%E7%94%A8%E6%88%B7&act=signup"
            curl -m 30 -b $cookieFile \
                -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
                --referer "http://www.sshcenter.info/signup.php" \
                -d "$postData" "http://www.sshcenter.info/flow.php?step=login" -o $tmpFile
            echo "$username $password" > $infoFile
        fi
	;;
    "6") 
        proxy_url="http://freessh.us"
        proxy_page=/tmp/freessh_us.htm
        wget --quiet -T 20 -t 1 -O ${proxy_page} ${proxy_url}
        account_info=`cat ${proxy_page}|iconv -f utf8 -t gb2312//IGNORE|sed -n -e "/<td bgcolor='#FFFFFF'>[^<]*<\/td>/p"|sed 's/[^>]*>\([^<]*\)<\/td>[^>]*/\1/'|head -n 4`

        server=$(echo ${account_info}|cut -d " " -f 2)
        username=$(echo ${account_info}|cut -d " " -f 3)
        password=$(echo ${account_info}|cut -d " " -f 4)

        echo $server $username $password
        if [ "$password" = "繁忙" ];then
            echo "Account is busy, pls try again later."
            exit
        fi
        ;;

    "7")
        proxy_url="http://ssh.xiaod.in"
        proxy_page=/tmp/ssh_xiaod_in.htm
        wget --quiet -T 20 -t 1 -O ${proxy_page} ${proxy_url}
        server=`cat ${proxy_page}|iconv -f utf8 -t gb2312//TRANSMIT|grep 服务器IP|sed 's/[^a-z0-9]*\([a-z0-9.]*\) .*/\1/g'`
        username=`cat ${proxy_page}|iconv -f utf8 -t gb2312//TRANSMIT|grep SSH用户|sed 's/[^a-z0-9]*\([a-z0-9.]*\) .*/\1/g'`
        password=`cat ${proxy_page}|iconv -f utf8 -t gb2312//TRANSMIT|grep SSH密码|sed 's/[^a-z0-9]*\([a-z0-9.]*\)/\1/g'`
        echo $server $username $password
        ;;

    "8")
        proxy_url="http://ssh.tl"
        username="sshtl"
        proxy_attr=`wget --quiet -T 20 -t 1 -O - ${proxy_url} |grep $username|sed -e 's/<[^<>]\{1,\}>/ /g'`
        password=`echo $proxy_attr|cut -d " " -f 2`
        server=`echo $proxy_attr|cut -d " " -f 3`
        ;;
esac

killall ssh > /dev/null 2>&1

echo "Connecting to SSH server $server ($username:$password)"
sshlogin.exp $server $username $password $port
