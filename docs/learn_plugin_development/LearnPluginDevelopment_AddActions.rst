.. _learn_plugin_development_add_actions:

===========
Add Actions
===========


Outline
-------

In this document we setup the VortexJS Tuple Actions.

Since the Vortex serialisable base class is called a :code:`Tuple`, Actions
are referred to as "Action Tuples", and name :code:`DoSomethingActionTuple`.

A Tuple Action represents an action the user has taken, this can be:

*   Clicking a button (:code:`TupleGenericAction`)
*   Updating data (:code:`TupleUpdateAction`)
*   Some other action (extend :code:`TupleActionABC`)

The Action design is ideal for apps where there are many users observing
data more than altering it or performing actions against it.

Typically, users can only only perform so many updates per a minute. TupleActions takes
the approach of having many small, discrete "Actions" that can be sent back to the
server as they are performed.

The Observable then ensures that all users watching the data are updated immediately,
Keeping all users working with the latest data as TupleActions processed.

This helps avoid issues,
such as one users update overwriting another users update.
These issues you will get if you're using the VortexJS TupleLoader for many users.

There are two Angular services that provide support for pushing Tuple Actions to the
Client service.

#.  :code:`TupleActionPushService`, for online only actions.

#.  :code:`TupleActionPushOfflineService`, for actions that will be stored locally and
    delivered when the device is next online.

Both these services have the same functional interface, :code:`pushAction()`.

.. image:: LearnAction_DataFlow.png

On the Server service, the :code:`TupleActionProcessorProxy` class receives
all the TupleActions, delegates
processing to a :code:`TupleActionProcessorDelegateABC` class. A delegate can be
registered to handle just one type of action, and/or a default delegate can be
registered to catch all.

Like the Observable, there is a :code:`TupleActionProcessorProxy` needed in the
Client service that passes actions onto the Server service for processing.

Unlike the Observable, the TupleAction Client proxy passes every action onto the
Server service, waits for a response from the Server service then sends that back to
the Mobile or Desktop device.

Actions require responses. Callers of the :code:`TupleActionPushService` will receive a
promise which resolve regardless of if the push timed out or failed.

In the case of :code:`TupleActionPushOfflineService`, a promise is returned and resolved
on success of the commit to the database in the Desktop/Mobile device.

The :code:`TupleActionPushOfflineService` will continually retry until it receives
either a success or failure response from the Client service.

.. note:: The Mobile/Desktop devices don't and can't talk directly to the Server service.


.. image:: LearnAction_Response.png


Advantages
``````````
#.  Reduces the risk of one update overwriting another.
#.  Atomic changes can more easily be buffered when the device is offline.
#.  Smaller, more immediate results for updates.

Disadvantages
`````````````

#.  This could lead to higher resource usage and less efficiont commits.


Objective
---------

In this document, our plugin will provide the following actions to the user:

#.  Increase or decrease an Int
#.  Toggle capitals of a string

The action will be processed by the Server which will update the table created in
:ref:`learn_plugin_development_add_storage_add_string_int_table`.

This is the order:

#.  Add the Action scaffolding for the project.
#.  Add the Server side Action Processor
#.  Alter the Observable tutorial UI to incorporate buttons and send the actions.

Add Python Tuples
-----------------



Add File :file:`AddIntValueActionTuple.py`
``````````````````````````````````````````

The :file:`AddIntValueActionTuple.py` defines a python action tuple.

----

Create the file 
:file:`peek_plugin_tutorial/_private/tuples/AddIntValueActionTuple.py`
and populate it with the following contents.

::

        from vortex.Tuple import addTupleType, TupleField
        from vortex.TupleAction import TupleActionABC

        from tutorial_data_dms._private.PluginNames import tutorialTuplePrefix

        
        @addTupleType
        class AddIntValueActionTuple(TupleActionABC):
            __tupleType__ = tutorialTuplePrefix + "AddIntValueActionTuple"
        
            stringIntId = TupleField()



Add File :file:`StringIntDecreaseActionTuple.py`
````````````````````````````````````````````````

The :file:`StringIntDecreaseActionTuple.py` defines a python action tuple.

----

Create the file 
:file:`peek_plugin_tutorial/_private/tuples/StringIntDecreaseActionTuple.py`
and populate it with the following contents.

::

        from vortex.Tuple import addTupleType, TupleField
        from vortex.TupleAction import TupleActionABC

        from tutorial_data_dms._private.PluginNames import tutorialTuplePrefix

        
        @addTupleType
        class StringIntDecreaseActionTuple(TupleActionABC):
            __tupleType__ = tutorialTuplePrefix + "StringIntDecreaseActionTuple"
        
            stringIntId = TupleField()
            offset = TupleField()


Edit File :file:`_private/tuples/__init__.py`
`````````````````````````````````````````````

