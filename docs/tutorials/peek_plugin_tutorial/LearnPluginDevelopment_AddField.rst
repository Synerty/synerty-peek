.. _learn_plugin_development_add_field_app:

=============
Add Field App
=============

The field app is for the users. It's the interface designed for mobile devices.

The field app is known as the "frontend" in web terminology.
The backend for the field app is the field service.

The Peek field app is built with an Angular `web build <https://angular.io/docs/ts/latest/>`_.

In this document, we'll add the start of both the field and office builds for the plugin.

We only scratch the surface of using Angular, that`s outside the scope of this guide.

See :ref:`developing_with_the_frontends` to learn more about how Peek
pieces together the frontend code from the various plugins.

Field App File Structure
------------------------

Add Directory :file:`field`
```````````````````````````````

The :file:`field` directory will contain the plugins the field Angular application requires.

Angular "Lazy Loads" this part of the plugin, meaning it only loads it when the user
navigates to the page, and unloads it when it's finished.

This allows large, single page web applications to be made. Anything related to the user
interface should be lazy loaded.

----

Create directory :file:`peek_plugin_tutorial/_private/field`

Create an empty package file in the field directory,
:file:`peek_plugin_tutorial/_private/field/__init__.py`

Commands: ::

        mkdir peek_plugin_tutorial/_private/field
        touch peek_plugin_tutorial/_private/field/__init__.py


Add File :file:`tutorial.component.mweb.html`
`````````````````````````````````````````````

The :file:`tutorial.component.mweb.html` file is the web app HTML **view** for
the Angular component :file:`tutorial.component.ts`.

This is standard HTML that is compiled by Angular. Angular compiles the HTML,
looking for Angular directives, and alters it in place in the browser.

For more information about Angular directives, See:

*   `Attribute Directives <https://angular.io/docs/ts/latest/guide/attribute-directives.html>`_
*   `Structural Directives <https://angular.io/docs/ts/latest/guide/structural-directives.html>`_

----

Create the file
:file:`peek_plugin_tutorial/_private/field/tutorial.component.mweb.html`
and populate it with the following contents.

::

        <div class="container">
            <h1 class="text-center">Tutorial Plugin</h1>
            <p>Angular2 Lazy Loaded Module</p>
            <p>This is the root of the field app for the Tutorial plugin</p>
        </div>

Add File :file:`tutorial.component.ts`
``````````````````````````````````````

The :file:`tutorial.component.ts` is the Angular Component for the field app page.
It's loaded by the default route defined in :file:`tutorial.module.ts`.

.. note::   The one Angular component drives both the Capacitor and Web app views.
            More on this later.

----

Create the file :file:`peek_plugin_tutorial/_private/field/tutorial.component.ts`
and populate it with the following contents.

::

        import {Component} from "@angular/core";

        @Component({
            selector: 'plugin-tutorial',
            templateUrl: 'tutorial.component.mweb.html',
            moduleId: module.id
        })
        export class TutorialComponent {

            constructor() {

            }

        }


Add File :file:`tutorial.module.ts`
```````````````````````````````````

The :file:`tutorial.module.ts` is the main Angular module of the plugin.

This file can describe other routes, that will load other components.
This is standard Angular.

`See NgModule for more <https://angular.io/docs/ts/latest/guide/ngmodule.html>`_


----

Create the file :file:`peek_plugin_tutorial/_private/field/tutorial.module.ts`
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

The Peek field interface has a home screen with apps on it, this icon will be the
tutorial plugins app icon.

.. image:: TutorialExampleIcon.png
   :scale: 30 %

----

Create directory :file:`peek_plugin_tutorial/_private/field-assets`

----

Download this plugin app icon
`TutorialExampleIcon.png <http://synerty-peek.readthedocs.io/en/latest/_images/TutorialExampleIcon.png>`_
to :file:`peek_plugin_tutorial/_private/field-assets/icon.png`


