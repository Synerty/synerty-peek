#!/usr/bin/env bash

source ~/.bashrc

set -o nounset
set -o errexit

wantedVer=${1-}
wantedVer=${wantedVer/v/}
platformReposDir=${2}
platformPackagesDir=${3}
pinnedDepsPyFile=${4}

if [ -n ${wantedVer} ]; then
    echo "Requested version is $wantedVer"
fi

startDir=${4:-`pwd`}

baseDir="$startDir/peek_platform_linux"

[ -d $baseDir ] && rm -rf $baseDir


# ------------------------------------------------------------------------------
# Download the peek platform and all it's dependencies

# Create the dir for the py wheels
mkdir -p $baseDir/py
cd $baseDir/py

pipWheelArgs=" --no-cache --find-links=${platformPackagesDir}"
if [ -f "${pinnedDepsPyFile}" ]; then
    echo "Using requirements file : ${pinnedDepsPyFile}"
    pipWheelArgs="-r ${pinnedDepsPyFile} $pipWheelArgs"
else
    echo "Requirements file is missing : ${pinnedDepsPyFile}"
fi

echo "Downloading and creating wheels"
if [ -n "${wantedVer}" ]; then
    pip wheel synerty-peek==${wantedVer} $pipWheelArgs
else
    pip wheel synerty-peek $pipWheelArgs
fi

# Make sure we've downloaded the right version
peekPkgVer=`cd $baseDir/py && ls synerty_peek-* | cut -d'-' -f2`

if [ -n "${wantedVer}" -a "${wantedVer}" != "${peekPkgVer}" ]; then
   echo "We've downloaded version ${peekPkgVer}, but you wanted ver ${wantedVer}"
else
    echo "We've downloaded version ${peekPkgVer}"
fi

# These are installed as a dependency on Linux
# *     Shapely
# *     pymssql

# ------------------------------------------------------------------------------
# Compile nodejs for the release.
# This should be portable.

nodeDir="$baseDir/node"

cd $baseDir
nodeVer="10.16.0"

# Download the file
nodeFile="node-v${nodeVer}-linux-x64.tar.xz"
wget -nv "https://nodejs.org/dist/v${nodeVer}/node-v${nodeVer}-linux-x64.tar.xz"

# Unzip it
tar xJf ${nodeFile}
mv node-v${nodeVer}-linux-x64 ${nodeDir}

# Remove the downloaded file
rm -rf ${nodeFile}

# Move NODE into place

# Set the path for future NODE commands
PATH="$nodeDir/bin:$PATH"

# Install the required NPM packages
npm cache clean --force
npm -g install @angular/cli@^8.1.2 typescript@3.4.5 tslint

# ------------------------------------------------------------------------------
# This function downloads the node modules and prepares them for the release

function downloadNodeModules {
    # Get the variables for this package
    nmDir=$1
    packageJsonUrl="$2/package.json"
    packageLockJsonUrl="$2/package-lock.json"

    # Create the tmp dir
    mkdir -p "$nmDir/tmp"
    cd "$nmDir/tmp"

    # Download package.json
    cp "$packageJsonUrl" .

    cp "$packageLockJsonUrl" .
    # run npm install
    npm install

    # Move to where we want node_modules and delete the tmp dir
    # some packages create extra files that we don't want
    cd $nmDir
    mv tmp/node_modules .

    # Cleanup the temp dir
    rm -rf tmp
}

# MOBILE node modules
mobileBuildWebDIR="$baseDir/mobile-build-web"
mobileJsonUrl="${platformReposDir}/peek-mobile/peek_mobile/build-web"
downloadNodeModules $mobileBuildWebDIR $mobileJsonUrl

# DESKTOP node modules
desktopBuildWebDIR="$baseDir/desktop-build-web"
desktopJsonUrl="${platformReposDir}/peek-desktop/peek_desktop/build-web"
downloadNodeModules $desktopBuildWebDIR $desktopJsonUrl

# ADMIN node modules
adminBuildWebDIR="$baseDir/admin-build-web"
adminJsonUrl="${platformReposDir}/peek-admin/peek_admin/build-web"
downloadNodeModules $adminBuildWebDIR $adminJsonUrl

# ------------------------------------------------------------------------------
# Copy over the init scripts for this platform

mkdir $baseDir/init && pushd $baseDir/init

for s in peek_server peek_worker peek_agent peek_client
do
    cp ${platformReposDir}/synerty-peek/scripts/linux/init/${s}.service ${s}.service
done
popd

# ------------------------------------------------------------------------------
# Copy over the util scripts for this platform

mkdir $baseDir/util && pushd $baseDir/util

utilScripts="restart_peek.sh stop_peek.sh"
for s in $utilScripts
do
    cp ${platformReposDir}/synerty-peek/scripts/linux/util/${s} ${s}
done
popd


# ------------------------------------------------------------------------------
# Set the location back to where we were.
cd $startDir

# Finally, version the directory
releaseDir="${baseDir}_${peekPkgVer}";
releaseZip="${releaseDir}.tar.bz2"
mv ${baseDir} ${releaseDir}


# Delete an old release zip if it exists
if [ -f ${releaseZip} ]; then
    rm ${releaseZip}
fi

# Create the zip file
echo "Compressing the release"
(cd ${releaseDir} && tar cjf ${releaseZip} *)

# Remove the working dir
rm -rf ${releaseDir}

# We're all done.
echo "Successfully created release ${peekPkgVer}";
echo "Located at ${releaseZip}";
