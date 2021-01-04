#!/usr/bin/env bash

source ./pip_common.sh

# -------------------------------------
for pkgDir in $(cd ../ && ls -d peek-*) synerty-peek; do
    if [[ ${pkgDir} == *"pof"* ]]; then continue; fi
    if [[ ${pkgDir} == *"gis"* ]]; then continue; fi

    echo "Pushing ${pkgDir}"
    pushd ../$pkgDir
    git remote remove github 2>/dev/null || true
    git remote add github git@github.com:Synerty/${pkgDir}.git
    git push -f github master || true
    popd
done
