#!/usr/bin/env bash

source ~/.bashrc

set -o nounset
set -o errexit

wantedVer=${1-}

if [ -n ${wantedVer} ]; then
    echo "Requested version is $wantedVer"
fi

startDir=`pwd`

baseDir="$startDir/peek_dist_deb8"

[ -d $baseDir ] && rm -rf $baseDir


# ------------------------------------------------------------------------------
# Download the peek platform and all it's dependencies

# Create the dir for the py wheels
mkdir -p $baseDir/py
cd $baseDir/py

echo "Downloading and creating wheels"
pip wheel --no-cache synerty-peek

# Make sure we've downloaded the right version
peekPkgVer=`ls synerty_peek-* | cut -d'-' -f2`

if [ -n "${wantedVer}" -a "${wantedVer}" -ne "${peekPkgVer}" ]; then
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
nodeVer="7.7.4"

# Download the file
nodeFile="node-v${PEEK_NODE_VER}-linux-x64.tar.xz"
wget -nv "https://nodejs.org/dist/v${PEEK_NODE_VER}/node-v${PEEK_NODE_VER}-linux-x64.tar.xz"

# Unzip it
tar xJf ${nodeFile}
mv node-v${PEEK_NODE_VER}-linux-x64 ${nodeDir}

# Remove the downloaded file
rm -rf ${nodeFile}

# Move NODE into place

# Set the path for future NODE commands
PATH="$nodeDir/bin:$PATH"

# Install the required NPM packages
npm -g upgrade npm
npm -g install @angular/cli typescript tslint

# ------------------------------------------------------------------------------
# This function downloads the node modules and prepares them for the release

function downloadNodeModules {
    # Get the variables for this package
    nmDir=$1
    packageJsonUrl=$2

    # Create the tmp dir
    mkdir -p "$nmDir/tmp"
    cd "$nmDir/tmp"

    # Download package.json
    wget -nv "$packageJsonUrl"

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
mobileJsonUrl='https://bitbucket.org/synerty/peek-mobile/raw/master/peek_mobile/build-web/package.json'
downloadNodeModules $mobileBuildWebDIR $mobileJsonUrl

# ADMIN node modules
adminBuildWebDIR="$baseDir/admin-build-web"
adminJsonUrl='https://bitbucket.org/synerty/peek-admin/raw/master/peek_admin/build-web/package.json'
downloadNodeModules $adminBuildWebDIR $adminJsonUrl

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