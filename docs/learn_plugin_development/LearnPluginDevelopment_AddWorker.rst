.. _learn_plugin_development_add_worker:

=========================
Adding the worker Service
=========================

This document is a stripped version of :ref:`learn_plugin_development_add_server`.


Add Package :file:`_private/worker`
-----------------------------------

Commands: ::

        mkdir peek_plugin_tutorial/_private/worker
        touch peek_plugin_tutorial/_private/worker/__init__.py


Add File :file:`workerEntryHook.py`
-----------------------------------

Create the file :file:`peek_plugin_tutorial/_private/worker/workerEntryHook.py`
and populate it with the following contents.

::

        import logging

        from peek_plugin_base.worker.PluginworkerEntryHookABC import PluginworkerEntryHookABC

        logger = logging.getLogger(__name__)


        class workerEntryHook(PluginworkerEntryHookABC):
            def __init__(self, *args, **kwargs):
                """" Constructor """
                # Call the base classes constructor
                PluginworkerEntryHookABC.__init__(self, *args, **kwargs)

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

        from peek_plugin_base.worker.PluginworkerEntryHookABC import PluginworkerEntryHookABC
        from typing import Type


        def peekworkerEntryHook() -> Type[PluginworkerEntryHookABC]:
            from ._private.worker.workerEntryHook import workerEntryHook
            return workerEntryHook


Edit :file:`plugin_package.json`
--------------------------------


Edit the file :file:`peek_plugin_tutorial/plugin_package.json` :

#.  Add **"worker"** to the requiresServices section so it looks like ::

        "requiresServices": [
            "worker"
        ]

#.  Add the **worker** section after **requiresServices** section: ::

        "worker": {
        }

#.  Ensure your JSON is still valid (Your IDE may help here)

Here is an example ::

        {
            "plugin": {
                ...
            },
            "requiresServices": [
                "worker"
            ],
            "worker": {
            }
        }


Running on the worker Service
-----------------------------

Edit :file:`~/peek-worker.home/config.json`:

#.  Ensure **logging.level** is set to **"DEBUG"**
#.  Add **"peek_plugin_tutorial"** to the **plugin.enabled** array

----

You can now run the peek worker, you should see your plugin load. 
:file:`run_peek_worker` ::

        peek@peek:~$ run_peek_worker
        ...
        DEBUG peek_plugin_tutorial._private.worker.workerEntryHook:Loaded
        DEBUG peek_plugin_tutorial._private.worker.workerEntryHook:Started
        ...

