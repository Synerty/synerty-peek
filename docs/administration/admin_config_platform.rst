
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
:Mac:   :file:`/Users/peek/peek-server.home/config.json`

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
                    "peek_plugin_inbox",
                    "peek_plugin_tutorial"
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
:Mac:   :file:`/Users/peek/peek-server.home/config.json`

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
                    "peek_plugin_inbox",
                    "peek_plugin_tutorial"
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
:Mac:   :file:`/Users/peek/peek-server.home/config.json`

.. tip:: Run the service, it will create some of it's config,
            it might raise errors though.

----

Populate the file :file:`config.json` with the
    *   Enabled plugins

::

        {
            "plugin": {
                "enabled": [
                    "peek_plugin_inbox",
                    "peek_plugin_tutorial"
                ]
            }
        }