In this step, we add a setup method on the tuples package, this setup method
then loads all the handlers needed for the backend.

----

Edit file :file:`peek_plugin_tutorial/_private/tuples/__init__.py`.

Find the method :code:`loadPrivateTuples()`, append the following lines: ::

            from . import AddIntValueActionTuple
            AddIntValueActionTuple.__unused = False

            from . import StringIntDecreaseActionTuple
            StringIntDecreaseActionTuple.__unused = False


Add TypeScript Tuples
---------------------


Add :file:`StringCapToggleActionTuple.ts`
`````````````````````````````````````````

The :file:`StringCapToggleActionTuple.ts` file defines a TypeScript class for our
:code:`StringCapToggleActionTuple` Tuple Action.

----

Create file
:file:`peek_plugin_tutorial/plugin-module/_private/tuples/StringCapToggleActionTuple.ts`,
with contents ::

        import {addTupleType, Tuple, TupleActionABC} from "@synerty/vortexjs";
        import {tutorialTuplePrefix} from "../PluginNames";
        
        @addTupleType
        export class StringCapToggleActionTuple extends TupleActionABC {
            static readonly tupleName = tutorialTuplePrefix + "StringCapToggleActionTuple";
        
            stringIntId: number;
        
            constructor() {
                super(StringCapToggleActionTuple.tupleName)
            }
        }



Add :file:`AddIntValueActionTuple.ts`
`````````````````````````````````````

The :file:`AddIntValueActionTuple.ts` file defines a TypeScript class for our
:code:`AddIntValueActionTuple` Tuple Action.

----

Create file
:file:`peek_plugin_tutorial/plugin-module/_private/tuples/AddIntValueActionTuple.ts`,
with contents ::

        import {addTupleType, Tuple, TupleActionABC} from "@synerty/vortexjs";
        import {tutorialTuplePrefix} from "../PluginNames";
        
        @addTupleType
        export class AddIntValueActionTuple extends TupleActionABC {
            static readonly tupleName = tutorialTuplePrefix + "AddIntValueActionTuple";
        
            stringIntId: number;
            offset: number;
        
            constructor() {
                super(AddIntValueActionTuple.tupleName)
            }
        }



