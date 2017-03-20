.. _learn_plugin_development_add_client:

=========================
Adding the client Service
=========================

This document is a stripped version of :ref:`learn_plugin_development_add_server`.


Add Package :file:`_private/client`
-----------------------------------

Commands: ::

        mkdir peek_plugin_tutorial/_private/client
        touch peek_plugin_tutorial/_private/client/__init__.py


Add File :file:`clientEntryHook.py`
-----------------------------------

Create the file :file:`peek_plugin_tutorial/_private/client/clientEntryHook.py`
and populate it with the following contents.

::

        import logging

        from peek_plugin_base.client.PluginclientEntryHookABC import PluginclientEntryHookABC

        logger = logging.getLogger(__name__)


        class clientEntryHook(PluginclientEntryHookABC):
            def __init__(self, *args, **kwargs):
                """" Constructor """
                # Call the base classes constructor
                PluginclientEntryHookABC.__init__(self, *args, **kwargs)

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
---------------------------------------------


Edit the file :file:`peek_plugin_tutorial/__init__.py`, and add the following: ::

        from peek_plugin_base.client.PluginclientEntryHookABC import PluginclientEntryHookABC
        from typing import Type


        def peekclientEntryHook() -> Type[PluginclientEntryHookABC]:
            from ._private.client.clientEntryHook import clientEntryHook
            return clientEntryHook


Edit :file:`plugin_package.json`
--------------------------------

For more details about the :file:`plugin_package.json`,
see :ref:`About plugin_package.json <package_json_explaination>`.

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


Running on the client Service
-----------------------------

Edit :file:`~/peek-client.home/config.json`:

#.  Ensure **logging.level** is set to **"DEBUG"**
#.  Add **"peek_plugin_tutorial"** to the **plugin.enabled** array

----

You can now run the peek client, you should see your plugin load. 
:file:`run_peek_client` ::

        peek@peek:~$ run_peek_client
        ...
        DEBUG peek_plugin_tutorial._private.client.clientEntryHook:Loaded
        DEBUG peek_plugin_tutorial._private.client.clientEntryHook:Started
        ...

