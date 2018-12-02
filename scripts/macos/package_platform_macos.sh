#!/usr/bin/env bash

source ~/.bash_profile

set -o nounset
set -o errexit

wantedVer=${1-}
wantedVer=${wantedVer/v/}

if [ -n ${wantedVer} ]; then
    echo "Requested version is $wantedVer"
fi

startDir=`pwd`

baseDir="$startDir/peek_dist_macos"

[ -d $baseDir ] && rm -rf $baseDir


# ------------------------------------------------------------------------------
# Download the peek platform and all it's dependencies

# Create the dir for the py wheels
mkdir -p $baseDir/py
cd $baseDir/py

echo "Downloading and creating wheels"
if [ -n ${wantedVer} ]; then
    pip wheel --no-cache synerty-peek==${wantedVer}
else
    pip wheel --no-cache synerty-peek
fi

# Make sure we've downloaded the right version
peekPkgVer=`ls synerty_peek-* | cut -d'-' -f2`

if [ -n "${wantedVer}" -a "${wantedVer}" -ne "${peekPkgVer}" ]; then
   echo "We've downloaded version ${peekPkgVer}, but you wanted ver ${wantedVer}"
else
    echo "We've downloaded version ${peekPkgVer}"
fi

# These are installed as a dependency on macOS
# *     Shapely
# *     pymssql

# ------------------------------------------------------------------------------
# Compile nodejs for the release.
# This should be portable.

nodeDir="$baseDir/node"

cd $baseDir
nodeVer="8.11.3"

# Download the file
nodeFile="node-v${nodeVer}-darwin-x64.tar.gz"
curl -O "https://nodejs.org/dist/v${nodeVer}/node-v${nodeVer}-darwin-x64.tar.gz"

# Unzip it
gunzip -c ${nodeFile} | tar xopf -
mv node-v${nodeVer}-darwin-x64 ${nodeDir}

# Remove the downloaded file
rm -rf ${nodeFile}

# Move NODE into place

# Set the path for future NODE commands
PATH="$nodeDir/bin:$PATH"

# Install the required NPM packages
npm cache clean --force
npm -g install @angular/cli@~6.0.0 typescript@~2.7.2 tslint

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
    curl -O "$packageJsonUrl"

    # Download package-lock.json
    curl -O "$packageLockJsonUrl"

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
mobilePackageVer=`cd $baseDir/py && ls peek_mobile-* | cut -d'-' -f2`
mobileBuildWebDIR="$baseDir/mobile-build-web"
mobileJsonUrl="https://bitbucket.org/synerty/peek-mobile/raw/${mobilePackageVer}/peek_mobile/build-web"
downloadNodeModules $mobileBuildWebDIR $mobileJsonUrl

# DESKTOP node modules
desktopPackageVer=`cd $baseDir/py && ls peek_desktop-* | cut -d'-' -f2`
desktopBuildWebDIR="$baseDir/desktop-build-web"
desktopJsonUrl="https://bitbucket.org/synerty/peek-desktop/raw/${desktopPackageVer}/peek_desktop/build-web"
downloadNodeModules $desktopBuildWebDIR $desktopJsonUrl

# ADMIN node modules
adminPackageVer=`cd $baseDir/py && ls peek_admin-* | cut -d'-' -f2`
adminBuildWebDIR="$baseDir/admin-build-web"
adminJsonUrl="https://bitbucket.org/synerty/peek-admin/raw/${adminPackageVer}/peek_admin/build-web"
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
