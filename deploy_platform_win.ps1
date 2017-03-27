param([String]$releaseZip)

# Make PowerShell stop if it has errors
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

# node modules are not required unless developing, which will be installed later.
# Move-Item $releaseDir\mobile-build-ns\node_modules $sp\peek_mobile\build-ns -Force
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

# Ask if the user would like to update the PATH environment variables
$title = "Environment Variables"
$message = "Do you want to update the PATH System Environment Variables with the newly deploy virtual environment: '"+$venvDir+"' and remove any other 'synerty-peek' System Environment Variables?"

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
    "I want to update the PATH System Environment Variables."

$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
    "I do NOT want the PATH System Environment Variables changed."

$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

$result = $host.ui.PromptForChoice($title, $message, $options, 0) 

switch ($result)
    {
        0 {"You selected Yes.";

            $PathVariables = $venvDir;

            Write-Host "Added PATH variable:" $PathVariables;

            ([Environment]::GetEnvironmentVariable("PATH", "Machine")).split(';') | foreach-object { 
                if ($_ -notmatch $SynertyPeek) 
                { $PathVariables=$PathVariables+';'+$_ } 
                Else 
                { Write-Host " ";
                    Write-Host "Removed PATH variable:" $_ ;
                } 
            }
            [Environment]::SetEnvironmentVariable("PATH", $PathVariables, "Machine");
            Write-Host " ";
            Write-Host "Environment Variables have been updated."
            Write-Host " ";
            Write-Host "IMPORTANT, you must restart the PowerShell window for the Environment Variable changes to take effect!"
        }
    
        1 {"You selected No.";
            Write-Host " ";
            Write-Host "Activate the new environment from command :";
            Write-Host "    set PATH=`"$venvDir\Scripts;%PATH%`"";
            Write-Host " ";
            Write-Host "Activate the new environment from PowerShell :";
            Write-Host "    `$env:Path = `"$venvDir\Scripts;`$env:Path`"";
        }
    }