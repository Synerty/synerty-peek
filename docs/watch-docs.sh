#!/usr/bin/env bash

# Make sure this script has all the environment setup
export PATH="$(dirname `echo 'which python' | bash -l`):$PATH"

path=`dirname $0`
cd $path


function modPath() {
python <<EOPY
import os.path as p
import $1
print(p.dirname($1.__file__))
EOPY
}

ARGS="-H 0.0.0.0"
ARGS="$ARGS -p 8020"
ARGS="$ARGS . ../dist/doc_autobuild"
ARGS="$ARGS --watch `modPath 'peek_plugin_base'`"

echo "Running sphinx-autobuild with args :"
echo "$ARGS"

# Run the command
sphinx-autobuild $ARGS
