.. _platform_build_release:

=======================
Create Platform Release
=======================

.. note:: The Windows or Debian requirements must be followed before following this guide.

To install the peek platform, you may use a Synerty provided release or build your own.

A release is a zip file containing all the required node_modules and python packages.

Building a Windows Release
--------------------------

This section contains the steps to build your own.

----

Open a powershell window.

----

Create and change to a working directory where you're happy for the release to be created.

::

    Set-Location C:\Users\peek

----

Download the platform build script.
Run the following commands in the power shell window.

::

    $file = "build_win_platform_release.ps1";
    $uri = "https://raw.githubusercontent.com/Synerty/synerty-peek/master/$file";
    Invoke-WebRequest -Uri $uri -UseBasicParsing -OutFile $file;

----

Run the platform build script.

::

    PowerShell.exe -ExecutionPolicy Bypass -File build_win_platform_release.ps1

The script will download the latest peek platform release and all its dependencies.

Take note of the end of the script, it will print out where the release is.

Building a Linux Release
------------------------

**TODO**


