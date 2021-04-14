#!/bin/sh

for f in `ls *.htm`;do
sed -e 's/href\=\(['"'"'"]\)\([^/]*\.cgi\)/href\=\1cgi-bin\/\2/g' $f > tmp
mv tmp $f
done

