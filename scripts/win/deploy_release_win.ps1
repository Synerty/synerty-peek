param([String]$platformZip, [String]$pluginsZip)

# Make PowerShell stop if it has errors
$ErrorActionPreference = "Stop"

$7zExe = "C:\Program Files\7-Zip\7z.exe";

if ([string]::IsNullOrEmpty($platformZip) -or [string]::IsNullOrWhitespace($platformZip))
{
    Write-Error "Pass the path of the platform release to this script";
}

if ([string]::IsNullOrEmpty($pluginsZip) -or [string]::IsNullOrWhitespace($pluginsZip))
{
    Write-Error "Pass the path of the plugins release to this script";
}


# ------------------------------------------------------------------------------
# Initialise variables and paths

# Get the current location
$startDir = Get-Location

$releaseDir = "C:\Users\peek\peek_platform_win";

# Delete the existing dist dir if it exists
If (Test-Path $releaseDir)
{
    Remove-Item $releaseDir -Force -Recurse;
}

# ------------------------------------------------------------------------------
# Extract the platform to a interim directory

# Create our new release dir
New-Item $releaseDir -ItemType directory;

# Decompress the release
Write-Host "Extracting platform to $releaseDir";

if (Test-Path $7zExe)
{
    Write-Host "7z is present, this will be faster";
    Invoke-Expression "&`"$7zExe`" x -y -r `"$platformZip`" -o`"$releaseDir`"";

}
else
{
    Write-Host "Using standard windows zip handler, this will be slow";
    Add-Type -Assembly System.IO.Compression.FileSystem;
    [System.IO.Compression.ZipFile]::ExtractToDirectory($platformZip, $releaseDir);
}

# ------------------------------------------------------------------------------
# Extract the plugins to a interim directory

Write-Host "Extracting plugins to $releaseDir";

if (Test-Path $7zExe)
{
    Write-Host "7z is present, this will be faster";
    Invoke-Expression "&`"$7zExe`" x -y -r `"$pluginsZip`" -o`"$releaseDir`"";

}
else
{
    Write-Host "Using standard windows zip handler, this will be slow";
    Add-Type -Assembly System.IO.Compression.FileSystem;
    [System.IO.Compression.ZipFile]::ExtractToDirectory($pluginsZip, $releaseDir);
}

# ------------------------------------------------------------------------------
# Create the virtual environment

# Get the release name from the package
$peekPkgName = Get-ChildItem "$releaseDir\py" |
    Where-Object { $_.Name.StartsWith("synerty_peek-") } |
    Select-Object -exp Name;
$peekPkgVer = $peekPkgName.Split('-')[1];

# This variable is the path of the new virtualenv
$venvDir = "C:\Users\peek\synerty-peek-$peekPkgVer";

# Check if this release is already deployed
If (Test-Path $venvDir)
{
    Write-Host "directory already exists : $venvDir";
    Write-Error "This release is already deployed, delete it to re-deploy";
}

# Create the new virtual environment
virtualenv.exe $venvDir;

# Activate the virtual environment
$env:Path = "$venvDir\Scripts;$env:Path";

$foundPipPath = (get-command pip).source;
if (-Not $foundPipPath.StartsWith($venvDir))
{
    Write-Error "Failed to activate Venv $venvDir\Scripts\pip.exe, got $foundPipPath instead";
}

# ------------------------------------------------------------------------------
# Install the python packages

# install the py wheels from the release
Write-Host "Installing python platform"
Push-Location "$releaseDir\py"

pip install --no-index --no-cache --find-links = . Shapely pymssql

# What we'd like to do is something like this
# # pip install --no-index --no-cache --find-links=. synerty_peek*.whl
# but we'll settle for this
(Get-Childitem synerty_peek*.whl -Name).ForEach({
    pip install --no-index --no-cache --find-links = . $_
})

Pop-Location

# ------------------------------------------------------------------------------
# Install the python plugins

# install the py wheels from the release
Write-Host "Installing python plugins"
Push-Location "$releaseDir/peek_plugins_win_${peekPkgVer}"


# What we'd like to do is something like this
# # pip install --no-index --no-cache --find-links=. peek-plugin*.gz
# but we'll settle for this
(Get-Childitem peek_plugin*.whl -Name).ForEach({
    pip install --no-index --no-cache --find-links = . $_
})

Pop-Location

