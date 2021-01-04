#!/usr/bin/env bash

REMOTE="${REMOTE:-$1}" # If REMOTE is not defined, try arg 1
REMOTE="${REMOTE:?You must pass a REMOTE to rebase}"

source ./pip_common.sh

# -------------------------------------
for pkgDir in $(ls -d ../peek-*) ../synerty-peek; do
    echo "Pulling ${pkgDir} ${REMOTE}/master"
    (cd $pkgDir && git pull $REMOTE master --commit)
    echo "Pulling ${pkgDir}"
    (cd $pkgDir && git pull --commit)
    echo "Pushing ${pkgDir}"
    (cd $pkgDir && git push)
done
