#!/usr/bin/env bash

source ~/.bashrc

set -o nounset
set -o errexit

source ./pip_common.sh

VER=${1}
SRC_PATH="${2:-..}"
DST_PATH="${3:-/tmp/plugin}"


cd ${SRC_PATH}
pip wheel --no-cache --find-links=. *.gz
rm -f peek_*whl

zip -r peek_linux_plugins_${VER}.zip .
mv peek_linux_plugins_${VER}.zip ${DST_PATH}/

rm ./*.whl ./*.gz
