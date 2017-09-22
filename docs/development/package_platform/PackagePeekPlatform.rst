.. _package_peek_platform:

=====================
Package Peek Platform
=====================

.. note:: The Windows or Debian requirements must be followed before following this guide.

To install the peek platform, you may use a Synerty provided release or build your own.

A release is a zip file containing all the required node_modules and python packages.

Building a Windows Release
--------------------------

This section contains the steps to build your own platform release.

----

Ensure that msys git is installed. :ref:`setup_msys_git`.

The python package scripts use git to detect git ignored files.

----

Open a PowerShell window.

----

Create and change to a working directory where you're happy for the release to be created.

::

    Set-Location C:\Users\peek

----

Download the platform build script.
Run the following commands in the power shell window.

::

    $file = "package_platform_win.ps1";
    $uri = "https://bitbucket.org/synerty/synerty-peek/raw/master/scripts/win/$file";
    Invoke-WebRequest -Uri $uri -UseBasicParsing -OutFile $file;

----

Run the platform build script.

::

    PowerShell.exe -ExecutionPolicy Bypass -File $file

The script will download the latest peek platform release and all its dependencies.

Take note of the end of the script, it will print out where the release is.


Building a Linux Release
------------------------

This section contains the steps to build your own platform release.

Download the platform build script.
Run the following commands in the power shell window.

::

        file="package_platform_deb8.sh";
        uri="https://bitbucket.org/synerty/synerty-peek/raw/master/scripts/deb8/$file";
        wget $uri


----

Run the platform build script.

::

       bash $file

The script will download the latest peek platform release and all its dependencies.

Take note of the end of the script, it will print out where the release is.


Building a macOS Release
------------------------

This section contains the steps to build your own platform release.

Download the platform build script.
Run the following commands in the power shell window.

::

        file="package_platform_macos.sh";
        uri="https://bitbucket.org/synerty/synerty-peek/raw/master/scripts/macos/$file";
        curl -O $uri


----

Run the platform build script.

::

       bash $file

The script will download the latest peek platform release and all its dependencies.

Take note of the end of the script, it will print out where the release is.

 
What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
