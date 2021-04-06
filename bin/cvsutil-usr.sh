#!/bin/sh
#
# CVS user management tool
#
# This scirpt can add/del/update users to CVS repository and Web
# control files
#
# Fog Hua, Wed Jan 17 12:28:48 2007
#
# ChangeLog
#
# - Fri Jan 19 16:20:35 2007
#   
#   Add username and group name verify
#
#

# close the stderr
#exec 2>&-

BOOTUP=color

RES_COL=55
MOVE_TO_COL="echo -en \\033[${RES_COL}G"
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_WARNING="echo -en \\033[1;33m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"

usage()
{
    echo "Usage: `basename $0` [add/del/update] [args ...]"
    echo ""
    echo -e "    -u\tUser name, which is needed"
    echo -e "    -g\tGroup name, which is needed"
    echo -e "    -p\tPassword, if not set, the script will generate one"
    echo -e "    -m\tpermission,should be read('r') or write('w')"
    echo "----------------------------------------------------------------"
    echo "e.g."
    echo "$ `basename $0` add -g ap -u fog -m r"
    echo "$ `basename $0` del -g ap -u fog"
    echo "$ `basename $0` update -g ap -u fog -p 123456"
    echo "----------------------------------------------------------------"
    echo ""
    exit -1
}

echo_mark()
{
    [ "$BOOTUP" = "color" ] && $SETCOLOR_WARNING
    echo -n $1
    [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
}

echo_succ() 
{
    echo -n "$1"
    echo -n " ... "
    [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
    echo -n "["
    [ "$BOOTUP" = "color" ] && $SETCOLOR_SUCCESS
    echo -n $"   OK   "
    [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
    echo -n "]"
    echo -ne "\r\n"

    return 1
}

echo_fail()
{
    [ "$BOOTUP" = "color" ] && $SETCOLOR_FAILURE
    echo $@
    [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
}

#if [ $# -lt 4 ];then
#    usage
#fi

AC=$1

while [ $# -gt 0 ]; do
    case $1 in
        -h|--help)
            usage
            exit
            ;;
        -u|--user)
            USER="$2"
            shift;
            ;;
        -p|--password)
            PSWD="$2"
            shift;
            ;;
        -g|--group)
            GP="$2"
            shift;
            ;;
        -m|--permission)
            PM="$2"
            shift;
            ;;
    esac
    shift
done

# user and group is needed parameter
if [[ ! $GP ]] || [[ ! $USER ]]; then
    usage
fi

# group list
G_LIST=( ap isbu pbs driver nas sbu-i sbu-ii sbu-iii public )
E_INGP=1

for v in "${G_LIST[@]}";do [[ $GP = $v ]] && E_INGP=0;done

if [[ $E_INGP = 1 ]]; then
    echo_fail "The group name is not correct, it should be one of the"
    echo_fail "following one:"
    echo
    echo_fail "${G_LIST[@]}"
    exit
fi

if [[ "${USER}" != *?_?* ]]; then
    echo_fail "The username is not correct, it should be *_*!"
    exit
fi

exit

#echo $PM,$GP,$USER,$PSWD;exit

DEBUGDIR=/home/fog/tmp/code/script/cvs
#DEBUGDIR=

F_CPW="${DEBUGDIR}/home/cvsadmin/${GP}/CVSROOT/passwd"
F_APA="${DEBUGDIR}/var/www/cgi-bin/cvs/${GP}/.htpasswd"
F_AGP="${DEBUGDIR}/var/www/cgi-bin/cvs/${GP}/.htgroup"

F_CPMR="${DEBUGDIR}/home/cvsadmin/${GP}/CVSROOT/readers"
F_CPMW="${DEBUGDIR}/home/cvsadmin/${GP}/CVSROOT/writers"



