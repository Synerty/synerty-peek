#!/usr/bin/env bash

set -o nounset
set -o errexit
# set -x

PACKAGES="
peek_plugin_base
peek_platform
peek_agent
peek_client
peek_client_fe
peek_server
peek_server_fe
peek_worker"

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
    if ! pip uninstall $pkg > /dev/null ; then
        echo "PIP uninstall of $bold${pkg}$normal failed"
    fi

    if ! (cd ../$pkg && python setup.py develop > /dev/null); then
        echo "Development setup of $bold${pkg}$normal failed" >&2
        exit 1
    fi
done