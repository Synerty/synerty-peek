.. _learn_plugin_development_add_client:

==================
Add Client Service
==================

This document is a stripped version of :ref:`learn_plugin_development_add_server`.

Client File Structure
---------------------

Add Package :file:`_private/client`
```````````````````````````````````

Create directory :file:`peek_plugin_tutorial/_private/client`

Create an empty package file in the client directory,
:file:`peek_plugin_tutorial/_private/client/__init__.py`

Commands: ::

        mkdir peek_plugin_tutorial/_private/client
        touch peek_plugin_tutorial/_private/client/__init__.py


Add File :file:`ClientEntryHook.py`
```````````````````````````````````

Create the file :file:`peek_plugin_tutorial/_private/client/ClientEntryHook.py`
and populate it with the following contents.

::

        import logging

        from peek_plugin_base.client.PluginClientEntryHookABC import PluginClientEntryHookABC

        logger = logging.getLogger(__name__)


        class ClientEntryHook(PluginClientEntryHookABC):
            def __init__(self, *args, **kwargs):
                """" Constructor """
                # Call the base classes constructor
                PluginClientEntryHookABC.__init__(self, *args, **kwargs)

                #: Loaded Objects, This is a list of all objects created when we start
                self._loadedObjects = []

            def load(self) -> None:
                """ Load

                This will be called when the plugin is loaded, just after the db is migrated.
                Place any custom initialiastion steps here.

                """
                logger.debug("Loaded")

            def start(self):
                """ Load

                This will be called when the plugin is loaded, just after the db is migrated.
                Place any custom initialiastion steps here.

                """
                logger.debug("Started")

            def stop(self):
                """ Stop

                This method is called by the platform to tell the peek app to shutdown and stop
                everything it's doing
                """
                # Shutdown and dereference all objects we constructed when we started
                while self._loadedObjects:
                    self._loadedObjects.pop().shutdown()

                logger.debug("Stopped")

            def unload(self):
                """Unload

                This method is called after stop is called, to unload any last resources
                before the PLUGIN is unlinked from the platform

                """
                logger.debug("Unloaded")


Edit :file:`peek_plugin_tutorial/__init__.py`
`````````````````````````````````````````````

Edit the file :file:`peek_plugin_tutorial/__init__.py`, and add the following: ::

        from peek_plugin_base.client.PluginClientEntryHookABC import PluginClientEntryHookABC
        from typing import Type


        def peekClientEntryHook() -> Type[PluginClientEntryHookABC]:
            from ._private.client.ClientEntryHook import ClientEntryHook
            return ClientEntryHook


Edit :file:`plugin_package.json`
````````````````````````````````

Edit the file :file:`peek_plugin_tutorial/plugin_package.json` :

#.  Add **"client"** to the requiresServices section so it looks like ::

        "requiresServices": [
            "client"
        ]

#.  Add the **client** section after **requiresServices** section: ::

        "client": {
        }

#.  Ensure your JSON is still valid (Your IDE may help here)

Here is an example ::

        {
            "plugin": {
                ...
            },
            "requiresServices": [
                "client"
            ],
            "client": {
            }
        }


----

The plugin should now be ready for the client to load.

Running on the Client Service
-----------------------------

Edit :file:`~/peek-office-service.home/config.json`:

#.  Ensure **logging.level** is set to **"DEBUG"**
#.  Add **"peek_plugin_tutorial"** to the **plugin.enabled** array

.. note:: It would be helpful if this is the only plugin enabled at this point.

It should something like this: ::

        {
            ...
            "logging": {
                "level": "DEBUG"
            },
            ...
            "plugin": {
                "enabled": [
                    "peek_plugin_tutorial"
                ],
                ...
            },
            ...
        }


.. note:: This file is created in :ref:`administer_peek_platform`.  Running the Client
    Service will also create the file.

----

You can now run the peek client, you should see your plugin load. ::

        peek@_peek:~$ run_peek_office_service
        ...
        DEBUG peek_plugin_tutorial._private.client.ClientEntryHook:Loaded
        DEBUG peek_plugin_tutorial._private.client.ClientEntryHook:Started
        ...