Edit File :file:`_private/index.ts`
```````````````````````````````````

The :file:`_private/index.ts` file will re-export the Tuples in a more standard way.
Developers won't need to know the exact path of the file.

----

Edit file :file:`peek_plugin_tutorial/plugin-module/_private/index.ts`,
Append the lines: ::

        export {AddIntValueActionTuple} from "./tuples/AddIntValueActionTuple";
        export {StringCapToggleActionTuple} from "./tuples/StringCapToggleActionTuple";



Server Service Setup
--------------------

Add Package :file:`controller`
``````````````````````````````

The :file:`controller` python package will contain the classes that provide logic to
the plugin, like a brain controlling limbs.

.. note:: Though the tutorial creates "controllers", the plugin developer can decide how
            ever they want to structure this.

----

Create the :file:`peek_plugin_tutorial/_private/server/controller` package, with
the commands ::

        mkdir peek_plugin_tutorial/_private/server/controller
        touch peek_plugin_tutorial/_private/server/controller/__init__.py


Add File :file:`MainController.py`
``````````````````````````````````

The :file:`MainController.py` will glue everything together. For large plugins there
will be multiple sub controllers.

In this example we have everything in MainController.

----

Create the file
:file:`peek_plugin_tutorial/_private/server/controller/TupleDataObservable.py`
and populate it with the following contents.

::

        import logging

        from twisted.internet.defer import Deferred
        from txhttputil.util.DeferUtil import deferToThreadWrap

        from vortex.TupleSelector import TupleSelector
        from vortex.TupleAction import TupleActionABC
        from vortex.handler.TupleActionProcessor import TupleActionProcessorDelegateABC
        from vortex.handler.TupleDataObservableHandler import TupleDataObservableHandler

        from peek_plugin_tutorial._private.storage.StringIntTuple import StringIntTuple
        from peek_plugin_tutorial._private.tuples.AddIntValueActionTuple import AddIntValueActionTuple
        from peek_plugin_tutorial._private.tuples.StringCapToggleActionTuple import StringCapToggleActionTuple

        logger = logging.getLogger(__name__)


        class MainController(TupleActionProcessorDelegateABC):
            def __init__(self, dbSessionCreator, tupleObservable: TupleDataObservableHandler):
                self._dbSessionCreator = dbSessionCreator
                self._tupleObservable = tupleObservable

            def shutdown(self):
                pass

            def processTupleAction(self, tupleAction: TupleActionABC) -> Deferred:

                if isinstance(tupleAction, AddIntValueActionTuple):
                    return self._processIncrease(tupleAction)

                if isinstance(tupleAction, StringCapToggleActionTuple):
                    return self._processIncrease(tupleAction)

                raise NotImplementedError(tupleAction.tupleName())

            @deferToThreadWrap
            def _processCapToggleString(self, action: StringCapToggleActionTuple):
                try:
                    # Perform update using SQLALchemy
                    session = self._dbSessionCreator()
                    row = (session.query(StringIntTuple)
                           .filter(StringIntTuple.id == action.stringIntId)
                           .one())

                    # Exit early if the string is empty
                    if not row.string1:
                        logger.debug("string1 for StringIntTuple.id=%s is empty")
                        return

                    if row.string1[0].isupper():
                        row.string1 = row.string1.lower()
                        logger.debug("Toggled to lower")
                    else:
                        row.string1 = row.string1.upper()
                        logger.debug("Toggled to upper")

                    session.commit()

                    # Notify the observer of the update
                    # This tuple selector must exactly match what the UI observes
                    tupleSelector = TupleSelector(StringIntTuple.tupleName(), {})
                    self._tupleDataObserver.notifyOfTupleUpdate(tupleSelector)

                finally:
                    # Always close the session after we create it
                    session.close()


            @deferToThreadWrap
            def _processAddIntValue(self, action: AddIntValueActionTuple):
                try:
                    # Perform update using SQLALchemy
                    session = self._dbSessionCreator()
                    row = (session.query(StringIntTuple)
                           .filter(StringIntTuple.id == action.stringIntId)
                           .one())
                    row.int1 += action.offset
                    session.commit()

                    logger.debug("Incremented by %s" + action.offset)

                    # Notify the observer of the update
                    # This tuple selector must exactly match what the UI observes
                    tupleSelector = TupleSelector(StringIntTuple.tupleName(), {})
                    self._tupleDataObserver.notifyOfTupleUpdate(tupleSelector)

                finally:
                    # Always close the session after we create it
                    session.close()




Add File :file:`TupleActionProcessor.py`
````````````````````````````````````````

The class in file :file:`TupleActionProcessor.py`, accepts all tuple actions for this
plugin and calls the relevent :code:`TupleActionProcessorDelegateABC`.

----

Create the file
:file:`peek_plugin_tutorial/_private/server/TupleActionProcessor.py`
and populate it with the following contents.

::

        from vortex.handler.TupleActionProcessor import TupleActionProcessor

        from peek_plugin_tutorial._private.PluginNames import tutorialFiltFilt
        from peek_plugin_tutorial._private.PluginNames import tutorialActionProcessorName
        from .controller.MainController import  MainController


        def makeTupleActionProcessorHandler(mainController: MainController):
            processor = TupleActionProcessor(
                tupleActionProcessorName=tutorialActionProcessorName,
                additionalFilt=tutorialFiltFilt,
                defaultDelegate=mainController)
            return processor



Edit File :file:`ServerEntryHook.py`
````````````````````````````````````

We need to update :file:`ServerEntryHook.py`, it will initialise the
 :code:`MainController` and :code:`TupleActionProcessor` objects.

----

Edit the file :file:`peek_plugin_tutorial/_private/server/ServerEntryHook.py`:

#.  Add this import at the top of the file with the other imports: ::

        from .TupleActionProcessor import makeTupleActionProcessorHandler
        from .controller.MainController import MainController

#.  Add this line just before :code:`logger.debug("started")` in
    the :code:`start()` method: ::


        mainController = MainController(
            dbSessionCreator=self.dbSessionCreator,
            tupleObservable=tupleObservable)

        self._loadedObjects.append(mainController)
        self._loadedObjects.append(makeTupleActionProcessorHandler(mainController))

----

The Action Processor for the Server service is setup now.

Client Service Setup
--------------------

Add File :file:`DeviceTupleProcessorActionProxy.py`
```````````````````````````````````````````````````

The :file:`DeviceTupleProcessorActionProxy.py` creates the Tuple Action Processoe Proxy.
This class is responsible for proxying action tuple data between the devices
and the Server.

