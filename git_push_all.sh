#!/usr/bin/env bash

source ./pip_common.sh

# -------------------------------------
for pkgDir in `ls -d ../peek-*` ../synerty-peek ../vortex* ../tx*; do
    echo "Pushing ${pkgDir}"
    (cd $pkgDir && git push)
done
