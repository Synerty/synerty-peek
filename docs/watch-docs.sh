#!/usr/bin/env bash

path=`dirname $0`

bash -l -c "sphinx-autobuild -p 8020 -H 0.0.0.0 $path $path/../dist/doc_autobuild"
