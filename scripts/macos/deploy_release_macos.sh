#!/usr/bin/env bash

set -o nounset
set -o errexit

platformZip="${1}"
pluginsZip="${2}"

if ! [ -f $platformZip ]
then
    echo "Platform release doesn't exist : $platformZip"
    exit 1
fi

if ! [ -f $pluginsZip ]
then
    echo "Plugins release doesn't exist : $pluginsZip"
fi

# ------------------------------------------------------------------------------
# Initialise variables and paths

# Get the current location
startDir=$(pwd)

releaseDir=$(echo ~/peek_platform_macos)

# Delete the existing dist dir if it exists
if [ -d ${releaseDir} ]
then
    echo "Deleting old extracted release"
    rm -rf ${releaseDir}
fi

# ------------------------------------------------------------------------------
# Extract the release to a interim directory

# Create the new release dir
mkdir -p ${releaseDir}

# Decompress the release
echo "Extracting release to $releaseDir"
tar xjf ${platformZip} -C ${releaseDir}

# ------------------------------------------------------------------------------
# Extract the plugins to a interim directory

if [ -f $pluginsZip ]
then
    echo "Extracting plugins to $releaseDir"
    tar xjf ${pluginsZip} -C ${releaseDir}
fi

# ------------------------------------------------------------------------------
# Create the virtual environment

# Get the release name from the package
echo "Get the release name from the package"
peekPkgVer=$(cd $releaseDir/platform && ls synerty_peek-* | cut -d'-' -f2)

# This variable is the path of the new virtualenv
venvDir="/Users/peek/synerty-peek-${peekPkgVer}"

# Check if this release is already deployed
# Delete the existing dist dir if it exists
if [ -d ${venvDir} ]
then
    echo "directory already exists : ${venvDir}"
    echo "This release is already deployed, delete it to re-deploy"
fi

# Create the new virtual environment
virtualenv $venvDir

# Activate the virtual environment
export PATH="$venvDir/bin:$PATH"

# ------------------------------------------------------------------------------
# Install the python packages

# install the platform wheels from the release
echo "Installing python community platform packages"
pushd "$releaseDir/platform"
pip install --no-index --no-cache --find-links=. synerty_peek*.whl
popd

# install the plugin wheels from the release
echo "Installing python community plugin packages"
pushd "$releaseDir/plugins"
pip install --no-index --no-cache --find-links=. peek_plugin*.whl
popd

# ------------------------------------------------------------------------------
# Install the python plugins

# install the py wheels from the release

if [ -f $pluginsZip ]
then
    echo "Installing python enterprise packages"
    pushd "$releaseDir/peek_enterprise_macos_${peekPkgVer}"
    pip install --no-index --no-cache --find-links=. peek_plugin*.whl
    popd
fi

# ------------------------------------------------------------------------------
# Install node

# Copy the node_modules into place
# This is crude, we kind of mash the two together
rsync -a $releaseDir/node/* ${venvDir}

# ------------------------------------------------------------------------------
# Install the frontend node_modules

# Make a var pointing to site-packages
sp="$(echo $venvDir/lib/python*/site-packages)"

# Move the node_modules into place
mv $releaseDir/field-app/node_modules $sp/peek_field_app
mv $releaseDir/office-app/node_modules $sp/peek_office_app
mv $releaseDir/admin-app/node_modules $sp/peek_admin_app

# ------------------------------------------------------------------------------
# Show complete message

echo " "
echo "Peek is now deployed to $venvDir"

# ------------------------------------------------------------------------------
# OPTIONALLY - Update the environment for the user.

q='"'
d='$'

echo " "
echo "Run the following to switch to the new releases environment :"
echo "export PATH=${q}${venvDir}/bin:${d}{PATH}${q}"
echo " "

if [ "${PEEK_AUTO_DEPLOY+x}" == "1" ]
then
    REPLY='Y'
else
    read -p "Do you want to permanently enable this release? " -n 1 -r
    echo # (optional) move to a new line
fi

if [[ $REPLY =~ ^[Yy]$ ]]
then
    sed -i "s,export PEEK_ENV.*,export PEEK_ENV=${q}${venvDir}${q},g" ~/.bash_profile
    echo " "
    echo "Done"
    echo " "
    echo "Close and reopen your terminal for the update to take effect"
fi

# ------------------------------------------------------------------------------
# Remove release dir

rm -rf ${releaseDir}
