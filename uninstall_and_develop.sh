#!/usr/bin/env bash

set -o nounset
set -o errexit
# set -x

PACKAGES="
peek_plugin_base
peek_platform
peek_agent
peek_worker
peek_client_fe
peek_client
peek_server_fe
peek_server
synerty-peek"

bold=$(tput bold)
normal=$(tput sgr0)



# -------------------------------------
if ! [ -f "setup.py" ]; then
    echo "setver.sh must be run in the directory where setup.py is" >&2
    exit 1
fi

# -------------------------------------
echo "Ensuring PIP is upgraded"
pip install --upgrade pip

# -------------------------------------
echo "CHECKING for package existance"
EXIT=""
for pkg in $PACKAGES; do
    if pip freeze | grep -q "${pkg}==" ; then
        if ! pip uninstall -q -y $pkg; then
            echo "PIP uninstall of $bold${pkg}$normal failed"
            exit 1
        fi
    fi

    if ! (cd ../$pkg && python setup.py develop ); then
        echo "Development setup of $bold${pkg}$normal failed" >&2
        exit 1
    fi
done