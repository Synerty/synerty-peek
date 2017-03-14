================================
Peek Platform - Production Setup
================================

.. note:: The Windows or Debian requirements must be followed before following this guide.

Deploy Platform Release
-----------------------

This section describes how to deploy a peek platform release.

Peek is deployed into python virtual environments, a new virtual environment is created
for every deployment.

This ensures that each install is clean, has the right dependencies and there is a
rollback path (switch back to the old virtual environment.

To build your own platform release, see the following document

    :ref:`_platform_build_release`

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


Linux
`````

**TODO**



Deploying Plugins
-----------------

This section deploys the plugins to the new virtual environment.

For more information about plugin development and building plugin packages / releases
see: :ref:`_plugin_development`

Windows
```````

Open a power shell window

----

CD to the folder where the plugin packages are located

----

Pip install the plugins with the following command

::

    # Activate the virtual environment
    $env:Path = "C:\Users\peek\synerty-peek-0.1.0\Scripts;$env:Path"

    # Install the plugin packages
    pip install --no-deps $(ls * -name)



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