Edit File :file:`plugin_package.json`
`````````````````````````````````````

Finally, Edit the file :file:`peek_plugin_tutorial/plugin_package.json` to tell the
platform that we want to use the field service:

#.  Add **"field"** to the requiresServices section so it looks like ::

        "requiresServices": [
            "field"
        ]

#.  Add the **field** section after **requiresServices** section: ::

        "field": {
            "showHomeLink": true,
            "appDir": "_private/field-app",
            "appModule": "tutorial.module#TutorialModule",
            "assetDir": "_private/field-assets",
            "icon": "/assets/peek_plugin_tutorial/icon.png"
        }


#.  Ensure your JSON is still valid (Your IDE may help here)

Here is an example ::

        {
            ...
            "requiresServices": [
                ...
                "field"
            ],
            ...
            "field": {
                "showHomeLink": true,
                "appDir": "_private/field-app",
                "appModule": "tutorial.module#TutorialModule",
                "assetDir": "_private/field-assets",
                "icon": "/assets/peek_plugin_tutorial/icon.png"
            }
        }


.. _learn_plugin_development_add_field_service:

==================
Add Field Service
==================

This document is a stripped version of :ref:`learn_plugin_development_add_logic_service`.


Add File :file:`FieldEntryHook.py`
----------------------------------

Create the file :file:`peek_plugin_tutorial/_private/field/FieldEntryHook.py`
and populate it with the following contents.

::

        import logging

        from peek_plugin_base.field.PluginFieldEntryHookABC import PluginFieldEntryHookABC

        logger = logging.getLogger(__name__)


        class FieldEntryHook(PluginFieldEntryHookABC):
            def __init__(self, *args, **kwargs):
                """" Constructor """
                # Call the base classes constructor
                PluginFieldEntryHookABC.__init__(self, *args, **kwargs)

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

        from peek_plugin_base.field.PluginFieldEntryHookABC import PluginFieldEntryHookABC
        from typing import Type


        def peekFieldEntryHook() -> Type[PluginFieldEntryHookABC]:
            from ._private.field.FieldEntryHook import FieldEntryHook
            return FieldEntryHook


Edit :file:`plugin_package.json`
--------------------------------

Edit the file :file:`peek_plugin_tutorial/plugin_package.json` :

#.  Add **"field"** to the requiresServices section so it looks like ::

        "requiresServices": [
            "field",
        ]

#.  Add the **field** section after **requiresServices** section: ::

        "field": {
        },

#.  Ensure your JSON is still valid (Your IDE may help here)

Here is an example ::

        {
            "plugin": {
                ...
            },
            "requiresServices": [
                "field",
            ],
            "field": {
            },
        }


----

The plugin should now be ready for the field to load.

Running on the Field Service
-----------------------------

Edit :file:`~/peek-field-service.home/config.json`:

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


.. note:: This file is created in :ref:`administer_peek_platform`.  Running the Field
    Service will also create the file.


Check File :file:`~/peek-field-service.home/config.json`
````````````````````````````````````````````````````````

Check the :file:`~/peek-field-service.home/config.json` file:

#.  Ensure **frontend.webBuildEnabled** is set to **true**, with no quotes
#.  Ensure **frontend.webBuildPrepareEnabled** is set to **true**, with no quotes

.. note:: It would be helpful if this is the only plugin enabled at this point.

Example: ::

        {
            ...
            "frontend": {
                ...
                "webBuildEnabled": true,
                "webBuildPrepareEnabled": true
            },
            ...
        }



Run :file:`run_peek_office_service`
```````````````````````````````````

You can now run the peek office service, you should see your plugin load. ::

        peek@_peek:~$ run_peek_office_service
        ...
        DEBUG peek_plugin_tutorial._private.office.OfficeEntryHook:Loaded
        DEBUG peek_plugin_tutorial._private.office.OfficeEntryHook:Started
        ...
        INFO peek_platform.frontend.WebBuilder:Rebuilding frontend distribution
        ...
        INFO txhttputil.site.SiteUtil:Peek Office App is alive and listening on http://10.211.55.14:8000
        ...

----

Now bring up a web browser and navigate to
`http://localhost:8000 <http://localhost:8000>`_ or the IP mentioned in the output of
:command:`run_peek_field_service`.

If you see this, then congratulations, you've just enabled your plugin to use the
Peek Platform, Field Service Web App.

.. image:: LearnAddFieldWebHomeScreen.png

----

Click on the Tutorial app, you should then see your plugins default route component.

.. image:: LearnAddFieldWebPluginScreen.png

