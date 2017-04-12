.. _administer_peek_platform:

========================
Administer Peek Platform
========================

.. _admin_configure_synerty_peek:

Configuring Platform :file:`config.json`
----------------------------------------

Update config.json files. This tells the peek platform services how to connect to each
other, connect to the database, which plugins to load, etc.

.. note:: Running the services of Peek will automatically create and fill out
    the missing parts of config.json files with defaults.  So we can start with just what
    we want to fill out.


Peek Server
```````````

This section sets up the config files for the **server** service.

----

Create following file and parent directory:

:Windows: :file:`C:\\Users\\peek\\peek-server.home\\config.json`
:Linux: :file:`/home/peek/peek-server.home/config.json`

.. tip:: Run the service, it will create some of it's config before failing
            to connect to the db.

----

Populate the file :file:`config.json` with the
    *   SQLAlchemy connect URL (See options below)
    *   Enabled plugins

Select the right :code:`connectUrl` for your database, ensure you update :code:`PASSWORD`.

:MS Sql Server: :code:`mssql+pymssql://peek:PASSWORD@127.0.0.1/peek`
:PostGreSQL: :code:`postgresql://peek:PASSWORD@127.0.0.1/peek`

::


        {
            "plugin": {
                "enabled": [
                    "peek_plugin_noop",
                    "peek_plugin_etc"
                ]
            },
            "sqlalchemy": {
                "connectUrl": "postgresql://peek:PASSWORD@127.0.0.1/peek"
            }
        }


Peek Client
```````````

This section sets up the config files for the **client** service.

----

Create following file and parent directory:

:Windows: :file:`C:\\Users\\peek\\peek-client.home\\config.json`
:Linux: :file:`/home/peek/peek-client.home/config.json`

.. tip:: Run the service, it will create some of it's config,
            it might raise errors though.

----

Populate the file :file:`config.json` with the
    *   Enabled plugins
    *   Disable NativeScript preparing

::

        {
            "frontend": {
                "nativescriptBuildPrepareEnabled": false
            },
            "plugin": {
                "enabled": [
                    "peek_plugin_noop",
                    "peek_plugin_etc"
                ]
            }
        }



Peek Agent
``````````

This section sets up the config files for the **agent** service.

----

Create following file and parent directory:

:Windows: :file:`C:\\Users\\peek\\peek-agent.home\\config.json`
:Linux: :file:`/home/peek/peek-agent.home/config.json`

.. tip:: Run the service, it will create some of it's config,
            it might raise errors though.

----

Populate the file :file:`config.json` with the
    *   Enabled plugins

::

        {
            "plugin": {
                "enabled": [
                    "peek_plugin_noop",
                    "peek_plugin_etc"
                ]
            }
        }


.. _admin_run_synerty_peek:

Run Peek Manually
-----------------

This section describes the best practices for running the peek platform manually

----

To use bash on windows, install msys git. :ref:`setup_msys_git`, otherwise use
powershell on windows.

Check Environment
`````````````````

Make sure that the right environment is activated. Run the following commands.

----

PowerShell ::

        (Get-Command python).source
        (Get-Command run_peek_server).source

Or Bash ::

        which python
        which run_peek_server

----

Confirm that the output contains the release you wish to use.

run_peek_server
```````````````

This section runs the peek server service of the platform and opens the admin page.

----

Run the following in bash, cmd or powershell ::

        run_peek_server


----

Open the following URL in a browser, Chrome is recommended.

`<http://127.0.0.1:8010/>`_

This is the administration page for the peek platform, otherwise known as the
"Admin" service.


run_peek_client
```````````````

This section runs the peek client service, this serves the desktop and mobile web apps
and provides data to all desktop and mobile native apps

----

Run the following in bash, cmd or powershell ::

        run_peek_client


----

Open the following URL in a browser, Chrome is recommended.

`<http://127.0.0.1:8000/>`_

This is the mobile web app for the peek platform.


run_peek_agent
``````````````

The Agent is used to connect to external systems, this section runs the agent service.

----

Run the following in bash, cmd or powershell ::

        run_peek_agent


Whats Next
``````````

Now that the platform is running, See the next section,
:ref:`admin_updating_plugin_settings`


.. _admin_updating_plugin_settings:

Updating Plugin Settings
------------------------

Plugins are intended to be entierly configured via the peek server Admin page.

Navigate to `<http://127.0.0.1:8010/>`_ and click the plugins dropdown.