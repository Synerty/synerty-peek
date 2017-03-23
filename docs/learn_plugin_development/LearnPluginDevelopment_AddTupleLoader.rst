.. _learn_plugin_development_add_tuple_loader:

================
Add Tuple Loader
================

In this document, we'll use the TulpeLoader from VortexJS to load and update some
settings from the tables created in
:ref:`learn_plugin_development_add_storage_add_string_int_table` and tuples created in
:ref:`learn_plugin_development_add_tuples`.

The Admin and Server services talk to each other via a Vortex, this is the name
given to the transport layer of VortexJS and VortexPY.

A plugin developer could choose to use standard HTTP requests with JSON, however,
the Vortex maintains a persistent connection unless it's shutdown.

.. image:: LearnAddTupleLoader_PluginOverview.png

This document modifies both the server and admin parts of the plugin.

Add Package :file:`admin_backend`
---------------------------------

The :file:`admin_backend` python package will contain the classes that provide
data sources to the Admin web app.

----

Create the :file:`peek_plugin_tutorial/_private/server/admin_backend` package, with
the commands ::

        mkdir peek_plugin_tutorial/_private/server/admin_backend
        touch peek_plugin_tutorial/_private/server/admin_backend/__init__.py


Add File :file:`StringIntTableHandler.py`
-----------------------------------------

The :file:`StringIntTableHandler.py` listens for payload from the Admin service (frontend)
These payloads are delivered by the vortex.

When the :code:`OrmCrudHandler` class in the Server services
receives the payloads from the :code:`TupleLoader` in the Admin frontend,
it creates, reads, updates or deletes (CRUD) data in the the database.

----

Create the file 
:file:`peek_plugin_tutorial/_private/admin_backend/StringIntTableHandler.py`
and populate it with the following contents.

::

        from peek_plugin_tutorial._private.PluginNames import tutorialFilt
        from peek_plugin_tutorial._private.storage.StringIntTuple import StringIntTuple
        from vortex.TupleSelector import TupleSelector
        from vortex.handler.TupleDataObservableHandler import TupleDataObservableHandler
        from vortex.sqla_orm.OrmCrudHandler import OrmCrudHandler, OrmCrudHandlerExtension

        # This dict matches the definition in the Admin angular app.
        filtKey = {"key": "admin.Edit.StringIntTuple"}
        filtKey.update(tutorialFilt)


        # This is the CRUD hander
        class __CrudHandler(OrmCrudHandler):
            pass


        # This method creates an instance of the handler class.
        def makeStringIntTableHandler(dbSessionCreator):
            handler = __CrudHandler(dbSessionCreator, StringIntTuple,
                                    filtKey, retreiveAll=True)

            logger.debug("Started")
            return handler


Edit File :file:`admin_backend/__init__.py`
-------------------------------------------

In this step, we add a setup method on the admin_backend package, this setup medthod
then loads all the handlers needed for the backend.

This just helps sectionalise the code a bit.

The :code:`makeAdminBackendHandlers` method is a generator because we use :code:`yield`.
We can yield more items after the first one, the calling will get an iterable return.

----

Edit file :file:`peek_plugin_tutorial/_private/server/admin_backend/__init__.py`
Add the following:

::

        from .StringIntTableHandler import makeStringIntTableHandler

        def makeAdminBackendHandlers(dbSessionCreator):
            yield makeStringIntTableHandler(dbSessionCreator)


Edit File :file:`ServerEntryHook.py`
------------------------------------

Now, we need to create and destroy our :code:`admin_backend` handlers when the Server
service starts the plugin.

If you look at :code:`self._loadedObjects`, you'll see that the :code:`stop()` method
shuts down all objects we add to this array. So adding to this array serves two purposes

#.  It keeps a reference to the object, ensureing it isn't garbage collected when the
    :code:`start()` method ends.

#.  It ensures all the objects are properly shutdown. In our case, this means it stops
    listening for payloads.

----

Edit file :file:`peek_plugin_tutorial/_private/server/ServerEntryHook.py` :

#.  Add this import up the top of the file ::

        from .admin_backend import makeAdminBackendHandlers

#.  Add this line after the docstring in the :code:`start()` method ::

        self._loadedObjects.extend(makeAdminBackendHandlers(self.dbSessionCreator))


The method should now look similar to this ::

        def start(self):
            """ Load

            This will be called when the plugin is loaded, just after the db is migrated.
            Place any custom initialiastion steps here.

            """
            self._loadedObjects.extend(makeAdminBackendHandlers(self.dbSessionCreator))
            logger.debug("Started")



Test Python Services
--------------------

The backend changes are complete, please run :command:`run_peek_server` to ensure that
there are no problems here.


Add Directory :file:`edit-string-int-table`
-------------------------------------------

The :file:`edit-string-int-table` directory will contain the view and controller
that allows us to edit data in the admin app.

----

Create directory :file:`peek_plugin_tutorial/_private/admin-app/edit-string-int-table`

Add File :file:`edit.component.html`
------------------------------------

The :file:`edit.component.html` file is the HTML file for the Angular component
(:file:`edit.component.ts`) we create next.