----

Create the file
:file:`peek_plugin_tutorial/_private/client/DeviceTupleProcessorActionProxy.py`
and populate it with the following contents.

::

        from peek_plugin_base.PeekVortexUtil import peekServerName
        from peek_plugin_tutorial._private.PluginNames import tutorialFilt
        from peek_plugin_tutorial._private.PluginNames import tutorialActionProcessorName
        from vortex.handler.TupleDataObservableProxyHandler import TupleDataObservableProxyHandler


        def makeTupleActionProcessorProxy():
            return TupleActionProcessorProxy(
                        tupleActionProcessorName=tutorialActionProcessorName,
                        proxyToVortexName=peekServerName,
                        additionalFilt=tutorialFilt)



Edit File :file:`ClientEntryHook.py`
````````````````````````````````````

We need to update :file:`ClientEntryHook.py`, it will initialise the tuple action proxy
object when the Plugin is started.

----

Edit the file :file:`peek_plugin_tutorial/_private/client/ClientEntryHook.py`:

#.  Add this import at the top of the file with the other imports: ::

        from .DeviceTupleProcessorActionProxy import makeTupleActionProcessorProxy

#.  Add this line after the docstring in the :code:`start()` method: ::

        self._loadedObjects.append(makeTupleActionProcessorProxy())


Mobile Service Setup
--------------------

Now we need to edit the Angular module in the mobile-app and add the providers:


Edit File :file:`tutorial.module.ts`
````````````````````````````````````

Edit the :file:`tutorial.module.ts` Angular module for the tutorial plugin to
add the provider entry for the TupleAction service.

----

Edit the file
:file:`peek_plugin_tutorial/_private/mobile-app/tutorial.module.ts`:

#.  Add the following imports: ::

        // Import the required classes from VortexJS
        import {
            TupleActionPushNameService,
            TupleActionPushOfflineService,
            TupleActionPushService,
        } from "@synerty/vortexjs";

        // Import the names we need for the
        import {
            tutorialActionProcessorName,
            tutorialFilt
        } from "@peek/peek_plugin_tutorial/_private";


#.  After the imports, add this function ::

        export function tupleActionPushNameServiceFactory() {
            return new TupleActionPushNameService(
                tutorialActionProcessorName, tutorialFilt);
        }

#.  Finally, add this snippet to the :code:`providers` array in
    the :code:`@NgModule` decorator ::


        TupleActionPushOfflineService, TupleActionPushService, {
            provide: TupleActionPushNameService,
            useFactory:tupleActionPushNameServiceFactory
        },


It should look similar to the following: ::

        ...

        import {
            TupleActionPushNameService,
            TupleActionPushOfflineService,
            TupleActionPushService,
        } from "@synerty/vortexjs";

        import {
            tutorialActionProcessorName,
            tutorialFilt
        } from "@peek/peek_plugin_tutorial/_private";

        ...

        export function tupleActionPushNameServiceFactory() {
            return new TupleActionPushNameService(
                tutorialActionProcessorName, tutorialFilt);
        }


        @NgModule({
            ...
            providers: [
                ...
                TupleActionPushOfflineService, TupleActionPushService, {
                    provide: TupleActionPushNameService,
                    useFactory:tupleActionPushNameServiceFactory
                },
                ...
            ]
        })
        export class TutorialModule {

        }


----

At this point, all of the Tuple Action setup is done. It's much easier to work with the
tuple action code from here on.






Add Mobile View
---------------

Finally, lets add a new component to the mobile screen.


edit File :file:`string-int.component.mweb.html`
````````````````````````````````````````````````

todo

----

edit the file
:file:`peek_plugin_tutorial/_private/mobile-app/string-int/string-int.component.mweb.html`
and populate it with the following contents.

::

        <div class="container">
            <Button class="btn btn-default" (click)="mainClicked()">Back to Main</Button>

            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>String</th>
                        <th>Int</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr *ngFor="let item of stringInts">
                        <td>{{item.string1}}</td>
                        <td>{{item.int1}}</td>
                           <td> <!-- BRENTON xxxxxxx add three buttons-->
            <Button class="btn btn-default" (click)="toggleUpperCicked(item)">Back to Main</Button>
            <Button class="btn btn-default" (click)="incrementCicked(item)">Back to Main</Button>
            <Button class="btn btn-default" (click)="decrementCicked(item)">Back to Main</Button></td>
                    </tr>
                </tbody>
            </table>
        </div>


