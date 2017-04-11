.. _administer_peek_platform:

========================
Administer Peek Platform
========================

Configuring Platform :file:`config.json`
----------------------------------------

Update config.json files. This tells the peek platform services how to connect to each
other, connect to the database, which plugins to load, etc.

.. note:: Running the services of Peek will automatically create and fill out
    the missing parts of config.json files with defaults.  So we can start with just what
    we want to fill out.


Peek Server
```````````

Create directory :file:`C:\\Users\\peek\\peek-server.home`

----

Create file :file:`C:\\Users\\peek\\peek-server.home\\config.json`

----

Populate the file :file:`C:\\Users\\peek\\peek-server.home\\config.json` with the
    *   SQLAlchemy connect URL
    *   Enabled plugins

::

        {
        "plugin": {
            "enabled": [
                "peek_plugin_noop",
                "peek_plugin_etc"
            ]
        },
        "sqlalchemy": {
            "connectUrl": "postgresql://peek:PASSWORD@localhost/peek"
        }


.. note:: In the SQLAlchemy connect URL the :code:`PASSWORD` needs to be replaced with the
    password you used when installing postgres, see
    :ref:`requirements_windows_postgressql`.

For MSSQL the SQAlchemy connection string will be like:

::

        "sqlalchemy": {
           "connectUrl": "mssql+pymssql://.\\peek:PASSWORD@localhost/peek"
        }


Peek Client, Agent and Worker
`````````````````````````````
For each of "client", "agent" and "worker" names, do the following

Create directory :file:`C:\\Users\\peek\\peek-<name>.home`
Create file :file:`C:\\Users\\peek\\peek-<name>.home\\config.json`

Populate the file :file:`C:\\Users\\peek\\peek-server.home\\config.json` with the
    *   Enabled plugins (the plugins you have installed)

::

        {
        "plugin": {
            "enabled": [
                "peek_plugin_noop",
                "peek_plugin_etc"
            ]
        }


If there are no plugins installed, this file will be populated as:

::

        {
        "plugin": {
            "enabled": [
            ]
        }

.. _admin_run_synerty_peek:

Running synerty-peek
--------------------

Run the following in bash:

::

        run_peek_server


chrome: http://127.0.0.1:8010/

Update plugin settings

::

        run_peek_client


chrome: http://127.0.0.1:8000/

::

        run_peek_agent



