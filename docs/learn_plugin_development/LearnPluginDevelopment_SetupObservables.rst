.. _learn_plugin_development_setup_observable:

========================
Setup Observables (TODO)
========================

** TODO **


** TODO **


** TODO **


** TODO **


** TODO **





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
it creates, reads, updates or deletes data in the the database.

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


        filtKey = {"key": "admin.Edit.StringIntTuple"}
        filtKey.update(tutorialFilt)

        class __CrudHandler(OrmCrudHandler):
            pass


        class __ObserverUpdate(OrmCrudHandlerExtension):
            def __init__(self, tupleDataObserver: TupleDataObservableHandler):
                self._tupleDataObserver = tupleDataObserver

            def _tellObserver(self, tuple_, tuples, session, payloadFilt):
                tupleSelector = TupleSelector(StringIntTuple.tupleName(),
                                              {"lookupName": payloadFilt["lookupName"]})
                self._tupleDataObserver.notifyOfTupleUpdate(tupleSelector)
                return True

            afterUpdateCommit = _tellObserver
            afterDeleteCommit = _tellObserver


        def makeEditLookupHandler(tupleObserver, dbSessionCreator):
            handler = __CrudHandler(dbSessionCreator, StringIntTuple,
                                    filtKey, retreiveAll=True)

            handler.addExtension(StringIntTuple, __ObserverUpdate(tupleObserver))

            return handler
