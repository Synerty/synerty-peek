.. _learn_plugin_development_add_observable:

===============
Add Observables
===============

Outline
-------

In this document, we setup the Tuple Observable from VortexJS. The Mobile and Desktop
services use this to request and receive data updates from the Service service.

We'll use the term "devices" interchangeably with Mobile/Desktop.

This is a one directional data flow once the initial request has been made, the
Server will send updates to the Mobile/Desktop with out the Mobile/Desktop services
polling for it.

In the example setup, the Client proxies Observable requests/responses
between the Server and Mobile/Desktop devices. The Proxy on the Client is aware
of all the Mobile/Desktop devices that want to observe the data, the Server only knows
that the Client is observing the data.

.. note:: The Mobile/Desktop devices don't and can't talk directly to the Server service.

The :code:`TupleDataObservableHandler` class provides the "observable" functionality,
It receives request for data by being sent a :code:`TupleSelector`. The TupleSelector
describes the Tuple type and some conditions of the data the observer wants.

Advantages
``````````
#.  Instant and efficient data updates, data immediately sent to the devices
    with out the devices congesting bandwidth with polls.

Disadvantages
`````````````

#.  There is no support for updates.


.. image:: LearnObservable_DataFlow.png

Objective
---------

In this document, our plugin will observe updates made to the table created in
:ref:`learn_plugin_development_add_storage_add_string_int_table` via the admin
web app.

This is the order:

#.  Add the Observable scaffolding for the project.
#.  Add the Server side Tuple Provider
#.  Tell the Admin TupleLoader to notify the Observable when it makes updates.
#.  Add a new Mobile Angular component to observe and display the data.

Server Service
--------------

Add Package :file:`tuple_providers`
```````````````````````````````````

The :file:`tuple_providers` python package will contain the classes that generate tuple
data to send via the observable.

----

Create the :file:`peek_plugin_tutorial/_private/server/tuple_providers` package, with
the commands ::

        mkdir peek_plugin_tutorial/_private/server/tuple_providers
        touch peek_plugin_tutorial/_private/server/tuple_providers/__init__.py


Add File :file:`TupleDataObservable.py`
```````````````````````````````````````

The :file:`TupleDataObservable.py` creates the Observable, registers the
tuple providers (they implement :code:`TuplesProviderABC`)

TupleProviders know how to get the Tuples.

----

Create the file
:file:`peek_plugin_tutorial/_private/server/TupleDataObservable.py`
and populate it with the following contents.

::

        from vortex.handler.TupleDataObservableHandler import TupleDataObservableHandler

        from peek_plugin_tutorial._private.PluginNames import tutorialFilt
        from peek_plugin_tutorial._private.PluginNames import tutorialObservableName


        def makeTupleDataObservableHandler(ormSessionCreator):
            """" Make Tuple Data Observable Handler

            This method creates the observable object, registers the tuple providers and then
            returns it.

            :param ormSessionCreator: A function that returns a SQLAlchemy session when called

            :return: An instance of :code:`TupleDataObservableHandler`

            """
            observable = TupleDataObservableHandler(observableName=tutorialObservableName,
                                                   additionalFilt=tutorialFilt)

            # Register TupleProviders here

            return observable


Edit File :file:`ServerEntryHook.py`
````````````````````````````````````

We need to update :file:`ServerEntryHook.py`, it will initialise the observable object
when the Plugin is started.

----

Edit the file :file:`peek_plugin_tutorial/_private/server/ServerEntryHook.py`:

#.  Add this import at the top of the file with the other imports: ::

        from .TupleDataObservable import makeTupleDataObservableHandler

#.  Add this line after the docstring in the :code:`start()` method: ::

        self._loadedObjects.append(makeTupleDataObservableHandler(self.dbSessionCreator))


----

The observable for the Server service is setup now. We'll add a TupleProvider later.

Client Service
--------------

Add File :file:`DeviceTupleDataObservableProxy.py`
``````````````````````````````````````````````````

The :file:`DeviceTupleDataObservableProxy.py` creates the Observable Proxy.
This class is responsible for proxying obserable data between the devices and the Server.

It reduces the load on the server, providing the ability to create more Client services
to scale Peek out for more users, or speed up responsiveness for remote locations.

TupleProviders know how to get the Tuples.

----

Create the file
:file:`peek_plugin_tutorial/_private/client/DeviceTupleDataObservableProxy.py`
and populate it with the following contents.

::

        from peek_plugin_base.PeekVortexUtil import peekServerName
        from peek_plugin_tutorial._private.PluginNames import tutorialFilt
        from peek_plugin_tutorial._private.PluginNames import tutorialObservableName
        from vortex.handler.TupleDataObservableProxyHandler import TupleDataObservableProxyHandler


        def makeDeviceTupleDataObservableProxy():
            return TupleDataObservableProxyHandler(observableName=tutorialObservableName,
                                                   proxyToVortexName=peekServerName,
                                                   additionalFilt=tutorialFilt)



Edit File :file:`ClientEntryHook.py`
````````````````````````````````````

We need to update :file:`ClientEntryHook.py`, it will initialise the observable proxy
object when the Plugin is started.

----

Edit the file :file:`peek_plugin_tutorial/_private/client/ClientEntryHook.py`:

#.  Add this import at the top of the file with the other imports: ::

        from .DeviceTupleDataObservableProxy import makeDeviceTupleDataObservableProxy

#.  Add this line after the docstring in the :code:`start()` method: ::

        self._loadedObjects.append(makeDeviceTupleDataObservableProxy())


Mobile Service
--------------

Now we need to edit the Angular module in the mobile-app and create the Providers