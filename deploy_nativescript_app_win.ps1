param([String]$peekPkgVer,
    [String]$releaseZip)

# Make PowerShell stop if it has errors
$ErrorActionPreference = "Stop"

$7zExe="C:\Program Files\7-Zip\7z.exe";

if ([string]::IsNullOrEmpty($releaseZip) -or [string]::IsNullOrWhitespace($releaseZip)) {
    Write-Error "Pass the path of the release to install to this script";
}


# Get the current location
$startDir=Get-Location

$releaseDir="C:\Users\peek\peek_dist_nativescript_app_win";

# Delete the existing dist dir if it exists
If (Test-Path $releaseDir){
    Remove-Item $releaseDir -Force -Recurse;
}

# Create our new release dir
New-Item $releaseDir -ItemType directory;

# Decompress the release
Write-Host "Extracting release to $releaseDir";

if (Test-Path $7zExe) {
    Write-Host "7z is present, this will be faster";
    Invoke-Expression "&`"$7zExe`" x -y -r `"$releaseZip`" -o`"$releaseDir`"";

} else {
    Write-Host "Using standard windows zip handler, this will be slow";
    Add-Type -Assembly System.IO.Compression.FileSystem;
    [System.IO.Compression.ZipFile]::ExtractToDirectory($releaseZip, $releaseDir);
}

# This variable is the path of the virtualenv being deployed to
$venvDir = "C:\Users\peek\synerty-peek-$peekPkgVer";

# Check if this release is already deployed
If (Test-Path $venvDir){
} else {
    Write-Error "This release doesn't exist, check the version number you passed into the script and run again.";
}

# ------------------------------------------------------------------------------
# Check if this node_modules already exists
$sp="$venvDir\Lib\site-packages";

If (Test-Path $sp\mobile-build-ns\node_modules){
    Write-Host "directory already exists : $sp\mobile-build-ns\node_modules";
    Write-Error "This NativeScript App already exist, delete it to re-deploy";
}

# Move the node_modules into place
Move-Item $releaseDir\mobile-build-ns\node_modules $sp\peek_mobile\build-ns -Force

# All done.
Write-Host "NativeScript App depenencies are now deployed to $venvDir";
Write-Host " ";
