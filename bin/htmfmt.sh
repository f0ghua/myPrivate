#!/bin/sh

if [ ! $# -eq 0 ]
then
FILELIST=$1
else
FILELIST=$(ls *.htm)
fi

for file in $FILELIST;do
    echo "converting $file...";
# change all *.htm and *.gif to lowercase
#    cat $file|sed 's/[_a-zA-Z0-9]\+\.htm/\L&/g'>tmp0;
#    cat tmp0|sed 's/[_a-zA-Z0-9]\+\.gif/\L&/g'>tmp;
#    rm tmp0;rm $file;
#    cp tmp $file;
    	cp $file tmp;
     hindent -i 2 -c tmp>$file;
     dos2unix -q $file;
     rm tmp;
done

echo "****************************************"
echo "finished converting,look,it is beautiful!"
echo "****************************************"
