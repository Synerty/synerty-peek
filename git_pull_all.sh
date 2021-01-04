#!/usr/bin/env bash

REMOTE=${1-}

source ./pip_common.sh

# -------------------------------------
for pkgDir in $(ls -d ../peek-*) ../synerty-peek ../vortex* ../tx*; do
    if [ "${REMOTE}" ]; then
        echo "Pulling ${pkgDir} ${REMOTE}/master"
        (cd $pkgDir && git pull $REMOTE master --commit)
    else
        echo "Pulling ${pkgDir}"
        (cd $pkgDir && git pull --commit)
    fi
done
