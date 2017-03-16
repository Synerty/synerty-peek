#!/usr/bin/env bash

path=`dirname $0`

cd $path

ARGS="-H 0.0.0.0"
ARGS="$ARGS -p 8020"
ARGS="$ARGS . ../dist/doc_autobuild"

# Run the command
bash -l -c "sphinx-autobuild $ARGS"
