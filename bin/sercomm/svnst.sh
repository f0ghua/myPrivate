#!/bin/bash
#
# To generate 'svnst_ignore.lst', enter src root dir, run below commands
# 
# svn status -u | grep '^[CMUPAR]' | awk "{print \$3}" >  svnst_ignore_all.lst
# sed 's/$/\$/g' svnst_ignore_all.lst > svnst_ignore.lst

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
svn status -u | grep '^[CMUPAR]'|grep -v -f $DIR/svnst_ignore.lst