This view will display the data, allow us to edit it and save it.

----

Create the file
:file:`peek_plugin_tutorial/_private/admin-app/edit-string-int-table/edit.component.html`
and populate it with the following contents.

::

        <div class="panel panel-default">
            <div class="panel-body">
                <table class="table">
                    <tr>
                        <th>String 1</th>
                        <th>Int 1</th>
                        <th></th>
                    </tr>
                    <tr *ngFor="let item of items">
                        <td>
                            <input [(ngModel)]="item.string1"
                                   class="form-control input-sm"
                                   type="text"/>
                        </td>
                        <td>
                            <input [(ngModel)]="item.int1"
                                   class="form-control input-sm"
                                   type="number"/>
                        </td>
                        <td>
                            <div class="btn btn-default" (click)='removeRow(item)'>
                                <span class="glyphicon glyphicon-minus" aria-hidden="true"></span>
                            </div>
                        </td>
                    </tr>
                </table>
                <div class="btn-toolbar">
                    <div class="btn-group">
                        <div class="btn btn-default" (click)='loader.save(items)'>
                            Save
                        </div>
                        <div class="btn btn-default" (click)='loader.load()'>
                            Reset
                        </div>
                        <div class="btn btn-default" (click)='addRow()'>
                            Add
                        </div>
                    </div>
                </div>
            </div>
        </div>


There are two buttons in this HTML that are related to the TupleLoader, these call
methods on the loader, :code:`loader.save(items)`, :code:`loader.load()`.

Add File :file:`edit.component.ts`
----------------------------------

The :file:`edit.component.ts` is the Angular Component for the new edit page.

In this component:

#.  We inherit from ComponentLifecycleEventEmitter, this provides a little automatic
    unsubscription magic for VortexJS

#.  We define the filt, this is a dict that is used by payloads to describe where
    payloads should be routed to on the other end.

#.  We ask Angular to inject the Vortex services we need, this is in the constructor.

#.  We get the VortexService to create a new TupleLoader.

#.  We subscribe to the data from the TupleLoader.

----

Create the file
:file:`peek_plugin_tutorial/_private/admin-app/edit-string-int-table/edit.component.ts`
and populate it with the following contents.

::

        import {Component, OnInit} from "@angular/core";
        import {
            extend,
            VortexService,
            ComponentLifecycleEventEmitter,
            TupleLoader
        } from "@synerty/vortexjs";
        import {StringIntTuple,
            tutorialPluginFilt
        } from "@peek/peek_plugin_tutorial/_private";


        @Component({
            selector: 'pl-tutorial-edit-string-int',
            templateUrl: './edit.component.html'
        })
        export class EditStringIntComponent extends ComponentLifecycleEventEmitter {
            // This must match the dict defined in the admin_backend handler
            private readonly filt = {
                "key": "admin.Edit.StringIntTuple"
            };

            items: StringIntTuple[] = [];

            loader: TupleLoader;

            constructor(vortexService: VortexService) {
                super();

                this.loader = vortexService.createTupleLoader(this,
                    () => extend({}, this.filt, tutorialPluginFilt));

                this.loader.observable
                    .subscribe((tuples:StringIntTuple[]) => this.items = tuples);
            }

            addRow() {
                this.items.push(new StringIntTuple());
            }

            removeRow(item) {
                if (confirm("Delete Row? All unsaved changes will be lost.")) {
                    this.loader.del([item]);
                }
            }

        }


Edit File :file:`tutorial.component.html`
-----------------------------------------

Update the :file:`tutorial.component.html` to insert the new
:code:`EditStringIntComponent` component into the HTML.

----

Edit the file :file:`peek_plugin_tutorial/_private/admin-app/tutorial.component.html`:

#.  Find the :code:`</ul>` tag and insert the following before that line: ::

        <!-- Edit String Int Tab -->
        <li role="presentation" class="active">
            <a href="#editStringInt" aria-controls="editStringInt"
                role="tab" data-toggle="tab">Edit String Int</a>
        </li>

#.  Find the :code:`<div class="tab-content">` tag and insert the following after
    the line it: ::

        <!-- Edit String Int Tab -->
        <div role="tabpanel" class="tab-pane active" id="editStringInt">
            <pl-tutorial-edit-string-int></pl-tutorial-edit-string-int>
        </div>


Edit File :file:`tutorial.module.ts`
------------------------------------

Edit the :file:`tutorial.module.ts` Angular Module to import the
:code:`EditStringIntComponent` component.


----

Edit the :file:`peek_plugin_tutorial/_private/admin-app/tutorial.module.ts`:

#.  Add this import statement with the imports at the top of the file: ::

        import {EditStringIntComponent} from "./edit-string-int-table/edit.component";

#.  Add :code:`EditStringIntComponent` to the :code:`declarations` array, EG: ::

        declarations: [TutorialComponent, EditStringIntComponent]


Test Tuple Loader
-----------------

Restart the Server service, so that it rebuilds the Admin Angular Web app.

Natigate your browser to the admin page, select plugins, and then selec the
"Edit String Int" tab.
