.. _package_nativescript_app:

========================
Package NativeScript App
========================

.. note:: The Windows or Debian setup NativeScript must be followed before following this
    guide.

To deploy the NativeScript App, you may use a Synerty provided release or build your own.

A release is a zip file containing all the required node_modules.

Windows
-------

This section contains the steps to build your own NativeScript App release.

----

Open a PowerShell window.

----

Create and change to a working directory where you're happy for the release to be created.

::

    Set-Location C:\Users\peek

----

Download the package NativeScript App dependencies script.
Run the following commands in the PowerShell window.

::

    $file = "package_nativescript_app_win.ps1";
    $uri = "https://raw.githubusercontent.com/Synerty/synerty-peek/master/$file";
    Invoke-WebRequest -Uri $uri -UseBasicParsing -OutFile $file;

----

Run the package NativeScript App dependencies script.

::

    PowerShell.exe -ExecutionPolicy Bypass -File package_nativescript_app_win.ps1

The script will download the NativeScript App dependencies.

Take note of the end of the script, it will print out where the release is.

Linux
-----

**TODO**

What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
