#!/usr/bin/env bash

set -o nounset
set -o errexit
# set -x

PACKAGES="
peek-plugin-base
peek-platform
peek-agent
peek-worker
peek-client
peek-client-fe
peek-server
peek-server-fe
synerty-peek"

bold=$(tput bold)
normal=$(tput sgr0)



# -------------------------------------
if ! [ -f "setup.py" ]; then
    echo "setver.sh must be run in the directory where setup.py is" >&2
    exit 1
fi

# -------------------------------------
echo "CHECKING for package existance"
EXIT=""
for pkg in $PACKAGES; do
    if pip freeze | grep -q "${pkg}==" ; then
        echo "Uninstalling $bold${pkg}$normal"
        if ! pip uninstall -q -y $pkg; then
            echo "PIP uninstall of $bold${pkg}$normal failed"
            exit 1
        fi
    fi


done