param([String]$wantedVer)

# Make Powershell stop if it has errors
$ErrorActionPreference = "Stop"

if (-Not [string]::IsNullOrEmpty($wantedVer)) {
    Write-Host "Requested version is $wantedVer"
}

# Get the current location
$startDir = Get-Location

$baseDir = "$startDir\peek_dist_win";

# Delete the existing dist dir if it exists
If (Test-Path $baseDir) {
    Remove-Item $baseDir -Force -Recurse;
}

# Create our new dist dir
New-Item $baseDir -ItemType directory;

# ------------------------------------------------------------------------------
# Download the peek platform and all it's dependencies

# Create the dir for the py wheels
New-Item "$baseDir\py" -ItemType directory;
Set-Location "$baseDir\py";

Write-Host "Downloading and creating wheels";
pip wheel --no-cache synerty-peek;

# Make sure we've downloaded the right version
$peekPkgName = Get-ChildItem ".\" |
    Where-Object {$_.Name.StartsWith("synerty_peek-")} |
    Select-Object -exp Name;
$peekPkgVer = $peekPkgName.Split('-')[1];

if (-Not [string]::IsNullOrEmpty($wantedVer) -and $peekPkgVer -ne $wantedVer) {
    Set-Location "$startDir";
    Write-Error "We've downloaded version $peekPkgVer, but you wanted ver $wantedVer";
} else {
    Write-Host "We've downloaded version $peekPkgVer";
}

# Define the extra wheels we need to download
$extraWheels = @(
    # Download shapely, it's not a dependency on windows because pip doesn't try to get the windows dist.
    @{
        "file" = "Shapely-1.5.17-cp36-cp36m-win_amd64.whl";
        "url" = "http://www.lfd.uci.edu/%7Egohlke/pythonlibs/tuft5p8b"
    },

    # Download pymssql, As to 11/Apr/2017, there are no standard built wheels for 3.6.1
    @{
        "file" = "pymssql-2.1.3-cp36-cp36m-win_amd64.whl";
        "url" = "http://www.lfd.uci.edu/%7Egohlke/pythonlibs/tuft5p8b"
    }
);

# Download and check the extra wheels
foreach ($wheel in $extraWheels) {
    # Get the variables for this package
    $file = $wheel.Get_Item("file");
    $url = "$($wheel.Get_Item("url"))/$($file)";

    Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $file;

    if ( (get-item $file).length -lt 10000) {
        Write-Error "$file has a new version update"
    }
}


# ------------------------------------------------------------------------------
# Download node, npm, @angular/cli, typescript and tslint

Set-Location "$baseDir";
$nodeVer = "8.2.1";

# Download the file
$nodeUrl = "https://nodejs.org/dist/v$nodeVer/node-v$nodeVer-win-x64.zip";
$nodeFile = "node.zip";
Invoke-WebRequest -Uri $nodeUrl -UseBasicParsing -OutFile $nodeFile;

# Unzip it
Write-Host "Using standard windows zip handler, this will be slow";
Add-Type -Assembly System.IO.Compression.FileSystem;
[System.IO.Compression.ZipFile]::ExtractToDirectory("$baseDir\$nodeFile", $baseDir);

# Remove the downloaded file
Remove-Item "$baseDir\$nodeFile" -Force -Recurse;

# Move NODE into place
Move-Item "node-v$nodeVer-win-x64" "node";

# Set the path for future NODE commands
$env:Path = "$baseDir\node;$env:Path";

# Install the required NPM packages
npm cache clean --force
npm -g install @angular/cli@1.2.7 typescript@2.3.4 tslint


# ------------------------------------------------------------------------------
# Download the node_packages


# Define the node packages we want to download
$nodePackages = @(
    @{"dir" = "$baseDir\mobile-build-web";
        "packageJsonBaseUrl" = "https://raw.githubusercontent.com/Synerty/peek-mobile/$peekPkgVer/peek_mobile/build-web"
    },
    @{"dir" = "$baseDir\desktop-build-web";
        "packageJsonBaseUrl" = "https://raw.githubusercontent.com/Synerty/peek-desktop/$peekPkgVer/peek_desktop/build-web"
    },
    @{"dir" = "$baseDir\admin-build-web";
        "packageJsonBaseUrl" = "https://raw.githubusercontent.com/Synerty/peek-admin/$peekPkgVer/peek_admin/build-web"
    }
);

foreach ($element in $nodePackages) {
    # Get the variables for this package
    $nmDir = $element.Get_Item("dir");
    $packageJsonBaseUrl = $element.Get_Item("packageJsonBaseUrl");
    $packageJsonUrl = $packageJsonBaseUrl + "/package.json";
    $packageLockJsonUrl = $packageJsonBaseUrl + "/package-lock.json";

    # Create the tmp dir
    New-Item "$nmDir\tmp" -ItemType directory;
    Set-Location "$nmDir\tmp";

    # Download package.json
    Invoke-WebRequest -Uri $packageJsonUrl -UseBasicParsing -OutFile "package.json";

    # Download package-lock.json
    Invoke-WebRequest -Uri $packageLockJsonUrl -UseBasicParsing -OutFile "package-lock.json";

    # run npm install
    npm install

    # Move to where we want node_modules and delete the tmp dir
    # some packages create extra files that we don't want
    Set-Location $nmDir;
    Move-Item "tmp\node_modules" ".\"

    # Cleanup the temp dir
    Remove-Item "tmp" -Force -Recurse;
}

# ------------------------------------------------------------------------------
# Set the location back to where we were.
Set-Location $startDir;

# Finally, version the directory
$releaseDir = "$($baseDir)_$($peekPkgVer)";
$releaseZip = "$($releaseDir).zip"
Move-Item $baseDir $releaseDir -Force;

# Delete an old release zip if it exists
If (Test-Path $releaseZip) {
    Remove-Item $releaseZip -Force;
}

# Create the zip file
Write-Host "Compressing the release";
Add-Type -Assembly System.IO.Compression.FileSystem;
$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal;
[System.IO.Compression.ZipFile]::CreateFromDirectory(
    $releaseDir, $releaseZip, $compressionLevel, $false)

# Remove the working dir
Remove-Item $releaseDir -Force -Recurse;

# We're all done.
Write-Host "Successfully created release $peekPkgVer";
Write-Host "Located at $releaseZip";
