.. _learn_plugin_development_add_office_app:

==============
Add Office App
==============

The office app is similar to the field app. This document is a stripped version of
:ref:`learn_plugin_development_add_field_app`.

Office File Structure
---------------------

Add Directory :file:`office-app`
````````````````````````````````

Commands: ::

        mkdir -p peek_plugin_tutorial/_private/office-app


Add File :file:`tutorial.component.dweb.html`
`````````````````````````````````````````````

Create the :file:`peek_plugin_tutorial/_private/office-app/tutorial.component.dweb.html` with the following contents:

::

        <div class="container">
            <h1 class="text-center">Tutorial Plugin</h1>
            <p>Angular2 Lazy Loaded Module</p>
            <p>This is the root of the office app for the Tutorial plugin</p>
        </div>

Add File :file:`tutorial.component.ts`
``````````````````````````````````````

Create the file :file:`peek_plugin_tutorial/_private/office-app/tutorial.component.ts` and populate it with the following contents.

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

Create the file :file:`peek_plugin_tutorial/_private/office-app/tutorial.module.ts`
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

#.  Add **office-app** to the requiresServices section so it looks like ::

        "requiresServices": [
            "office-app"
        ]


#.  Add the **office** section after **requiresServices** section: ::


         "office-app": {
            "appDir": "_private/office-app",
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

Run :file:`run_peek_office_service`
```````````````````````````````````

Run the peek office service ::

        peek@_peek:~$ run_peek_office_service
        ...
        INFO txhttputil.site.SiteUtil:Peek Office Site is alive and listening on http://0.0.0.0:8002
        ...


Now bring up a web browser and navigate to
`http://localhost:8002 <http://localhost:8002>`_ or the IP mentioned in the output of
:command:`run_peek_office_service`.
