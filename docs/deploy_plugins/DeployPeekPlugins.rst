.. _deploy_peek_plugins:

===================
Deploy Peek Plugins
===================

.. note:: The Windows or Debian requirements must be followed before following this guide.

Deploying Plugins
-----------------

This section deploys the plugins to the new virtual environment.

For more information about plugin development and building plugin packages / releases
see: :ref:`develop_peek_plugins`

Deploy a Windows Release
------------------------

Open a PowerShell window.

----

Change to a working directory:

::

        Set-Location C:\\Users\\peek


----

Download the platform deploy script. This is the only step in this section that
requires the internet.

::

        $file = "deploy_plugin_win.ps1"
        $uri = "/$file";
        Invoke-WebRequest -Uri $uri -UseBasicParsing -OutFile $file;


----

Run the platform deploy script. The script will complete with a print out of where the
new environment was deployed. Ensure you update the **$dist** variable with the path to
your release.

The script will deploy to :file:`C:\\Users\\peek`.

::

        $dist = "C:\Users\peek\Downloads\dist_win_peek_plugin_pof_events_#.#.#.zip"
        PowerShell.exe -ExecutionPolicy Bypass -File deploy_platform_win.ps1 $dist


----

The plugin is now installed.

Deploy a Linux Release
----------------------

**TODO**

What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
