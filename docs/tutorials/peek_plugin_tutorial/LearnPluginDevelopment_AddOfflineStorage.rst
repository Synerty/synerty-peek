.. _learn_plugin_development_add_offline_storage:

===================
Add Offline Storage
===================

Outline
-------

The Offline Storage is used by the Field and Office services. It provides an easy way
to save and load tuples in the devices

This data can be accessed offline,
or loaded before the Field or Office service has responded to a request for data.

In this document, we setup a provider for the Angular Service.

Field Service
-------------

Edit File :file:`tutorial.module.ts`
````````````````````````````````````

Edit the :file:`tutorial.module.ts` Angular module for the tutorial plugin to
add the provider entry for the storage service.

----

Edit the file
:file:`peek_plugin_tutorial/_private/field-app/tutorial.module.ts`:

#.  Add the following imports: ::

        // Import the required classes from VortexJS
        import {
            TupleOfflineStorageNameService,
            TupleOfflineStorageService
        } from "@synerty/vortexjs";

        // Import the names we need for the
        import {
            tutorialTupleOfflineServiceName
        } from "@peek/peek_plugin_tutorial/_private";


#.  After the imports, add this function ::

        export function tupleOfflineStorageNameServiceFactory() {
            return new TupleOfflineStorageNameService(tutorialTupleOfflineServiceName);
        }

#.  Finally, add this snippet to the :code:`providers` array in
    the :code:`@NgModule` decorator ::


        TupleOfflineStorageService, {
            provide: TupleOfflineStorageNameService,
            useFactory:tupleOfflineStorageNameServiceFactory
        },


It should look similar to the following:

::

        ...

        import {
            TupleOfflineStorageNameService,
            TupleOfflineStorageService
        } from "@synerty/vortexjs";
        import {
            tutorialTupleOfflineServiceName
        } from "@peek/peek_plugin_tutorial/_private";

        ...

        export function tupleOfflineStorageNameServiceFactory() {
            return new TupleOfflineStorageNameService(tutorialTupleOfflineServiceName);
        }


        @NgModule({
            ...
            providers: [
                ...
                TupleOfflineStorageService, {
                    provide: TupleOfflineStorageNameService,
                    useFactory:tupleOfflineStorageNameServiceFactory
                },
                ...
            ]
        })
        export class TutorialModule {

        }


----

Complete.

The tutorial plugin is now setup to use the TupleOffline serivce. This service is
used by :code:`TupleActionPushOfflineService` and
:code:`TupleDataOfflineObserverService` services.

A developer can use the :code:`TupleOfflineStorageService` service if they wish but thats
out side the scope of this tutorial.
