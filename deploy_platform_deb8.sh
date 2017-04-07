#!/usr/bin/env bash

releaseZip="${releaseZip:-$1}" # If VER is not defined, try arg 1

# Get the current location
startDir=`pwd`

releaseDir="$startDir/peek_dist"

# Delete the existing dist dir if it exists
echo "Delete the existing dist dir if it exists"
[ -d $releaseDir ] && rm -rf $releaseDir

# Create the new release dir
echo "Create the new release dir $releaseDir"
mkdir -p $releaseDir

# Decompress the release
echo "Decompress the release $releaseZip to $startDir"
unzip $releaseZip -d $startDir

# Get the release name from the package
echo "Get the release name from the package"
fullFile=$(find $releaseDir/py -name 'synerty_peek*')
echo $fullFile
peekPkgName=${fullFile##*/}
peekPkgName=${peekPkgName%-*-*-*}
echo "package name: $peekPkgName"
peekPkgVer=${peekPkgName##*-}
echo "package version: $peekPkgVer"

# This variable is the path of the new virtualenv
venvDir="/home/peek/synerty-peek-$peekPkgVer";
echo "Set virtual environment: $venvDir"

# Delete the existing dist dir if it exists
[ -d $venvDir ] && echo "This release is already deployed, delete it to re-deploy"; exit

# Create the new virtual environment
virtualenv $venvDir

# Activate the virtual environment
export PATH="$venvDir\Scripts;%PATH%"

# install synerty
pip install --no-index --no-cache --find-links "$releaseDir\py" synerty-peek

# Move the node_modules into place
sp="$venvDir/Lib/site-packages";
mv $releaseDir/mobile-build-web/node_modules $sp/peek_mobile/build-web
mv $releaseDir/admin-build-web/node_modules $sp/peek_admin/build-web
mv $releaseDir/node/* $venvDir/Scripts

echo " "
echo "Peek is now deployed to $venvDir"
echo " "
echo "Activate the new environment, edit '~/.bashrc' and insert the following after the
first block comment but before lines like: '# If not running interactively, don't do
anything'"
echo "export PATH="$venvDir\Scripts:$PATH""
echo " "
