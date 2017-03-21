param([String]$releaseZip)

# Make Powershell stop if it has errors
$ErrorActionPreference = "Stop"

$7zExe="C:\Program Files\7-Zip\7z.exe";

if ([string]::IsNullOrEmpty($releaseZip) -or [string]::IsNullOrWhitespace($releaseZip)) {
    Write-Error "Pass the path of the release to install to this script";
}


# Get the current location
$startDir=Get-Location

$releaseDir="C:\Users\peek\peek_dist_win";

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
# Get the release name from the package
$peekPkgName = Get-ChildItem "$releaseDir\py" |
                    Where-Object {$_.Name.StartsWith("synerty_peek-")} |
                    Select-Object -exp Name;
$peekPkgVer = $peekPkgName.Split('-')[1];

# This variable is the path of the new virtualenv
$venvDir = "C:\Users\peek\synerty-peek-$peekPkgVer";

# Check if this release is already deployed
If (Test-Path $venvDir){
    Write-Host "directory already exists : $venvDir";
    Write-Error "This release is already deployed, delete it to re-deploy";
}

# Create the new virtual environment
virtualenv.exe $venvDir

# Activate the virtual environment
$env:Path = "$venvDir\Scripts;$env:Path"

# Create the location of pip
# Instead of naming synerty-peek,
# Another approach is to install all packages " --no-deps * ",
pip install --no-index --no-cache --find-links "$releaseDir\py" synerty-peek Shapely

# Move the node_modules into place
$sp="$venvDir\Lib\site-packages";

Move-Item $releaseDir\mobile-build-ns\node_modules $sp\peek_mobile\build-ns -Force
Move-Item $releaseDir\mobile-build-web\node_modules $sp\peek_mobile\build-web -Force
Move-Item $releaseDir\admin-build-web\node_modules $sp\peek_admin\build-web -Force
Move-Item $releaseDir\node\* $venvDir\Scripts -Force

# Update the reference to the new environment.
# We probably won't want to do this here when we setup services.
Write-Host "Setting PEEK_ENV to $venvDir";
[Environment]::SetEnvironmentVariable("PEEK_VENV", $venvDir, "User");

# All done.
Write-Host "Peek is now deployed to $venvDir";
Write-Host " ";
Write-Host "Activate the new envrionment from command :";
Write-Host "    set PATH=`"$venvDir\Scripts;%PATH%`"";
Write-Host " ";
Write-Host "Activate the new envrionment from powershell :";
Write-Host "    `$env:Path = `"$venvDir\Scripts;`$env:Path`"";
