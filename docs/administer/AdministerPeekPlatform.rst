.. _administer_peek_platform:

========================
Administer Peek Platform
========================

Configuring Platform :file:`config.json`
----------------------------------------

Update config.json files. This tells the peek platform services how to connect to each
other, connect to the database, which plugins to load, etc.

.. note:: Peek will automatically fill out the missing parts of config.json files.
            So we can start with just what we want to fill out.


Peek Server
```````````

Create directory **C:\Users\peek\peek-server.home**
Create file **C:\Users\peek\peek-server.home\config.json**

Populate the file with the
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
        "connectUrl": "postgresql://postgres:jjc@localhost/peek"
    }

Peek Client, Agent and Worker
`````````````````````````````
For each of "client", "agent" and "worker" names, do the following

Create directory **C:\Users\peek\peek-<name>.home**
Create file **C:\Users\peek\peek-<name>.home\config.json**

Populate the file with the
    *   Enabled plugins

::

    {
    "plugin": {
        "enabled": [
            "peek_plugin_noop",
            "peek_plugin_etc"
        ]
    }



Running synerty-peek
--------------------

$ python ~/Python35/Lib/site-packages/peek_server/run_peek_server.py

chrome: http://127.0.0.1:8010/

Update plugin settings

$ python ~/Python35/Lib/site-packages/peek_client/run_peek_client.py

chrome: http://127.0.0.1:8000/

$ python ~/Python35/Lib/site-packages/peek_agent/run_peek_agent.py

