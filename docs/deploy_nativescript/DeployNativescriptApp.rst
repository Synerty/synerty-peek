.. _deploy_nativescript_app:

=======================
Deploy NativeScript App
=======================

.. note:: The Windows or Debian setup NativeScript must be followed before following
    this guide.

This section describes how to deploy a NativeScript App.

Peek is deployed into python virtual environments, a new virtual environment is created
for every deployment.

To package your own NativeScript App dependencies, see the following document
:ref:`package_nativescript_app`.

Windows
-------

Open a PowerShell window.

----

Download the NativeScript App dependencies deploy script.
This is the only step in this section that requires the internet.

::

        $file = "deploy_nativescript_app_win.ps1"
        $uri = "https://raw.githubusercontent.com/Synerty/synerty-peek/master/$file";
        Invoke-WebRequest -Uri $uri -UseBasicParsing -OutFile $file;

----

Run the deploy NativeScript App dependencies script.  The script will complete with a
print out of the environment the NativeScript App dependencies were deployed.  Ensure you
update the **$dist** variable with the path to your release.

The script will deploy to :file:`C:\\Users\\peek`.

::

        $dist = "C:\Users\peek\Downloads\peek_dist_nativescript_app_win_#.#.#.zip"
        PowerShell.exe -ExecutionPolicy Bypass -File deploy_nativescript_app_win.ps1 $dist


----

The NativeScript App dependencies are now deployed.

Linux
-----

**TODO**

What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
