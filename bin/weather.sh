#!/bin/sh
cd /tmp
tmpf1=s1.txt
tmpf2=s2.txt
city_page=Suzhou_CI

getweather()
{
	grep 'bgcolor="#fff5dd">' ss.html > ${tmpf1}
	grep '<td bgcolor="#e5e8d9">' ss.html > ${tmpf2}
	sed -i 's/&deg;C/%C/g' ${tmpf2}
	day0_tq=$(sed -n '1p' ${tmpf1}| sed 's/<.*"> *//g'|sed 's/<\/td>//g'|sed 's/[\t ]*//g')
	day1_tq=$(sed -n '2p' ${tmpf1}| sed 's/<.*"> *//g'|sed 's/<\/td>//g'|sed 's/[\t ]*//g')
	day2_tq=$(sed -n '3p' ${tmpf1}| sed 's/<.*"> *//g'|sed 's/<\/td>//g'|sed 's/[\t ]*//g')
	day0_ch=$(sed -n '1p' ${tmpf2}| sed 's/<.*"> *//g'|sed 's/<\/td>//g'|sed 's/[\t ]*//g')
	day1_ch=$(sed -n '2p' ${tmpf2}| sed 's/<.*"> *//g'|sed 's/<\/td>//g'|sed 's/[\t ]*//g')
	day2_ch=$(sed -n '3p' ${tmpf2}| sed 's/<.*"> *//g'|sed 's/<\/td>//g'|sed 's/[\t ]*//g')
	day0_cl=$(sed -n '4p' ${tmpf2}| sed 's/<.*"> *//g'|sed 's/<\/td>//g'|sed 's/[\t ]*//g')
	day1_cl=$(sed -n '5p' ${tmpf2}| sed 's/<.*"> *//g'|sed 's/<\/td>//g'|sed 's/[\t ]*//g')
	day2_cl=$(sed -n '6p' ${tmpf2}| sed 's/<.*"> *//g'|sed 's/<\/td>//g'|sed 's/[\t ]*//g')
	day0_wd=$(sed -n '7p' ${tmpf2}| sed 's/<.*"> *//g'|sed 's/<\/td>//g'|sed 's/[\t ]*//g')
	day1_wd=$(sed -n '8p' ${tmpf2}| sed 's/<.*"> *//g'|sed 's/<\/td>//g'|sed 's/[\t ]*//g')
	day2_wd=$(sed -n '9p' ${tmpf2}| sed 's/<.*"> *//g'|sed 's/<\/td>//g'|sed 's/[\t ]*//g')
}

showweather()
{
        echo
        echo -e "日    期:  \t今天\t\t\t明天\t\t后天"
        echo -e "天    气:  \t${day0_tq}\t\t${day1_tq}\t\t${day2_tq}"
        echo -e "最高温度:  \t${day0_ch}\t\t\t${day1_ch}\t\t${day2_ch}"
        echo -e "最低温度:  \t${day0_cl}\t\t\t${day1_cl}\t\t${day2_cl}"
        echo -e "风    力:  ${day0_wd}\t${day1_wd}\t${day2_wd}"
        echo

	exit 0
}

getall()
{
        wget  -O /tmp/ss.html http://weather.elong.com/new-cities/${city_page}.html > /dev/null 2>&1
        getweather
        showweather

        rm -f ss.html s1.txt s2.txt > /dev/null 2>&1
}

getall

exit 0
