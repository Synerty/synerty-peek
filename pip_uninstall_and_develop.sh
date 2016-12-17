#!/usr/bin/env bash

source ./pip_common.sh

# -------------------------------------
echo "Ensuring PIP is upgraded"
pip install --upgrade pip

# -------------------------------------
./pip_uninstall_all.sh

# -------------------------------------
echo "Installing packages for development"
EXIT=""
for pkg in $PACKAGES; do

    if ! (cd ../$pkg && python setup.py develop ); then
        echo "Development setup of $bold${pkg}$normal failed" >&2
        exit 1
    fi
done