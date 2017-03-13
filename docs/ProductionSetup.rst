================================
Peek Platform - Production Setup
================================

.. note:: This document extends the Windows or Debian requirements setup guide

Instal Platform Packages (pip)
------------------------------

Open a command prompt **as administrator**, you'll use this to install the
peek playform packages.

----

synerty-peek

::

        pip install synerty-peek

----

peek-plugins

    From saved directory::

            $ pip install ~/...


Instal Frontend Packages (npm)
------------------------------

Install the npm packages for the server and client

::

        $ cd `dirname $(which python)`/lib/site-packages/peek_client_fe
        $ npm install
        $ cd `dirname $(which python)`/lib/site-packages/peek_server_fe
        $ npm install


----

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

