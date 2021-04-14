#!/bin/bash
# backup elpa to myelpa directory
#

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ELPAMPATH=${SCRIPTPATH}
TARGETPATH=~/.emacs.d/myelpa
rm -rf ${TARGETPATH}
mkdir -p ${TARGETPATH} && emacs -Q --batch -l ~/.emacs.d/init.el -l ${ELPAMPATH}/elpa-mirror.el --eval="(setq elpamr-default-output-directory \"${TARGETPATH}\")" --eval='(elpamr-create-mirror-for-installed)'
