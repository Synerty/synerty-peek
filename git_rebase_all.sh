#!/usr/bin/env bash


source ./pip_common.sh

REMOTE="${REMOTE:-$1}" # If REMOTE is not defined, try arg 1
REMOTE="${REMOTE:?You must pass a REMOTE to rebase}"


# -------------------------------------
for pkgDir in `ls -d ../peek-*` ../synerty-peek; do
    if [ "${REMOTE}" ]
    then
        echo "Pulling ${pkgDir} ${REMOTE}/master"
        (cd $pkgDir && git pull $REMOTE master --commit)
        echo "Pushing ${pkgDir}"
        (cd $pkgDir && git push)
    fi
    echo "Pulling ${pkgDir}"
    (cd $pkgDir && git pull --commit)
done
