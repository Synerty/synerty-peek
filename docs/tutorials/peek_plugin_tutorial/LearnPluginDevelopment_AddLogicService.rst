.. _learn_plugin_development_add_logic_service:

=================
Add Logic Service
=================

This section adds the basic files require for the plugin to run on the peek logic service.
Create the following files and directories.

.. note:: Setting up skeleton files for the field, office, worker and agent services,
            is identical to the logic service, generally replace "logic" with the appropriate
            service name.

The platform loads the plugins python package, and then calls the appropriate
**peek{logic}EntryHook()** method on it, if it exists.

The object returned must implement the right interfaces, the platform then calls methods
on this object to load, start, stop, unload, etc the plugin.

Logic Service File Structure
----------------------------

Add Package :file:`_private/logic`
``````````````````````````````````

This step creates the :file:`_private/logic`
`python package <https://docs.python.org/3.5/tutorial/modules.html#packages>`_.

This package will contain the majority of the plugins code that will run on the
logic service. Files in this package can be imported with ::

        # Example
        # To import peek_plugin_tutorial/_private/logic/File.py
        from peek_plugin_tutorial._private.logic import File

----

Create directory :file:`peek_plugin_tutorial/_private/logic`

Create an empty package file in the logic directory,
:file:`peek_plugin_tutorial/_private/logic/__init__.py`

Commands: ::

        mkdir peek_plugin_tutorial/_private/logic
        touch peek_plugin_tutorial/_private/logic/__init__.py

.. _learn_plugin_development_add_logic_add_file_LogicEntryHook:

Add File :file:`LogicEntryHook.py`
``````````````````````````````````

This file/class is the entry point for the plugin on the peek logic service.
When the peek logic service starts this plugin, it will call the :command:`load()` then the
:command:`start()` methods.

Any initialisation and loading that the plugin needs to do to run should
be placed in :command:`load()` and :command:`start()` methods.

.. important::  Ensure what ever is constructed and initialised in the :command:`load()`
                and :command:`start()` methods, should be deconstructed in the
                :command:`stop()` and :command:`unload()` methods.

----

Create the file :file:`peek_plugin_tutorial/_private/logic/LogicEntryHook.py`
and populate it with the following contents.

::

        import logging

        from peek_plugin_base.logic.PluginLogicEntryHookABC import PluginLogicEntryHookABC

        logger = logging.getLogger(__name__)


        class LogicEntryHook(PluginLogicEntryHookABC):
            def __init__(self, *args, **kwargs):
                """" Constructor """
                # Call the base classes constructor
                PluginLogicEntryHookABC.__init__(self, *args, **kwargs)

                #: Loaded Objects, This is a list of all objects created when we start
                self._loadedObjects = []

            def load(self) -> None:
                """ Load

                This will be called when the plugin is loaded, just after the db is migrated.
                Place any custom initialiastion steps here.

                """
                logger.debug("Loaded")

            def start(self):
                """ Start

                This will be called to start the plugin.
                Start, means what ever we choose to do here. This includes:

                -   Create Controllers

                -   Create payload, observable and tuple action handlers.

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

When the peek logic service loads the plugin, it first calls the
:command:`peekLogicEntryHook()` method from the :command:`peek_plugin_tutorial` package.

The :command:`peekLogicEntryHook()` method returns the Class that the peek logic service should
create to initialise and start the plugin.

As far as the Peek Platform is concerned, the plugin can be structured how ever it likes
internally, as long as it defines these methods in its root python package.

----

Edit the file :file:`peek_plugin_tutorial/__init__.py`, and add the following: ::

        from peek_plugin_base.logic.PluginLogicEntryHookABC import PluginLogicEntryHookABC
        from typing import Type


        def peekLogicEntryHook() -> Type[PluginLogicEntryHookABC]:
            from ._private.logic.LogicEntryHook import LogicEntryHook
            return LogicEntryHook


Edit :file:`plugin_package.json`
````````````````````````````````

These updates to the :file:`plugin_package.json` tell the Peek Platform that we require
the "logic" service to run, and additional configuration options we have for that
service.

----

Edit the file :file:`peek_plugin_tutorial/plugin_package.json` :

#.  Add **"logic"** to the requiresServices section so it looks like ::

        "requiresServices": [
            "logic"
        ]

#.  Add the **logic** section after **requiresServices** section: ::

        "logic": {
        }

#.  Ensure your JSON is still valid (Your IDE may help here)

Here is an example ::

        {
            "plugin": {
                ...
            },
            "requiresServices": [
                "logic"
            ],
            "logic": {
            },
            ...

        }


----

The plugin should now be ready for the logic service to load.

Running on the Logic Service
----------------------------

File :file:`~/peek-logic-service.home/config.json` is the configuration file for the peek logic
service.

.. note:: This file is created in :ref:`administer_peek_platform`.  Running the Logic
    Service will also create the file.

----

Edit :file:`~/peek-logic-service.home/config.json`:

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

----

You can now run the peek logic service, you should see your plugin load. ::

        peek@_peek:~$ run_peek_logic_service
        ...
        DEBUG peek_plugin_tutorial._private.logic.LogicEntryHook:Loaded
        DEBUG peek_plugin_tutorial._private.logic.LogicEntryHook:Started
        ...
