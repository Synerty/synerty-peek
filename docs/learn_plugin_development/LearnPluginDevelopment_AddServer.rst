.. _learn_plugin_development_add_server:


Adding the Server Service
-------------------------


Configure the Plugin
````````````````````
This section adds the basic files require for the plugin to run on the servers service.
Create the following files and directories.

.. note:: Setting up skeleton files for the client, worker and agent services,
            is identical to the server, generally replace "Server" with the appropriate
            service name.

The platform loads the plugins python package, and then calls the appropriate
**peek{Server}EntryHook()** method on it, if it exists.

The object returned must implement the right interfaces, the platform then calls methods
on this object to load, start, stop, unload, etc the plugin.

----

Create directory :file:`peek_plugin_tutorial/_private/server`

Create an empty package file in the server directory,
:file:`peek_plugin_tutorial/_private/server/__init__.py`

Commands: ::

        mkdir peek_plugin_tutorial/_private/server
        touch peek_plugin_tutorial/_private/server/__init__.py

----

Create the file :file:`peek_plugin_tutorial/_private/server/ServerEntryHook.py`
and populate it with the following contents.

::

        import logging

        from peek_plugin_base.server.PluginServerEntryHookABC import PluginServerEntryHookABC

        logger = logging.getLogger(__name__)


        class ServerEntryHook(PluginServerEntryHookABC):
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

        from peek_plugin_base.server.PluginServerEntryHookABC import PluginServerEntryHookABC
        from typing import Type


        def peekServerEntryHook() -> Type[PluginServerEntryHookABC]:
            from ._private.server.ServerEntryHook import ServerEntryHook
            return ServerEntryHook

----

Edit the file :file:`peek_plugin_tutorial/plugin_package.json` :

#.  Add **"server"** to the requiresServices section so it looks like ::

        "requiresServices": [
            "server"
        ]

#.  Add the **server** section after **requiresServices** section: ::

        "server": {
        }

#.  Ensure your JSON is still valid (Your IDE may help here)

Here is an example ::

        {
            "plugin": {
                ...
            },
            "requiresServices": [
                "server"
            ],
            "server": {
            }
        }


----

The plugin should now be ready for the server to load.

Running on the Server Service
`````````````````````````````

Edit :file:`~/peek-server.home/config.json`:

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

You can now run the peek server, you should see your plugin load. ::

        peek@peek:~$ run_peek_server
        ...
        DEBUG peek_plugin_tutorial._private.server.ServerEntryHook:Loaded
        DEBUG peek_plugin_tutorial._private.server.ServerEntryHook:Started
        ...

