#!/usr/bin/env bash

set -o nounset
set -o errexit

# Make sure this script has all the environment setup
export PATH="$(dirname $(echo 'which python' | bash -l)):$PATH"

path=$(dirname $0)
cd $path

function modPath() {
    python <<EOPY
import os.path as p
import $1
dir = p.dirname($1.__file__)
# Convert it to bash if required
if dir[1] == ':':
    dir = '/' + dir[0] + dir[2:].replace('\\\\', '/')
print(dir)
EOPY
}

ARGS="--host 0.0.0.0"
ARGS="$ARGS --port 8020"
ARGS="$ARGS . ../dist/doc_autobuild"
ARGS="$ARGS --watch $(modPath 'peek_plugin_base')"

echo "Running sphinx-autobuild with args :"
echo "$ARGS"

# Run the command
sphinx-autobuild $ARGS
