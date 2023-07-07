.. _admin_configure_synerty_peek:

Configuring Platform :file:`config.json`
----------------------------------------

Update config.json files. This tells the peek platform services how to connect to each
other, connect to the database, which plugins to load, etc.

.. note:: Running the services of Peek will automatically create and fill out
    the missing parts of config.json files with defaults. So we can start with just what
    we want to fill out.


Peek Logic Service
``````````````````

This section sets up the config files for the peek **logic** service.

----

Create following file and parent directory:

:Windows: :file:`C:\\Users\\peek\\peek-logic-service.home\\config.json`
:Linux: :file:`/home/peek/peek-logic-service.home/config.json`
:Mac:   :file:`/Users/peek/peek-logic-service.home/config.json`

.. tip:: Run the service, it will create some of it's config before failing
            to connect to the db.

----

Populate the file :file:`config.json` with the
    *   SQLAlchemy connect URL (See options below)
    *   Enabled plugins

Select the right :code:`connectUrl` for your database, ensure you update :code:`PASSWORD`.

:MS Sql Server: :code:`mssql+pymssql://peek:PASSWORD@127.0.0.1/peek`
:PostgreSQL: :code:`postgresql+psycopg://peek:PASSWORD@127.0.0.1/peek`

::


        {
            "plugin": {
                "enabled": [
                    "peek_plugin_inbox",
                    "peek_plugin_tutorial"
                ]
            },
            "sqlalchemy": {
                "connectUrl": "postgresql+psycopg://peek:PASSWORD@127.0.0.1/peek"
            }
        }


Peek Field Service
``````````````````

This section sets up the config files for the peek **field** service.

----

Create following file and parent directory:

:Windows: :file:`C:\\Users\\peek\\peek-field-service.home\\config.json`
:Linux: :file:`/home/peek/peek-field-service.home/config.json`
:Mac:   :file:`/Users/peek/peek-field-service.home/config.json`

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

Peek Office Service
```````````````````

This section sets up the config files for the peek **office** service.

----

Create following file and parent directory:

:Windows: :file:`C:\\Users\\peek\\peek-office-service.home\\config.json`
:Linux: :file:`/home/peek/peek-office-service.home/config.json`
:Mac:   :file:`/Users/peek/peek-office-service.home/config.json`

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


Peek Agent Service
``````````````````

This section sets up the config files for the peek **agent** service.

----

Create following file and parent directory:

:Windows: :file:`C:\\Users\\peek\\peek-agent-service.home\\config.json`
:Linux: :file:`/home/peek/peek-agent-service.home/config.json`
:Mac:   :file:`/Users/peek/peek-agent-service.home/config.json`

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

Peek Field, Office, Logic Service SSL
`````````````````````````````````````

This section sets up SSL for the peek field, office and logic services.

----

Combine the required SSL certificates and keys into a single PEM file
named :file:`peek-ssl-bundle.pem`.

For example, this can be done on Linux by concatenating the Key, Cert and CA files. ::

    cat key.pem cert.pem ca.pem > bundle.pem

.. note:: The file names will vary, but the file contents will start with lines like the following ::

    ==> CA cert <==

    -----BEGIN CERTIFICATE-----

    ==> Cert <==

    -----BEGIN CERTIFICATE-----

    ==> Key <==

    -----BEGIN RSA PRIVATE KEY-----



----

Place a copy of this PEM file into the server directory:

:Windows: :file:`C:\\Users\\peek\\peek-logic-service.server\\peek-ssl-bundle.pem`
:Linux: :file:`/home/peek/peek-logic-service.home/peek-ssl-bundle.pem`
:Mac:   :file:`/Users/peek/peek-logic-service.home/peek-ssl-bundle.pem`

----

Restart the Peek server service.

----


Place a copy of this PEM file into the field directory:

:Windows: :file:`C:\\Users\\peek\\peek-field-service.server\\peek-ssl-bundle.pem`
:Linux: :file:`/home/peek/peek-field-service.home/peek-ssl-bundle.pem`
:Mac:   :file:`/Users/peek/peek-field-service.home/peek-ssl-bundle.pem`

----

Place a copy of this PEM file into the office directory:

:Windows: :file:`C:\\Users\\peek\\peek-office-service.server\\peek-ssl-bundle.pem`
:Linux: :file:`/home/peek/peek-office-service.home/peek-ssl-bundle.pem`
:Mac:   :file:`/Users/peek/peek-office-service.home/peek-ssl-bundle.pem`

----

Restart the Peek field and office services.

----

The Peek logic service, field service, and office service should now be using SSL.
