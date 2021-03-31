# Wget Script with history-logged feature.
# Written by home_king <home_king@163.com>
# Usage: wgetsc.sh list

wget_list=$1
                                                                                
if [ -n "$wget_list" ] && [ -e "$wget_list" ];then
        rm -f Error.log
        for i in `grep -E '^*tp://' "$wget_list"`; do
                if [ -n $i ] && [ ! -e ${i##*/} ] || [ -e "${i##*/}.part" ]; then
                        wget -c $i -O "${i##*/}.part" && \
                        mv "${i##*/}.part" ${i##*/}
                        [ $? -gt 0 ] && echo "${i##*/}" >> Error.log
                fi
        done
        [ -e Error.log ] && \
        echo "Unable to download below packages with wrong urls:" && \
        cat Error.log && \
        echo "Also see Error.log in detail."
fi
