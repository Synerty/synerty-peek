====================
Package Peek Plugins
====================

A release is a zip file containing all the required python packages to install
the plugins after the platform release has installed.

Building a Windows Release
--------------------------

This section contains the steps to build your own platform release.

----

Open a PowerShell window.

----

Change to a working directory where you have the peek plugin wheel.

::

        Set-Location C:\\Users\\peek


----

Set the plugin you wish to package using the wheel file name:

::

        $plugin = "peek-plugin-example-0.0.1.tar.gz"


.. note:: To install a public release from
    `PyPI - the Python Package Index <https://pypi.python.org/pypi>`_
    set only the plugin name, :code:`$plugin = "peek-plugin-example`

----

Download the platform build script. Run the following commands in the power shell window:

::

        $file = "package_plugin_win.ps1";
        $uri = "https://bitbucket.org/synerty/peek-plugin-noop/raw/4570f98feb26f6f27c1073f5e2339389c7c534ef/$file";
        Invoke-WebRequest -Uri $uri -UseBasicParsing -OutFile $file;


----

Run the platform build script.

::

        PowerShell.exe -ExecutionPolicy Bypass -File package_plugin_win.ps1 -plugin $plugin


The script will download the latest peek platform release and all its dependencies.

Take note of the end of the script, it will print out where the release is.

Building a Linux Release
------------------------

**TODO**

What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
