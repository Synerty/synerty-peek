#!/usr/bin/env bash

set -o nounset
set -o errexit

source ./pip_common.sh

# -------------------------------------
echo "Uninstalling all packages"
EXIT=""
for pkg in $PLATFORM_PKGS $PLUGIN_PKGS; do
    if pip freeze | grep -q "${pkg}==" ; then
        echo "Uninstalling $bold${pkg}$normal"
        if ! pip uninstall -q -y $pkg; then
            echo "PIP uninstall of $bold${pkg}$normal failed"
            exit 1
        fi
    fi

done
