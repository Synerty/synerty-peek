.. _learn_plugin_development_add_office_service:

==================
Add Office Service
==================

This document is a stripped version of :ref:`learn_plugin_development_add_logic_service`.

Office Service File Structure
-----------------------------

Add Package :file:`_private/office`
```````````````````````````````````

Create directory :file:`peek_plugin_tutorial/_private/office`

Create an empty package file in the office directory,
:file:`peek_plugin_tutorial/_private/office/__init__.py`

Commands: ::

        mkdir peek_plugin_tutorial/_private/office
        touch peek_plugin_tutorial/_private/office/__init__.py


Add File :file:`OfficeEntryHook.py`
```````````````````````````````````

Create the file :file:`peek_plugin_tutorial/_private/office/OfficeEntryHook.py`
and populate it with the following contents.

::

        import logging

        from peek_plugin_base.office.PluginOfficeEntryHookABC import PluginOfficeEntryHookABC

        logger = logging.getLogger(__name__)


        class OfficeEntryHook(PluginOfficeEntryHookABC):
            def __init__(self, *args, **kwargs):
                """" Constructor """
                # Call the base classes constructor
                PluginOfficeEntryHookABC.__init__(self, *args, **kwargs)

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

        from peek_plugin_base.office.PluginOfficeEntryHookABC import PluginOfficeEntryHookABC
        from typing import Type


        def peekOfficeEntryHook() -> Type[PluginOfficeEntryHookABC]:
            from ._private.office.OfficeEntryHook import OfficeEntryHook
            return OfficeEntryHook


Edit :file:`plugin_package.json`
````````````````````````````````

Edit the file :file:`peek_plugin_tutorial/plugin_package.json` :

#.  Add **"office"** to the requiresServices section so it looks like ::

        "requiresServices": [
            "office",
        ]

#.  Add the **office** section after **requiresServices** section: ::

        "office": {
        }

#.  Ensure your JSON is still valid (Your IDE may help here)

Here is an example ::

        {
            "plugin": {
                ...
            },
            "requiresServices": [
                "office",
            ],
            "office": {
            }
        }


----

The plugin should now be ready for the office to load.

Running on the Office Service
-----------------------------

Edit :file:`~/peek-office.home/config.json`:

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


.. note:: This file is created in :ref:`administer_peek_platform`.  Running the Office
    Service will also create the file.

----

You can now run the peek office, you should see your plugin load. ::

        peek@_peek:~$ run_peek_office_service
        ...
        DEBUG peek_plugin_tutorial._private.office.OfficeEntryHook:Loaded
        DEBUG peek_plugin_tutorial._private.office.OfficeEntryHook:Started
        ...