case "$AC" in
    "add")
        # permission must be set
        if [[ ! $PM ]]; then
            usage
        fi

        if [[ "$PM" = "r" ]]; then
            F_CPM=$F_CPMR
        else
            F_CPM=$F_CPMW
        fi

        # No password assigned, we generate it by ourself
        if [[ ! $PSWD ]];then
            PSWD=$(head -c 8 /dev/random | openssl enc -base64 | head -c 8)
        fi

        UPWD=$(htpasswd -b -n $USER $PSWD)
        CPWD=${UPWD##*:}
        # sed parameter need escape '/', so we replace it with '\/'
        SPWD=${UPWD//\//\\/}
        
        # Add user to OS system
        #useradd -g $GP -d /home/cvs-home/$USER -s /dev/null $USER

        # Add user to CVS repository

        if (! grep "\<${USER}\>" $F_CPW > /dev/null);then
            echo "${UPWD}" >> $F_CPW
        fi

        if (! grep "\<${USER}\>" $F_CPM > /dev/null);then
            echo "${USER}" >> $F_CPM
        fi

        # Add user to Web control directory

        if (! grep "\<${USER}\>" $F_APA > /dev/null);then
            echo "${UPWD}" >> $F_APA
        fi

        if (! grep "\<${USER}\>" ${F_AGP} > /dev/null);then
            sed -i "s/$/ ${USER}/g" $F_AGP > /dev/null
        fi

        echo_succ "[ADD]: U=${USER},G=${GP},P=${PSWD},M=${PM}"
        ;;
    "del"|"delete")

        # Remove user to Web control directory

        if (grep "\<${USER}\>" $F_APA > /dev/null);then
            sed -i "/${USER}:.*/d" $F_APA > /dev/null
        fi

        if (grep "\<${USER}\>" ${F_AGP} > /dev/null);then
            sed -i "s/ \<${USER}\>//g" $F_AGP > /dev/null
        fi

        # Remove user from CVS repository

        if (grep "\<${USER}\>" $F_CPW > /dev/null);then
            sed -i "/^${USER}:.*/d" $F_CPW > /dev/null
        fi

        if (grep "\<${USER}\>" $F_CPMR > /dev/null);then
            sed -i "/^${USER}$/d" $F_CPMR > /dev/null
        fi

        if (grep "\<${USER}\>" $F_CPMW > /dev/null);then
            sed -i "/^${USER}$/d" $F_CPMW > /dev/null
        fi

        # Delete user from OS system
        #userdel $USER

        echo_succ "[DEL]: U=${USER},G=${GP},P=${PSWD},M=${PM}"
        ;;
    "up"|"update")

        if [[ "$PM" = "r" ]]; then
            F_CPM=$F_CPMR
        else
            F_CPM=$F_CPMW
        fi

        if [[ $PSWD ]]; then
            UPWD=$(htpasswd -b -n $USER $PSWD)
            CPWD=${UPWD##*:}
            # sed parameter need escape '/', so we replace it with '\/'
            SPWD=${UPWD//\//\\/}

            if (grep "\<${USER}\>" $F_CPW > /dev/null);then
                sed -i "s/^${USER}:.*/${SPWD}/g" $F_CPW > /dev/null
            fi
            
            if (grep "\<${USER}\>" $F_APA > /dev/null);then
                sed -i "s/^${USER}:.*/${SPWD}/g" $F_APA > /dev/null
            fi
        fi

        if [[ $PM ]]; then
            sed -i "/^${USER}$/d" $F_CPMR > /dev/null
            sed -i "/^${USER}$/d" $F_CPMW > /dev/null
            echo "${USER}" >> $F_CPM
        fi

        if (! grep "\<${USER}\>" ${F_AGP} > /dev/null);then
            sed -i "s/$/ \<${USER}\>/g" $F_AGP > /dev/null
        fi

        echo_succ "[UPD]: U=${USER},G=${GP},P=${PSWD},M=${PM}"
        ;;
    *)
        usage;;
esac
