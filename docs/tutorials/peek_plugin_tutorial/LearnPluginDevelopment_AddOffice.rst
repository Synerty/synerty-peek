.. _learn_plugin_development_add_office_app:

==============
Add Office App
==============

The office app is similar to the field app. This document is a stripped version of
:ref:`learn_plugin_development_add_field_app`.

Office File Structure
---------------------

Add Package :file:`_private/office`
```````````````````````````````````

Create an empty package file in the office directory,
:file:`peek_plugin_tutorial/_private/office/__init__.py`

Commands: ::

        mkdir peek_plugin_tutorial/_private/office
        touch peek_plugin_tutorial/_private/office/__init__.py


Add File :file:`tutorial.component.dweb.html`
`````````````````````````````````````````````

Create the :file:`peek_plugin_tutorial/_private/office/tutorial.component.dweb.html` with the following contents:

::

        <div class="container">
            <h1 class="text-center">Tutorial Plugin</h1>
            <p>Angular2 Lazy Loaded Module</p>
            <p>This is the root of the office app for the Tutorial plugin</p>
        </div>

Add File :file:`tutorial.component.ts`
``````````````````````````````````````

Create the file :file:`peek_plugin_tutorial/_private/office/tutorial.component.ts` and populate it with the following contents.

::

        import {Component} from "@angular/core";

        @Component({
            selector: 'plugin-tutorial',
            templateUrl: 'tutorial.component.dweb.html',
            moduleId: module.id
        })
        export class TutorialComponent {

            constructor() {

            }

        }

----

Create the file :file:`peek_plugin_tutorial/_private/office/tutorial.module.ts`
and populate it with the following contents.

::

        import {CommonModule} from "@angular/common";
        import {NgModule} from "@angular/core";
        import {Routes} from "@angular/router";

        import { PeekModuleFactory } from "@synerty/peek-plugin-base-js"

        // Import the default route component
        import {TutorialComponent} from "./tutorial.component";


        // Define the child routes for this plugin
        export const pluginRoutes: Routes = [
            {
                path: '',
                pathMatch:'full',
                component: TutorialComponent
            }

        ];

        // Define the root module for this plugin.
        // This module is loaded by the lazy loader, what ever this defines is what is started.
        // When it first loads, it will look up the routs and then select the component to load.
        @NgModule({
            imports: [
                CommonModule,
                PeekModuleFactory.RouterModule,
                PeekModuleFactory.RouterModule.forChild(pluginRoutes),
                ...PeekModuleFactory.FormsModules
            ],
            exports: [],
            providers: [],
            declarations: [TutorialComponent]
        })
        export class TutorialModule
        {
        }


Download Icon :file:`icon.png`
``````````````````````````````

The Peek web interface has a home screen with apps on it, this icon will be the
tutorial plugins app icon.

.. image:: TutorialExampleIcon.png
   :scale: 30 %

----

Create directory :file:`peek_plugin_tutorial/_private/office-assets`

----

Download this plugin app icon
`TutorialExampleIcon.png <http://synerty-peek.readthedocs.io/en/latest/_images/TutorialExampleIcon.png>`_
to :file:`peek_plugin_tutorial/_private/office-assets/icon.png`

Edit File :file:`plugin_package.json`
`````````````````````````````````````

Finally, Edit the file :file:`peek_plugin_tutorial/plugin_package.json` to tell the
platform that we want to use the office service:

#.  Add **office** to the requiresServices section so it looks like ::

        "requiresServices": [
            "office"
        ]


#.  Add the **office** section after **requiresServices** section: ::


         "office": {
            "appDir": "_private/office",
            "appModule": "tutorial.module#TutorialModule",
            "assetDir": "_private/office-assets",
            "icon": "/assets/peek_plugin_tutorial/icon.png",
            "showHomeLink": true,
         }

#.  Ensure your JSON is still valid (Your IDE may help here)

Here is an example ::

        {
            ...
            "requiresServices": [
                ...
                "office"
            ],
            ...
             "office": {
                "appDir": "_private/office-app",
                "appModule": "tutorial.module#TutorialModule",
                "assetDir": "_private/office-assets",
                "icon": "/assets/peek_plugin_tutorial/icon.png",
                "showHomeLink": true,
            }
        }


.. _learn_plugin_development_add_office_service:

==================
Add Office Service
==================

This document is a stripped version of :ref:`learn_plugin_development_add_logic_service`.

Office Service File Structure
-----------------------------


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


.. note:: This file is created in :ref:`administer_peek_platform`.  Running the Office
    Service will also create the file.

Run :file:`run_peek_office_service`
```````````````````````````````````

Run the peek office service ::

        peek@_peek:~$ run_peek_office_service


you should see your plugin load. ::

        peek@_peek:~$ run_peek_office_service
        ...
        DEBUG peek_plugin_tutorial._private.office.OfficeEntryHook:Loaded
        DEBUG peek_plugin_tutorial._private.office.OfficeEntryHook:Started
        ...
        INFO txhttputil.site.SiteUtil:Peek Office Site is alive and listening on http://0.0.0.0:8002
        ...



Now bring up a web browser and navigate to
`http://localhost:8002 <http://localhost:8002>`_ or the IP mentioned in the output of
:command:`run_peek_office_service`.
