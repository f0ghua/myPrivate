#!/bin/sh
i=0
for f in `find . -type f`; do
	i=`expr $i + 1`;
done

echo $i
