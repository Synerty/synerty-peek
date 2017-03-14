================================
Peek Platform - Production Setup
================================

.. note:: The Windows or Debian requirements must be followed before following this guide.

Create Platform Release
-----------------------

To install the peek platform, you may use a Synerty provided release or build your own.

A release is a zip file containing all the required node_modules and python packages.

Windows
```````

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

Linux
`````

**TODO**

Deploy Platform Release
-----------------------

This section describes how to deploy a peek platform release.

Peek is deployed into python virtual environments, a new virtual environment is created
for every deployment.

This ensures that each install is clean, has the right dependencies and there is a
rollback path (switch back to the old virtual environment.

Windows
```````

Open a powershell windows.

----

Download the platform deploy script.
This is the only step in this section that requires the internet.

::

        $file = "deploy_win_playform_release.ps1"
        $uri = "https://raw.githubusercontent.com/Synerty/synerty-peek/master/$file";
        Invoke-WebRequest -Uri $uri -UseBasicParsing -OutFile $file;

----

Run the platform deploy script.
At the end it will print out where it has deployed the new environment to.
Ensure you update the **$dist** variable with the path to your release.

The script will deploy to C:\Users\peek.

::

        $dist = "C:\Users\peek\Downlaods\peek_dist_win_0.1.0.zip"
        PowerShell.exe -ExecutionPolicy Bypass -File deploy_peek_win_release.ps1 $dist

----

The platform is now deployed.

Next Steps:
    >

Linux
`````

**TODO**

Building the frontend (TODO, This should" just work")

::

        $ python ~/Python35/Lib/site-packages/peek_server/run_peek_server.py

        ctrl+c

        $ cd ~/Python35/Lib/site-packages/peek_server_fe/
        $ ng build

        $ python ~/Python35/Lib/site-packages/peek_client/run_peek_client.py

        ctrl+c

        $ cd ~/Python35/Lib/site-packages/peek_client_fe/
        $ ng build

        $ python ~/Python35/Lib/site-packages/peek_agent/run_peek_agent.py

        ctrl+c

Configuring Platform (config.json)
----------------------------------

Update config.json files. This tells the peek platform services how to connect to each
other, connect to the database, which plugins to load, etc.

----

Update the sql connection
    Edit **peek-server.home/config.json**

Update the sqlalchemy.connectUrl property

::

            "sqlalchemy": {
                    "connectUrl": "mssql+pymssql://.\\peek:PASSWORD@localhost/peek",


----

A plugin contains peices of code that are run on each of the peek services.

To enable a service to run their part of a plugin, add it to the **plugin.enabled**
array in each services **config.json**

For example:
    Edit **peek-agent.home/config.json**

Add the appropriate plugins to the array.
::

            "plugin": {
                "enabled": [
                    "peek_plugin_noop",
                    "peek_plugin_etc"
                ],
            },


Running synerty-peek
--------------------

$ python ~/Python35/Lib/site-packages/peek_server/run_peek_server.py

chrome: http://127.0.0.1:8010/

Update plugin settings

$ python ~/Python35/Lib/site-packages/peek_client/run_peek_client.py

chrome: http://127.0.0.1:8000/

$ python ~/Python35/Lib/site-packages/peek_agent/run_peek_agent.py

