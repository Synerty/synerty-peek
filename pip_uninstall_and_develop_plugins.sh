#!/usr/bin/env bash

source ./pip_common.sh

# -------------------------------------
echo "Installing packages for development"
EXIT=""
for pkg in $PLUGINS; do

    pip uninstall -q -y $pkg || true

    if ! (cd ../$pkg && python setup.py develop ); then
        echo "Development setup of $bold${pkg}$normal failed" >&2
        exit 1
    fi
done