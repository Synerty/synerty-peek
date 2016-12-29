#!/usr/bin/env bash

source ./pip_common.sh

# -------------------------------------
for pkgDir in `ls -d ../peek-*` ../synerty-peek; do
    echo "Pulling ${pkgDir}"
    (cd $pkgDir && git pull)
done