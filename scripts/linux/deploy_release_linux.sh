#!/usr/bin/env bash

set -o nounset
set -o errexit

IS_DEBIAN=0
IS_REDHAT=0

if [ -f /etc/redhat-release ]
then
    IS_REDHAT=1
elif [ -f /etc/debian_version ]
then
    IS_DEBIAN=1
else
    echo "Unknown OS type" >&2
    exit 1
fi

communityZip="${1}"
enterpriseZip="${2}"

if ! [ -f $communityZip ]
then
    echo "community release doesn't exist : $communityZip"
    exit 1
fi

if ! [ -f $enterpriseZip ]
then
    echo "Enterprise release doesn't exist : $enterpriseZip"
fi

# ------------------------------------------------------------------------------
# Initialise variables and paths

# Get the current location
startDir=$(pwd)

releaseDir=$(echo ~/peek_community_linux)

# Delete the existing dist dir if it exists
if [ -d ${releaseDir} ]
then
    echo "Deleting old extracted release"
    rm -rf ${releaseDir}
fi

# ------------------------------------------------------------------------------
# Extract the community to an interim directory

# Create the new release dir
mkdir -p ${releaseDir}

# Decompress the release
echo "Extracting community to $releaseDir"
tar xjf ${communityZip} -C ${releaseDir}

# ------------------------------------------------------------------------------
# Extract the release to a interim directory

if [ -f $enterpriseZip ]
then
    echo "Extracting plugins to $releaseDir"
    tar xjf ${enterpriseZip} -C ${releaseDir}
fi

# ------------------------------------------------------------------------------
# Create the virtual environment

# Get the release name from the package
echo "Get the release name from the package"
peekPkgVer=$(cd $releaseDir/platform && ls synerty_peek-* | cut -d'-' -f2)

# This variable is the path of the new virtualenv
venvDir="/home/peek/synerty-peek-${peekPkgVer}"

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
# Install the enterprise python plugins

# install the py wheels from the release
if [ -f $enterpriseZip ]
then
    echo "Installing python enterprise packages"
    pushd "$releaseDir/peek_enterprise_linux_${peekPkgVer}"
    pip install --no-index --no-cache --find-links=. peek_*.whl
    popd
fi

# ------------------------------------------------------------------------------
# Install node

# Copy the node_modules into place
# This is crude, we kind of mash the two together
cp -pr $releaseDir/node/* ${venvDir}

# ------------------------------------------------------------------------------
# Install the frontend node_modules

# Make a var pointing to site-packages
sp="$(echo $venvDir/lib/python*/site-packages)"

# Move the node_modules into place
mv $releaseDir/field-app/node_modules $sp/peek_field_app
mv $releaseDir/office-app/node_modules $sp/peek_office_app
mv $releaseDir/admin-app/node_modules $sp/peek_admin_app
if [ -f $enterpriseZip ]
then
    cp -r $releaseDir/peek_enterprise_linux*/ednar-peek-app/node_modules \
     $sp/peek_plugin_zepben_ednar_dms_diagram/_private/office-app
fi

# ------------------------------------------------------------------------------
# Install the util scripts

# Set the init scripts as executable
chmod +x $releaseDir/util/*

# Install the scripts into the virtual environment bin directory
cp -pr $releaseDir/util/* ${venvDir}/bin

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
    sed -i "s,export PEEK_ENV.*,export PEEK_ENV=${q}${venvDir}${q},g" ~/.bashrc
    echo " "
    echo "Done"
    echo " "
    echo "Close and reopen your terminal for the update to take effect"
fi

# ------------------------------------------------------------------------------
# OPTIONALLY - Set the init scripts for auto start

if [ "${PEEK_AUTO_DEPLOY+x}" == "1" ]
then
    REPLY='Y'
else
    read -p "Do you want to update the init scripts to auto start peek? " -n 1 -r
    echo # (optional) move to a new line
fi

if [[ $REPLY =~ ^[Yy]$ ]]
then
    for s in peek_logic peek_worker peek_office peek_field peek_agent
    do
        FILE="${s}.service"
        TO="/lib/systemd/system/"

        sudo cp -p $releaseDir/init/${FILE} ${TO}
        sudo chmod +x ${TO}/${FILE}
        sudo chown root:root ${TO}/${FILE}
        sudo sed -i "s,#PEEK_DIR#,$venvDir/bin,g" ${TO}/${FILE}
        sudo sed -i "s,#ORACLE_HOME#,${ORACLE_HOME},g" ${TO}/${FILE}
        sudo sed -i "s,#PEEK_HOME#,${HOME},g" ${TO}/${FILE}
        sudo systemctl enable $s
        sudo systemctl restart $s

    done

    sudo systemctl daemon-reload

    echo " "
    echo "Done"
    echo " "
fi

# ------------------------------------------------------------------------------
# Remove release dir

rm -rf ${releaseDir}

# ------------------------------------------------------------------------------
# KILL ALL THE SHELLS

# Force exit of the schell to update the environment variable
echo "Killing all bash sessions in 5 seconds"
echo " "
echo "This will force an environment, avoiding :"
echo "'Confusion and Delay', Fat Controller"

sleep 5s

pkill -9 -u $USER -f bash
