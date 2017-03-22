.. _learn_plugin_development_add_tuple_loader:

================
Add Tuple Loader
================

In this document, we'll use the TulpeLoader from VortexJS to load and update some
settings from the tables created in
:ref:`learn_plugin_development_add_storage_add_simple_table`.

The Admin and Server services talk to each other via a Vortex, this is the name
given to the transport layer of VortexJS and VortexPY.

A plugin developer could choose to use standard HTTP requests with JSON, however,
the Vortex maintains a persistent connection unless it's shutdown.

.. image:: LearnAddTupleLoader_PluginOverview.png

Add Package :file:`admin_backend`
---------------------------------

The :file:`admin_backend` python package will contain the classes that provide
data sources to the Admin web app.

----

Create the :file:`peek_plugin_tutorial/_private/server/admin_backend` package, with
the commands ::

        mkdir peek_plugin_tutorial/_private/server/admin_backend
        touch peek_plugin_tutorial/_private/server/admin_backend/__init__.py


Add File :file:`SimpleTableHandler.py`
--------------------------------------

The :file:`SimpleTableHandler.py` listens for payload from the Admin service (frontend)
These payloads are delivered by the vortex.

When the :code:`OrmCrudHandler` class in the Server services
receives the payloads from the :code:`TupleLoader` in the Admin frontend,
it creates, reads, updates or deletes (CRUD) data in the the database.

----

Create the file 
:file:`peek_plugin_tutorial/_private/admin_backend/SimpleTableHandler.py`
and populate it with the following contents.

::

        from peek_plugin_tutorial._private.PluginNames import tutorialFilt
        from peek_plugin_tutorial._private.storage.StringIntTuple import StringIntTuple
        from vortex.TupleSelector import TupleSelector
        from vortex.handler.TupleDataObservableHandler import TupleDataObservableHandler
        from vortex.sqla_orm.OrmCrudHandler import OrmCrudHandler, OrmCrudHandlerExtension

        # This dict matches what will be used from the Admin class
        filtKey = {"key": "admin.Edit.StringIntTuple"}
        filtKey.update(tutorialFilt)


        # This is the CRUD hander
        class __CrudHandler(OrmCrudHandler):
            pass


        # This method creates an instance of the handler class.
        def makeEditLookupHandler(dbSessionCreator):
            handler = __CrudHandler(dbSessionCreator, StringIntTuple,
                                    filtKey, retreiveAll=True)
        
            return handler

Add Directory :file:`admin-app`
-------------------------------

The :file:`admin-app` directory will contain the plugins the Angular application.

Angular "Lazy Loads" this part of the plugin, meaning it only loads it when the user
navigates to the page, and unloads it when it's finished.

This allows large, single page web applications to be made. Anything related to the user
interface should be lazy loaded.

----

Create directory :file:`peek_plugin_tutorial/_private/admin-app`

Add File :file:`tutorial.component.html`
----------------------------------------

The :file:`tutorial.component.html` file is the HTML file for the Angular component
(:file:`tutorial.component.ts`) we create next.

----

Create the file :file:`peek_plugin_tutorial/_private/admin-app/tutorial.component.html`
and populate it with the following contents.

::

        <div class="container">
            <h1 class="text-center">Tutorial Plugin</h1>
            <p>Angular2 Lazy Loaded Module</p>
            <p>This is the root of the admin app for the Tutorial plugin</p>
        </div>


Add File :file:`tutorial.component.ts`
--------------------------------------

The :file:`tutorial.component.ts` is the Angular Component for the admin page.
It's loaded by the default route defined in :file:`tutorial.module.ts`.

`See NgModule for more <https://angular.io/docs/ts/latest/guide/ngmodule.html>`_

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

