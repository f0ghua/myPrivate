#! /bin/sh
# 
# The pid modify tool for sernet products,dialog version should higher
# than 0.9b-20031002
#
#                               - Fog, Fri Jul 30 12:52:25 2010
# 
# There are two versions of pid file format,we just support the old
# one which used normally
#
#       Name                  Length(bytes)     Option(Character)
#       ---------------       -------------     -----------------
#       Product ID              4               1-4
#       F/W Version             4               5-8
#       Reserved                40              9-48
#
#

: ${DIALOG=dialog}

export LC_CTYPE=en_US.UTF-8

PIDFILE=$1

if ! [ -n "$PIDFILE" ] || ! [ -e "$PIDFILE" ]; then
   echo "no file input,try to find one"
   PIDFILE=`ls *.pid`   
   if ! [ -n "$PIDFILE" ] || ! [ -e "$PIDFILE" ]; then
      echo "sorry,i can't find any pid file,please indicate it."
      exit
   fi
fi

BACKTITLE="pidtool 1.0 @ Fog, Fri Jul 30 12:59:32 2010"

N_RSVD="0000000000000000000000000000000000000000"

RC=0

while test $RC != 1 && test $RC != 250
do

    O_PRID=`cut -c 1-4 $PIDFILE`
    O_FVER=`cut -c 5-8 $PIDFILE`
    O_RSVD=`cut -c 9-48 $PIDFILE`

    exec 3>&1

    value="`$DIALOG --ok-label "Exit" \
          --no-cancel \
	  --backtitle "$BACKTITLE" \
	  --form "Pick the info of the pid file $PIDFILE" \
0 0 8 \
        "Product ID:"           1 1	"$O_PRID"       1  24 16 4 \
	"Firmware Version:"     2 1	"$O_FVER"       2  24 16 4 \
2>&1 1>&3`"

    RC=$?
    exec 3>&-

    case $RC in
        0)
            N_PRID=`echo $value|cut -d ' ' -f 1`
            N_FVER=`echo $value|cut -d ' ' -f 2`


            PIDFC=$N_PRID$N_FVER$N_RSVD
            
            # write to the pid file
            echo $PIDFC > $PIDFILE

	    "$DIALOG" \
		--clear \
		--backtitle "$backtitle" --no-collapse --cr-wrap \
		--msgbox "Resulting data:\n\n$PIDFC" 10 36

            exit
	    ;;
    esac

done
