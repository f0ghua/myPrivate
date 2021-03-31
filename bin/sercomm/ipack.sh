#!/bin/bash

usage()
{
    echo "===================================================="
    echo " Usage : `basename $0` <base bin> <attached file>   "
    echo "===================================================="
    exit 1
}

if [ $# -lt 2 ]
then
    #no parameters passed!
    usage
fi

ENDTAG="%"
MAGICWORD="@!@!"
TMPL_PATH="/home/fog/xTmp/tr/material"

BN=$1
FN=$2

echo "copying base file from template $TMPL_PATH/$BN ..."
cp $TMPL_PATH/$BN .
SZ_BN=$(wc -c < "$BN")
SZ_FN=$(wc -c < "$FN")
HDRSZ=$(expr ${#ENDTAG} + ${#MAGICWORD})
SZ_OBN=$((SZ_BN-SZ_FN-HDRSZ))
if ((SZ_OBN < 1024)); then
   SZ_OBN=1024
fi
echo "SZ_OBN=$SZ_OBN"
SZ_OBN=$((SZ_OBN + $RANDOM % (1024 * 1024)))
echo "truncating base file from $SZ_BN to $SZ_OBN..."
truncate -s $SZ_OBN $BN

echo -n "$MAGICWORD" >> $BN
echo -n "$ENDTAG" >> $BN
cat $FN >> $BN
echo "Congratulations. A new file has been built successfully."
