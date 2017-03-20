.. _learn_plugin_development_add_admin:

Adding the Admin Service
------------------------

The admin service is the admin user interface.

In this section we'll add the root admin page for the plugin. We only scratch the surface
of using Angular, thats outside the scope of this guide.

We will go into the details of getting data with VortexJS/VortexPY.

Adding the Root Admin Page
``````````````````````````

Create directory :file:`peek_plugin_tutorial/_private/admin-app`

----

Create the file :file:`peek_plugin_tutorial/_private/admin-app/tutorial.component.html`
and populate it with the following contents.

::

        <div class="container">
            <h1 class="text-center">Tutorial Plugin</h1>
            <p>Angular2 Lazy Loaded Module</p>
            <p>This is the root of the admin app for the Tutorial plugin</p>
        </div>


----

Create the file :file:`peek_plugin_tutorial/_private/admin-app/tutorial.component.ts`
and populate it with the following contents.

::

        import {Component, OnInit} from "@angular/core";

        @Component({
            selector: 'tutorial-admin',
            templateUrl: 'tutorial.component.html'
        })
        export class TutorialComponent  implements OnInit {

            ngOnInit() {

            }
        }

----

Create the file :file:`peek_plugin_tutorial/_private/admin-app/tutorial.module.ts`
and populate it with the following contents.

::

        import {CommonModule} from "@angular/common";
        import {NgModule} from "@angular/core";
        import {Routes, RouterModule} from "@angular/router";

        // Import our components
        import {TutorialComponent} from "./tutorial.component";

        // Define the routes for this Angular module
        export const pluginRoutes: Routes = [
            {
                path: '',
                component: TutorialComponent
            }

        ];

        // Define the module
        @NgModule({
            imports: [
                CommonModule,
                RouterModule.forChild(pluginRoutes)],
            exports: [],
            providers: [],
            declarations: [TutorialComponent]
        })
        export class TutorialModule {

        }

----

Finally, Edit the file :file:`peek_plugin_tutorial/plugin_package.json` to tell the
platform that we want to use the admin service:

#.  Add **"admin"** to the requiresServices section so it looks like ::

        "requiresServices": [
            "server"
        ]

#.  Add the **admin** section after **requiresServices** section: ::

        "admin": {
            "showHomeLink": true,
            "appDir": "_private/admin-app",
            "appModule": "tutorial.module#TutorialModule"
        }

#.  Ensure your JSON is still valid (Your IDE may help here)

Here is an example ::

        {
            ...
            "requiresServices": [
                ...
                "admin"
            ],
            ...
            "admin": {
                "showHomeLink": true,
                "appDir": "_private/admin-app",
                "appModule": "tutorial.module#TutorialModule"
            }
        }

----

Running on the Admin Service
````````````````````````````
The Peek Server service provides the web service that serves the admin angular
application.

The Peek Server service takes care of combining all the plugin files into the build
directories in the peek_admin package. We will need to restart Peek Server for it to
include our plugin in the admin UI.


Check the :file:`~/peek-server.home/config.json` file:

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


----

You can now run the peek server, you should see your plugin load. ::

        peek@peek:~$ run_peek_server
        ...
        INFO peek_platform.frontend.WebBuilder:Rebuilding frontend distribution
        ...
        INFO txhttputil.site.SiteUtil:Peek Admin is alive and listening on http://10.211.55.14:8010
        ....

----

Not bring up a web browser and natigate to
`http://localhost:8010 <http://localhost:8010>`_ or the IP mentioned in the output of
:command:`run_peek_server`.

If you see this, then congratulations, you've just enabled your plugin to use the
Peek Platform, Admin Service.

.. image:: PeekAdminSuccess.png

