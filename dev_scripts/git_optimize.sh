#!/usr/bin/env bash
# Cleanup unnecessary files and optimize the local repository

for f in ~/dev-peek/*; do
    pushd $f > /dev/null
    git gc --auto
    popd > /dev/null
done