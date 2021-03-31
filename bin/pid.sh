# 
# The pid modify tool for sernet products,dialog version should higher
# than 0.9b-20031002
#
#                               - Fog,Wed Oct 13 15:24:29 2004
# 
# There are two versions of pid file format,we just support the old
# one which used normally
#
#       Name                  Length(bytes)     Option(Character)
#       ---------------       -------------     -----------------
#       Version Control         2               1-4
#       Upgrade Control         2               5-8
#       H/W ID                  32              9-72
#       H/W Version             2               73-76
#       Product ID              2               77-80
#       Product ID Mask         2               81-84
#       Product ID              2               85-88
#       Product ID Mask         2               89-92
#       Function ID             2               93-96
#       Function ID Mask        2               97-100
#       F/W Version             2               101-104
#       Starting code segment   2               105-108
#       Code Size               2               109-112
#
#
#! /bin/sh
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

BACKTITLE="pidtool 1.0 @ fog,Wed Oct 13 14:01:13 2004"

RC=0

while test $RC != 1 && test $RC != 250
do
O_PIDV=`cut -c 1-4 $PIDFILE`
O_UPGC=`cut -c 5-8 $PIDFILE`
O_HWID=`cut -c 9-72 $PIDFILE`
O_CDNM=`cut -c 9-14 $PIDFILE`
O_HWRV=`cut -c 15-72 $PIDFILE`
O_HVER=`cut -c 73-76 $PIDFILE`
O_PID1=`cut -c 77-80 $PIDFILE`
O_PIM1=`cut -c 81-84 $PIDFILE`
O_PID2=`cut -c 85-88 $PIDFILE`
O_PIM2=`cut -c 89-92 $PIDFILE`
O_FCID=`cut -c 93-96 $PIDFILE`
O_FCIM=`cut -c 97-100 $PIDFILE`
O_FVER=`cut -c 101-104 $PIDFILE`
O_SCSG=`cut -c 105-108 $PIDFILE`
O_CSZE=`cut -c 109-112 $PIDFILE`
exec 3>&1
value="`$DIALOG --ok-label "Submit" \
          --no-cancel \
	  --backtitle "$BACKTITLE" \
	  --form "Pick the info of the pid file $PIDFILE" \
0 0 8 \
        "PID Version:"          1 1	"$O_PIDV"       1  24 16 4 \
        "Card Number:"          2 1     "$O_CDNM"       2  24 16 6 \
        "Product ID:"           3 1	"$O_PID1"       3  24 16 4 \
        "Product Mask:"         4 1	"$O_PIM1"       4  24 16 4 \
	"Firmware Version:"     5 1	"$O_FVER"       5  24 16 4 \
        "Start Code Segment:"   6 1	"$O_SCSG"       6  24 16 4 \
	"Code Size:"            7 1	"$O_CSZE"       7  24 16 4 \
2>&1 1>&3`"
RC=$?
exec 3>&-

	case $RC in
	1)
                exit

		"$DIALOG" \
		--clear \
		--backtitle "$backtitle" \
		--yesno "Really quit?" 10 30
		case $? in
		0)
			break
			;;
		1)
			RC=99
			;;
		esac
		;;
	0)
                N_PIDV=`echo $value|cut -d ' ' -f 1`
                N_CDNM=`echo $value|cut -d ' ' -f 2`
                N_PID1=`echo $value|cut -d ' ' -f 3`
                N_PIM1=`echo $value|cut -d ' ' -f 4`
                N_FVER=`echo $value|cut -d ' ' -f 5`
                N_SCSG=`echo $value|cut -d ' ' -f 6`
                N_CSZE=`echo $value|cut -d ' ' -f 7`

                PIDFC=$N_PIDV$O_UPGC$N_CDNM$O_HWRV$O_HVER$N_PID1$N_PIM1$O_PID2$O_PIM2$O_FCID$O_FCIM$N_FVER$N_SCSG$N_CSZE
                
                # write to the pid file
                echo $PIDFC > $PIDFILE

		"$DIALOG" \
		--clear \
		--backtitle "$backtitle" --no-collapse --cr-wrap \
		--msgbox "Resulting data:\n\n$PIDFC" 0 0

                exit
		;;
	esac

done