# ------------------------------------------------------------------------------
# Install node

# Move the node_modules into place
# This is crude, we kind of mash the two together
Move-Item $releaseDir\node\* $venvDir\Scripts -Force

# ------------------------------------------------------------------------------
# Install the frontend node_modules

# Make a var pointing to site-packages
$sp = "$venvDir\Lib\site-packages";

# Move the node_modules into place
Move-Item $releaseDir\mobile-build-web\node_modules $sp\peek_field_app -Force
Move-Item $releaseDir\desktop-build-web\node_modules $sp\peek_office_app -Force
Move-Item $releaseDir\admin-build-web\node_modules $sp\peek_admin_app -Force

# ------------------------------------------------------------------------------
# Show complete message

# All done.
Write-Host "Peek is now deployed to $venvDir";
Write-Host " ";

# ------------------------------------------------------------------------------
# OPTIONALLY - Update the environment for the user.

if ($PEEK_AUTO_DEPLOY = = '1')
{
    $result = 0

}
else
{
    # Ask if the user would like to update the PATH environment variables
    $title = "Environment Variables"
    $message = "Do you want to update the system to use the release just installed?"

    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes",    `
           "I want to update the PATH System Environment Variables."

    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No",    `
           "I do NOT want the PATH System Environment Variables changed."

    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

    $result = $host.ui.PromptForChoice($title, $message, $options, 0)
}

switch ($result)
{
    0 {
        Write-Host "You selected Yes.";

        $newPath = "$venvDir\Scripts";
        $newPath = $newPath + ";$venvDir\Lib\site-packages\pywin32_system32";
        Write-Host "Added PATH variable:" $newPath;

        ([Environment]::GetEnvironmentVariable("PATH", "User")).split(';') | foreach-object {
            if ($_ -notmatch 'synerty-peek')
            {
                $newPath = $newPath + ';' + $_
            }
            else
            {
                Write-Host "Removed PATH variable:" $_;
            }
        }
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User");

        $newPath = "";
        ([Environment]::GetEnvironmentVariable("PATH", "Machine")).split(';') | foreach-object {
            if ($_ -notmatch 'synerty-peek' -and $_ -notmatch 'Python3')
            {
                $newPath = $newPath + ';' + $_
            }
            else
            {
                Write-Host "Removed PATH variable:" $_;
            }
        }
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "Machine");
        Write-Host " ";
        Write-Host "Environment Variables have been updated."
        Write-Host " ";
        Write-Host "IMPORTANT, you must restart the PowerShell window for the";
        Write-Host "Environment Variable changes to take effect!";
    }

    1 {
        Write-Host "You selected No.";
        Write-Host " ";
        Write-Host "Activate the new environment from command :";
        Write-Host "    set PATH=`"$venvDir\Scripts;%PATH%`"";
        Write-Host " ";
        Write-Host "Activate the new environment from PowerShell :";
        Write-Host "    `$env:Path = `"$venvDir\Scripts;`$env:Path`"";
    }
}

# ------------------------------------------------------------------------------
# OPTIONALLY - Reinstall the services

if ($PEEK_AUTO_DEPLOY = = '1')
{
    $result = 0

}
else
{
    # Ask if the user would like to update the PATH environment variables
    $title = "Windows Services"
    $message = "Do you want to install/update the Peek windows services"

    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes",    `
           "I want the services setup."

    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No",    `
           "No services for me, this is a dev machine."

    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

    $result = $host.ui.PromptForChoice($title, $message, $options, 0)
}

switch ($result)
{
    0 {
        Write-Host "Ok, We're setting up the services.";

        # Get the password to start the services
        $pass = Read-Host 'What is the peek windows users password?'

        # Define the list of services to manage
        $services = @('peek_worker_service', 'peek_agent_service', 'peek_office_service', 'peek_logic_service', 'peek_restarter');

        foreach ($service in $services)
        {
            $arguments = "winsvc_$service --username .\peek --password $pass --startup auto install"
            $arguments = "CMD /C '" + $arguments + "'"
            Write-Output $arguments
            Start-Process powershell -Verb runAs -Wait -ArgumentList $arguments
        }

    }

    1 {
        Write-Host "Ok, We've left the services alone.";
    }
}

# ------------------------------------------------------------------------------
# Remove release dir

Remove-Item $releaseDir -Force -Recurse;

