#!/usr/bin/env bash


if [ -n "$1" ]
then
    REMOTE="${REMOTE:-$1}"
else
    REMOTE=""
fi

source ./pip_common.sh

# -------------------------------------
if [ ! -z "${REMOTE}" ]
then
    for pkgDir in `ls -d ../peek-*` ../synerty-peek; do
        echo "Pulling ${pkgDir} ${REMOTE}/master"
        (cd $pkgDir && git pull $REMOTE master --commit)
    done
else
    for pkgDir in `ls -d ../peek-*` ../synerty-peek; do
        echo "Pulling ${pkgDir}"
        (cd $pkgDir && git pull --commit)
    done
fi
