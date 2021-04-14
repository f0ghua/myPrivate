#! /bin/sh
: ${DIALOG=dialog}

export LC_CTYPE=en_US.UTF-8

PIDFILE=$1
TMPFILE=pidtmp

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

S_PIDV="1.PID Version:"
S_CDNM="2.Card Number:"
S_PID1="3.Product ID:"
S_PIM1="4.Product Mask:"
S_FVER="5.Firmware Version:"
S_CSZE="6.Code Size:"

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

$DIALOG --ok-label "Modify" \
    --cancel-label "Done" \
    --backtitle "$BACKTITLE" \
    --menu "Pick info from the pid file $PIDFILE" \
    16 55 6 \
    "$S_PIDV"            "$O_PIDV" \
    "$S_CDNM"            "$O_CDNM" \
    "$S_PID1"	        "$O_PID1" \
    "$S_PIM1"	        "$O_PIM1" \
    "$S_FVER" 	        "$O_FVER" \
    "$S_CSZE" 	        "$O_CSZE" \
    2>$TMPFILE

RV=$(cat $TMPFILE)
RC=$?

#echo $RC $RV

case $RV in
    $S_PIDV)
        $DIALOG --title "$S_PIDV" --clear \
            --inputbox "\nPlease input the value:" 8 34 "$O_PIDV" 2> $TMPFILE
        N_PIDV=$(cat $TMPFILE)

        ;;
    $S_CDNM)
        $DIALOG --title "$S_CDNM" --clear \
            --inputbox "\nPlease input the value:" 8 34 "$O_CDNM" 2> $TMPFILE
        N_CDNM=$(cat $TMPFILE)

        ;;
    $S_PID1)
        $DIALOG --title "$S_PID1" --clear \
            --inputbox "\nPlease input the value:" 8 34 "$O_PID1" 2> $TMPFILE
        N_PID1=$(cat $TMPFILE)

        ;;
    $S_PIM1)
        $DIALOG --title "$S_PIM1" --clear \
            --inputbox "\nPlease input the value:" 8 34 "$O_PIM1" 2> $TMPFILE
        N_PIM1=$(cat $TMPFILE)

        ;;
    $S_FVER)
        $DIALOG --title "$S_FVER" --clear \
            --inputbox "\nPlease input the value:" 8 34 "$O_FVER" 2> $TMPFILE
        N_FVER=$(cat $TMPFILE)

        ;;
    $S_CSZE)
        $DIALOG --title "$S_CSZE" --clear \
            --inputbox "\nPlease input the value:" 8 34 "$O_CSZE" 2> $TMPFILE
        N_CSZE=$(cat $TMPFILE)

        ;;

    *)
        echo -e "\nCancel: cancel the modification!"
        exit 1
        ;;
esac

done

echo "pidv:$N_PIDV"

rm $TMPFILE
