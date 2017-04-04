param([String]$wantedVer)

# Make Powershell stop if it has errors
$ErrorActionPreference = "Stop"

if (-Not [string]::IsNullOrEmpty($wantedVer)) {
    Write-Host "Requested version is $wantedVer"
}

# Get the current location
$startDir=Get-Location

$baseDir="$startDir\peek_dist_win";

# Delete the existing dist dir if it exists
If (Test-Path $baseDir){
    Remove-Item $baseDir -Force -Recurse;
}

# Create our new dist dir
New-Item $baseDir -ItemType directory;

# Define the node packages we want to download
$nodePackages = @(
    @{"dir" = "$baseDir\mobile-build-ns";
        "packageJsonUrl" = "https://raw.githubusercontent.com/Synerty/peek-mobile/master/peek_mobile/build-ns/package.json"
    }
);

# ------------------------------------------------------------------------------
# Download the node_packages
foreach ($element in $nodePackages) {
    # Get the variables for this package
    $nmDir = $element.Get_Item("dir");
    $packageJsonUrl = $element.Get_Item("packageJsonUrl");

    # Create the tmp dir
    New-Item "$nmDir\tmp" -ItemType directory;
    Set-Location "$nmDir\tmp";

    # Download pacakge.json
    Invoke-WebRequest -Uri $packageJsonUrl -UseBasicParsing -OutFile "package.json";

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
$releaseDir="$($baseDir)_$($peekPkgVer)";
$relaseZip="$($releaseDir).zip"
Move-Item $baseDir $releaseDir -Force;

# Create the zip file
Add-Type -Assembly System.IO.Compression.FileSystem;
$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal;
[System.IO.Compression.ZipFile]::CreateFromDirectory(
    $releaseDir, $relaseZip, $compressionLevel, $false)

# We're all done.
Write-Host "Successfully created release $peekPkgVer";
Write-Host "Located at $relaseZip";
