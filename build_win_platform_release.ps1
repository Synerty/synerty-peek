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
    @{"dir" = "$baseDir\client-build-ns";
        "packageJsonUrl" = "https://raw.githubusercontent.com/Synerty/peek-client-fe/master/peek_client_fe/build-ns/package.json"
    },
    @{"dir" = "$baseDir\client-build-web";
        "packageJsonUrl" = "https://raw.githubusercontent.com/Synerty/peek-client-fe/master/peek_client_fe/build-web/package.json"
    },
    @{"dir" = "$baseDir\server-build-web";
        "packageJsonUrl" = "https://raw.githubusercontent.com/Synerty/peek-server-fe/master/peek_server_fe/build-web/package.json"
    }
);

# ------------------------------------------------------------------------------
# Download node, npm, @angular/cli, typescript and tslint
Set-Location "$baseDir";
$nodeVer = "node-v7.7.3-win-x64";
$nodeUrl = "https://nodejs.org/dist/latest/$nodeVer.zip";
$nodeFile = "node.zip";
Invoke-WebRequest -Uri $nodeUrl -UseBasicParsing -OutFile $nodeFile;

Write-Host "Using standard windows zip handler, this will be slow";
Add-Type -Assembly System.IO.Compression.FileSystem;
[System.IO.Compression.ZipFile]::ExtractToDirectory("$baseDir\$nodeFile", $baseDir);

Remove-Item "$baseDir\$nodeFile" -Force -Recurse;
Move-Item "$nodeVer" "node"
Set-Location "$baseDir\node";
npm -g install --prefix "$baseDir\node" @angular/cli typescript tslint;

# ------------------------------------------------------------------------------
# Download the peek platform and all it's dependencies
New-Item "$baseDir\py" -ItemType directory;
Set-Location "$baseDir\py";
Write-Host "Downloading and creating windows wheels";
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

# Download shapely, it's not a dependency on windows because pip doesn't try to get the windows dist.
$shapeUrl = 'http://www.lfd.uci.edu/~gohlke/pythonlibs/tuth5y6k/Shapely-1.5.17-cp35-cp35m-win_amd64.whl';
$shapeFile = 'Shapely-1.5.17-cp35-cp35m-win_amd64.whl';
Invoke-WebRequest -Uri $shapeUrl -UseBasicParsing -OutFile $shapeFile;

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