edit File :file:`string-int.component.ns.html`
``````````````````````````````````````````````
todo

----

edit the file
:file:`peek_plugin_tutorial/_private/mobile-app/string-int/string-int.component.ns.html`
and populate it with the following contents.

::

        <StackLayout class="p-20" >
            <Button text="Back to Main" (tap)="mainClicked()"></Button>

            <GridLayout columns="4*, 1*" rows="auto" width="*">
                <Label class="h3" col="0" text="String"></Label>
                <Label class="h3" col="1" text="Int"></Label>
            </GridLayout>

            <ListView [items]="stringInts">
                <template let-item="item" let-i="index" let-odd="odd" let-even="even">
                    <StackLayout [class.odd]="odd" [class.even]="even" >
                        <GridLayout columns="4*, 1*" rows="auto" width="*">
                            <!-- String -->
                            <Label class="h3 peek-field-data-text" row="0" col="0"
                                   textWrap="true"
                                   [text]="item.string1"></Label>

                            <!-- Int -->
                            <Label class="h3 peek-field-data-text" row="0" col="1"
                                   [text]="item.int1"></Label>



                        </GridLayout>
                            <!-- BRENTON xxxxxxx add three buttons-->
            <Button text="Back to Main" (tap)="toggleUpperCicked(item)"></Button>
            <Button text="Back to Main" (tap)="incrementCicked(item)"></Button>
            <Button text="Back to Main" (tap)="decrementCicked(item)"></Button>
                    </StackLayout>
                </template>
            </ListView>
        </StackLayout>


edit File :file:`string-int.component.ts`
`````````````````````````````````````````

todo


----

edit the file
:file:`peek_plugin_tutorial/_private/mobile-app/string-int/string-int.component.ts`

add to constructor arguments ::

        private actionService: TupleActionPushService,

add the methods to component class ::


            toggleUpperCicked(item) {
                let action = new StringCapToggleActionTuple();
                action.stringIntId = item.id;
                this.actionService.pushAction(action)
                .then(()=>{
                alert('success');

                })
                .catch ((err)=>{
                alert(err);
                });
            }


            incrementCicked(item) {
                let action = new AddIntValueActionTuple();
                action.stringIntId = item.id;
                action.offset = 1;
                this.actionService.pushAction(action)
                .then(()=>{
                alert('success');

                })
                .catch ((err)=>{
                alert(err);
                });
            }



            decrementCicked(item) {
                let action = new AddIntValueActionTuple();
                action.stringIntId = item.id;
                action.offset = -1;
                this.actionService.pushAction(action)
                .then(()=>{
                alert('success');

                })
                .catch ((err)=>{
                alert(err);
                });
            }



todo from here


todo from here

todo from here

todo from here

todo from here


Testing
-------

#.  Open mobile Peek web app
#.  Tap the Tutorial app icon
#.  tap the "String Ints" button

#.  Expect to see the string ints data.

#.  Update the data from the Admin service UI

#.  The data on the mobile all will immediately change.



Offline Observable
------------------

The Synerty VortexJS library has an :code:`TupleDataOfflineObserverService`,
once offline storage has been setup,
(here :ref:`learn_plugin_development_add_offline_storage`),
the offline observable is a dropin replacement.

When using the offline observable, it will:

#.  Queue a request to observe the data, sending it to the client

#.  Query the SQL db in the browser/mobile device, and return the data for the observer.
    This provides instant data for the user.

When new data is sent to the the observer (Mobile/Desktop service)
from the observable (Client service), the offline observer does two things:

#.  Notifies the subscribers like normal

#.  Stores the data back into the offline db, in the browser / app.


Edit File :file:`string-int.component.ts`
`````````````````````````````````````````

:code:`TupleDataOfflineObserverService` is a drop-in replacement for
:code:`TupleDataObserverService`.

Switching to use the offline observer requires two edits to
:file:`string-int.component.ts`.

----

Edit file
:file:`peek_plugin_tutorial/_private/mobile-app/string-int/string-int.component.ts`.

Add the import for the TupleDataOfflineObserverService: ::

    import TupleDataOfflineObserverService from "@synerty/vortexjs";

Change the type of the :code:`tupleDataObserver` parameter in the component constructor,
EG,

From ::

        constructor(private tupleDataObserver: TupleDataObserverService, ...) {

To ::

        constructor(private tupleDataObserver: TupleDataOfflineObserverService, ...) {

----

Thats it. Now the String Int data will load on the device, even when the Vortex between
the device and the Client service is offline.

