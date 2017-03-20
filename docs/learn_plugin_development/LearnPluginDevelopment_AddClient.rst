.. _learn_plugin_development_add_client:


Adding the Client Service
-------------------------


Add :file:`_private/client` Directory
`````````````````````````````````````
This section adds the basic files require for the plugin to run on the clients service.
Create the following files and directories.

.. note:: Setting up skeleton files for the client, worker and agent services,
            is identical to the client, generally replace "Client" with the appropriate
            service name.

The platform loads the plugins python package, and then calls the appropriate
**peek{Client}EntryHook()** method on it, if it exists.

The object returned must implement the right interfaces, the platform then calls methods
on this object to load, start, stop, unload, etc the plugin.

----

Create directory :file:`peek_plugin_tutorial/_private/client`

Create an empty package file in the client directory,
:file:`peek_plugin_tutorial/_private/client/__init__.py`

Commands: ::

        mkdir peek_plugin_tutorial/_private/client
        touch peek_plugin_tutorial/_private/client/__init__.py

----

Create the file :file:`peek_plugin_tutorial/_private/client/ClientEntryHook.py`
and populate it with the following contents.

::

        import logging

        from peek_plugin_base.client.PluginClientEntryHookABC import PluginClientEntryHookABC

        logger = logging.getLogger(__name__)


        class ClientEntryHook(PluginClientEntryHookABC):
            def load(self) -> None:
                logger.debug("Loaded")

            def start(self):
                logger.debug("Started")

            def stop(self):
                logger.debug("Stopped")

            def unload(self):
                logger.debug("Unloaded")

----

Edit the file :file:`peek_plugin_tutorial/__init__.py`, and add the following: ::

        from peek_plugin_base.client.PluginClientEntryHookABC import PluginClientEntryHookABC
        from typing import Type


        def peekClientEntryHook() -> Type[PluginClientEntryHookABC]:
            from ._private.client.ClientEntryHook import ClientEntryHook
            return ClientEntryHook

----

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
`````````````````````````````

Edit :file:`~/peek-client.home/config.json`:

#.  Ensure **logging.level** is set to **"DEBUG"**
#.  Add **"peek_plugin_tutorial"** to the **plugin.enabled** array

.. note:: It would be helpful if this is the only plugin enabled at this point.

It should somthing like this: ::

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

.. note:: This file is created in :ref:`deploy_peek_platform`

----

You can now run the peek client, you should see your plugin load. ::

        peek@peek:~$ run_peek_client
        ...
        DEBUG peek_plugin_tutorial._private.client.ClientEntryHook:Loaded
        DEBUG peek_plugin_tutorial._private.client.ClientEntryHook:Started
        ...

