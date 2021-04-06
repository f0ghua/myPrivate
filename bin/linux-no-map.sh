#!/bin/sh
#
# Script used to get errno or signal number's definition, you should
# create soft links before using, file 'errno' for get errno
# definition and 'signo' for signal definition.
# 
# Fog, Thu Jan 25 16:42:21 2007
#
usage() 
{
    echo >&2 "usage: $0 [numbers or error/signal names]\n"
    exit 1
}

no_map()
{
    for i
    do
        case "$i" in
            [0-9]*)
                awk '/^#define/ && $3 == '"$i"' {
                    for (i = 5; i < NF; ++i) {
                        foo = foo " " $i;
                    }
                    printf("%-22s%s\n", $2 " [" $3 "]:", foo);
                    foo = ""
                 }' < $FILE
                ;;
            E*)
                awk '/^#define/ && $2 == "'"$i"'" {
                    for (i = 5; i < NF; ++i) {
                        foo = foo " " $i;
                    }
                    printf("%-22s%s\n", $2 " [" $3 "]:", foo);
                    foo = ""
                }' < $FILE
                ;;
            *)
                echo >&2 "can't figure out whether '$i' is a name or a number."
                usage
                ;;
        esac
    done
}

F_ERRNO="/usr/include/linux/errno.h"
F_SIGNO="/usr/include/bits/signum.h"

case $0 in
    *err*) 
        FILE=$F_ERRNO
        no_map $*
        ;;
    *sig*) 
        FILE=$F_SIGNO
        no_map $*
        ;;
    *) 
        FILE=$F_ERRNO
        no_map $*
        ;;
esac

exit 0
