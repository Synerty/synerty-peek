param ([String]$wantedVer)

$wantedVer = $wantedVer -replace "v", ""

# Make Powershell stop if it has errors
$ErrorActionPreference = "Stop"

# Try many TLS versions
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"

$7zExe = "C:\Program Files\7-Zip\7z.exe";

if (-Not [string]::IsNullOrEmpty($wantedVer))
{
    Write-Host "Requested version is $wantedVer"
}

# Get the current location
$startDir = Get-Location

$baseDir = "$startDir\peek_platform_win";

# Delete the existing dist dir if it exists
If (Test-Path $baseDir)
{
    Remove-Item $baseDir -Force -Recurse;
}

# Create our new dist dir
New-Item $baseDir -ItemType directory;

# ------------------------------------------------------------------------------
# Download the peek platform and all it's dependencies

# Create the dir for the py wheels
New-Item "$baseDir\py" -ItemType directory;
Set-Location "$baseDir\py";

# -------------

Write-Host "Downloading and windows wheels";

# Download from https://www.lfd.uci.edu/~gohlke/pythonlibs

# Define the extra wheels we need to download
$extraWheels = @(
# Download shapely, it's not a dependency on windows because pip doesn't try to get the windows dist.
@{
    "file" = "Shapely-1.6.4.post1-cp36-cp36m-win_amd64.whl";
    "url" = "https://download.lfd.uci.edu/pythonlibs/u2hcgva4"
},

# Download pymssql, As to 11/Apr/2017, there are no standard built wheels for 3.6.1
@{
    "file" = "pymssql-2.1.4-cp36-cp36m-win_amd64.whl";
    "url" = "https://download.lfd.uci.edu/pythonlibs/u2hcgva4"
}
);

# Download and check the extra wheels
foreach ($wheel in $extraWheels)
{
    # Get the variables for this package
    $file = $wheel.Get_Item("file");
    $url = "$($wheel.Get_Item("url") )/$( $file )";

    Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $file;

    if ((get-item $file).length -lt 10000)
    {
        Write-Error "$file has a new version update"
    }
}

# -------------

Write-Host "Downloading and creating wheels";
if ( [string]::IsNullOrEmpty($wantedVer))
{
    pip wheel --no-cache synerty-peek;
}
else
{
    pip wheel --no-cache "synerty-peek==$wantedVer";
}

# Make sure we've downloaded the right version
$peekPkgName = Get-ChildItem ".\" |
    Where-Object { $_.Name.StartsWith("synerty_peek-") } |
    Select-Object -exp Name;
$peekPkgVer = $peekPkgName.Split('-')[1];

if (-Not [string]::IsNullOrEmpty($wantedVer) -and $peekPkgVer -ne $wantedVer)
{
    Set-Location "$startDir";
    Write-Error "We've downloaded version $peekPkgVer, but you wanted ver $wantedVer";
}
else
{
    Write-Host "We've downloaded version $peekPkgVer";
}


# ------------------------------------------------------------------------------
# Download node, npm, @angular/cli, typescript and tslint

Set-Location "$baseDir";
$nodeVer = "18.16.1";

# Download the file
$nodeUrl = "https://nodejs.org/dist/v$nodeVer/node-v$nodeVer-win-x64.zip";
$nodeFile = "node.zip";
Invoke-WebRequest -Uri $nodeUrl -UseBasicParsing -OutFile $nodeFile;

# Unzip it


if (Test-Path $7zExe)
{
    Write-Host "7z is present, this will be faster";
    Invoke-Expression "&`"$7zExe`" x -y -r `"$baseDir\$nodeFile`" -o`"$baseDir`"";

}
else
{
    Write-Host "Using standard windows zip handler, this will be slow";
    Add-Type -Assembly System.IO.Compression.FileSystem;
    [System.IO.Compression.ZipFile]::ExtractToDirectory("$baseDir\$nodeFile", $baseDir);
}

# Remove the downloaded file
Remove-Item "$baseDir\$nodeFile" -Force -Recurse;

# Move NODE into place
Move-Item "node-v$nodeVer-win-x64" "node";

# Set the path for future NODE commands
$env:Path = "$baseDir\node;$env:Path";

# Install the required NPM packages
npm cache clean --force
npm -g install @angular/cli@^16.1.1 typescript@5.1.5 tslint


# ------------------------------------------------------------------------------
# Download the node_packages


# Define the node packages we want to download
$nodePackages = @(
@{
    "package" = "peek_field_app";
    "dir" = "$baseDir\mobile-build-web";
    "packageJsonBaseUrl" = "https://bitbucket.org/synerty/peek-field-app/raw/"
},
@{
    "package" = "peek_office_app";
    "dir" = "$baseDir\desktop-build-web";
    "packageJsonBaseUrl" = "https://bitbucket.org/synerty/peek-office-app/raw/"
},
@{
    "package" = "peek_admin_app";
    "dir" = "$baseDir\admin-build-web";
    "packageJsonBaseUrl" = "https://bitbucket.org/synerty/peek-admin-app/raw/"
}
);

foreach ($element in $nodePackages)
{
    $packageName = $element.Get_Item("package");

    # Make sure we've downloaded the right version
    $peekPkgName = Get-ChildItem "$baseDir\py" |
        Where-Object { $_.Name.StartsWith($packageName + "-") } |
        Select-Object -exp Name;
    $peekUiPkgVer = $peekPkgName.Split('-')[1];

    # Get the variables for this package
    $nmDir = $element.Get_Item("dir");
    $packageJsonBaseUrl = $element.Get_Item("packageJsonBaseUrl") + "$peekUiPkgVer/$packageName";
    $packageJsonUrl = $packageJsonBaseUrl + "/package.json";
    $packageLockJsonUrl = $packageJsonBaseUrl + "/package-lock.json";

    # Create the tmp dir
    New-Item "$nmDir\tmp" -ItemType directory;
    Set-Location "$nmDir\tmp";

    # Download package.json
    Write-Host "Downloading $packageLockJsonUrl";
    Invoke-WebRequest -Uri $packageJsonUrl -UseBasicParsing -OutFile "package.json";

    # Download package-lock.json
    Write-Host "Downloading $packageLockJsonUrl";
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
$releaseDir = "$( $baseDir )_$( $peekPkgVer )";
$releaseZip = "$( $releaseDir ).zip"
Move-Item $baseDir $releaseDir -Force;

# Delete an old release zip if it exists
If (Test-Path $releaseZip)
{
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
