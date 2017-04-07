#!/usr/bin/env bash

DIR=`pwd`

releaseDIR="$DIR/peek_dist"

[ -d peek_dist ] && rm -rf $releaseDIR

pyDIR="$releaseDIR/py"
mkdir -p $pyDIR
mobileBuildWebDIR="$releaseDIR/mobile-build-web"
mkdir -p "$mobileBuildWebDIR/tmp"
adminBuildWebDIR="$releaseDIR/admin-build-web"
mkdir -p "$adminBuildWebDIR/tmp"

cd "$mobileBuildWebDIR/tmp"
wget 'https://bitbucket.org/synerty/peek-mobile/raw/a210c0c4e4d38737d4f95b5bc14aa44883e91e65/peek_mobile/build-web/package.json'
npm install
cd ..
mv tmp/node_modules .
rm -rf tmp

cd "$adminBuildWebDIR/tmp"
wget 'https://bitbucket.org/synerty/peek-admin/raw/ce28c00052fbb75bf022072850b95882783794f4/peek_admin/build-web/package.json'
npm install
cd ..
mv tmp/node_modules .
rm -rf tmp

cd $pyDIR
pip install wheel
pip wheel --no-cache synerty-peek

cd $DIR

# Decompress the release
echo "Compress the release $releaseDIR to $DIR"
zip -r peek_dist_lin.zip $releaseDIR