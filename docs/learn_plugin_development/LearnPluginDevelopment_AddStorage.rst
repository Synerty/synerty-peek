.. _learn_plugin_development_add_storage:

Adding the Storage Service
--------------------------

The storage service is conceptually a little different to other services in the Peek
Platform.

Peek Storage connects to a database server, provides each plugin it's own schema, and
provides much of the boilerplate code required to make this work.

Only two Peek Services are able to access the database, these are the Worker and Server
services.

The Storage schema upgrades are managed by the Server service.

.. note:: The Server service must be enabled to use the Storage service.

Add Skeleton Files
``````````````````

Create directory :file:`peek_plugin_tutorial/_private/storage`

Create the empty package file :file:`peek_plugin_tutorial/_private/storage/__init__.py`

Command: ::

        mkdir peek_plugin_tutorial/_private/storage
        touch peek_plugin_tutorial/_private/storage/__init__.py

----

Create a file :file:`peek_plugin_tutorial/_private/storage/DeclarativeBase.py`
and populate it with the following contents:

::

        from sqlalchemy.ext.declarative import declarative_base

        from sqlalchemy.schema import MetaData

        metadata = MetaData(schema="pl_tutorial")
        DeclarativeBase = declarative_base(metadata=metadata)


        def loadStorageTuples():
            """ Load Storage Tables

            This method should be called from the "load()" method of the agent, server, worker
            and client entry hook classes.

            This will register the ORM classes as tuples, allowing them to be serialised and
            deserialized by the vortex.

            """


----

Create directory :file:`peek_plugin_tutorial/_private/alembic`

Create the empty package file :file:`peek_plugin_tutorial/_private/alembic/__init__.py`

Command: ::

        mkdir peek_plugin_tutorial/_private/alembic
        touch peek_plugin_tutorial/_private/alembic/__init__.py

----

Create directory :file:`peek_plugin_tutorial/_private/alembic/versions`

Create the empty package file :file:`peek_plugin_tutorial/_private/alembic/versions/__init__.py`

Command: ::

        mkdir peek_plugin_tutorial/_private/alembic/versions
        touch peek_plugin_tutorial/_private/alembic/versions/__init__.py

----

Create a file :file:`peek_plugin_tutorial/_private/alembic/env.py` and populate it with
the following contents:

::

        from peek_plugin_base.storage.AlembicEnvBase import AlembicEnvBase

        from peek_plugin_tutorial._private.storage import DeclarativeBase

        DeclarativeBase.loadStorageTuples()

        alembicEnv = AlembicEnvBase(DeclarativeBase.DeclarativeBase.metadata)
        alembicEnv.run()

----

Create a file :file:`peek_plugin_tutorial/_private/alembic/script.py.mako` and populate it with
the following contents:

::

        """${message}

        Peek Plugin Database Migration Script

        Revision ID: ${up_revision}
        Revises: ${down_revision | comma,n}
        Create Date: ${create_date}

        """

        # revision identifiers, used by Alembic.
        revision = ${repr(up_revision)}
        down_revision = ${repr(down_revision)}
        branch_labels = ${repr(branch_labels)}
        depends_on = ${repr(depends_on)}

        from alembic import op
        import sqlalchemy as sa
        import geoalchemy2
        ${imports if imports else ""}

        def upgrade():
            ${upgrades if upgrades else "pass"}


        def downgrade():
            ${downgrades if downgrades else "pass"}


----

Edit the file :file:`peek_plugin_tutorial/plugin_package.json` :

#.  Add **"storage"** to the requiresServices section so it looks like ::

        "requiresServices": [
            "storage"
        ]

#.  Add the **storage** section after **requiresServices** section: ::

        "storage": {
            "alembicDir": "_private/alembic"
        }

#.  Ensure your JSON is still valid (Your IDE may help here)

Here is an example ::

        {
            ...
            "requiresServices": [
                ...
                "storage"
            ],
            ...
            "storage": {
            }
        }

----

Edit the file :file:`peek_plugin_tutorial/_private/server/ServerEntryHook.py`

#.  Add the following import up the top of the file ::

        from peek_plugin_tutorial._private.storage import DeclarativeBase
        from peek_plugin_base.server.PluginServerStorageEntryHookABC import PluginServerStorageEntryHookABC

#.  Add **PluginServerStorageEntryHookABC** to the list of classes **"ServerEntryHook"**
    inherits ::

        class ServerEntryHook(PluginServerEntryHookABC, PluginServerStorageEntryHookABC):

#.  Call the following method from the **load(self):** method ::

        def load(self) -> None:
            DeclarativeBase.loadStorageTuples() # <-- Add this line
            logger.debug("Loaded")

#.  Implement the **dbMetadata(self):** property ::

        @property
        def dbMetadata(self):
            return DeclarativeBase.metadata

You should have a file like this: ::

        # Added imports, step 1
        from peek_plugin_noop._private.storage import DeclarativeBase
        from peek_plugin_base.server.PluginServerStorageEntryHookABC import \
            PluginServerStorageEntryHookABC


        # Added inherited class, step2
        class ServerEntryHook(PluginServerEntryHookABC, PluginServerStorageEntryHookABC):


            def load(self) -> None:
                # Added call to loadStorageTables, step 3
                DeclarativeBase.loadStorageTuples()
                logger.debug("Loaded")

            # Added implementation for dbMetadata, step 4
            @property
            def dbMetadata(self):
                return DeclarativeBase.metadata


----

Create a file :file:`peek_plugin_tutorial/_private/alembic.ini` and populate it with
the following contents, make sure to update the **sqlalchemy.url** line.

.. note:: The database connection string is only used when creating database upgrade
    scripts.

::

        [alembic]
        script_location = alembic
        sqlalchemy.url = postgresql://peek:PASSWORD@localhost/peek

----

Finally, run the peek server, it should load with out error.

The hard parts done, adding the tables is much easier.

Adding a Simple Table
`````````````````````

This section adds a simple table, For lack of a better idea, lets have a table of strings
and Integers.

----

Create the file :file:`peek_plugin_tutorial/_private/storage/StringIntTuple.py`
and populate it with the following contents.

Most of this is straight from the
`SQLAlchemy Object Relational Tutorial <http://docs.sqlalchemy.org/en/latest/orm/tutorial.html#declare-a-mapping>`_

::

        from sqlalchemy import Column
        from sqlalchemy import Integer, String
        from vortex.Tuple import Tuple, addTupleType

        from peek_plugin_tutorial._private.PluginNames import tutorialTuplePrefix
        from peek_plugin_tutorial._private.storage.DeclarativeBase import DeclarativeBase


        @addTupleType
        class StringIntTuple(Tuple, DeclarativeBase):
            __tupleType__ = tutorialTuplePrefix + 'StringIntTuple'
            __tablename__ = 'StringIntTuple'

            id = Column(Integer, primary_key=True, autoincrement=True)
            string1 = Column(String(50))
            int1 = Column(Integer)


The remainder is from VortexPY, which allows the object to be serialised,
and reconstructed as the proper python class. VortexPY is present in these three lines ::

        @addTupleType
        class StringIntTuple(Tuple, DeclarativeBase):
            __tupleType__ = tutorialTuplePrefix + 'StringIntTuple'


----

Edit the file :file:`peek_plugin_tutorial/_private/storage/DeclarativeBase.py`

#.  Add the lines to the **loadStoragetuples():** method ::

        from . import StringIntTuple
        StringIntTuple.__unused = False

----

Now we need create a database upgrade script, this allows Peek to automatically upgrade
the plugins schema. Peek uses Alembic to handle this.

Read more about `Alembic here <http://alembic.zzzcomputing.com/en/latest/>`_

#.  Open a :command:`bash` window
#.  CD to the _private directory of the plugin ::

        # Root dir of plugin project
        cd peek-plugin-tutorial

        # CD to where alembic.ini is
        cd peek_plugin_tutorial/_private

#.  Run the alembic upgrade command. ::

        alembic revision --autogenerate -m "Added StringInt Table"

    it should look like ::

        peek@peek:~/project/peek-plugin-tutorial/peek_plugin_tutorial/_private$ alembic revision --autogenerate -m "Added StringInt Table"
        LOAD TABLES
        19-Mar-2017 20:59:42 INFO alembic.runtime.migration:Context impl PostgresqlImpl.
        19-Mar-2017 20:59:42 INFO alembic.runtime.migration:Will assume transactional DDL.
        19-Mar-2017 20:59:42 INFO alembic.autogenerate.compare:Detected added table 'pl_tutorial.StringIntTuple'
        /home/peek/cpython-3.5.2/lib/python3.5/site-packages/sqlalchemy/dialects/postgresql/base.py:2705: SAWarning: Skipped unsupported reflection of expression-based index place_lookup_name_idx
          % idx_name)
        /home/peek/cpython-3.5.2/lib/python3.5/site-packages/sqlalchemy/dialects/postgresql/base.py:2705: SAWarning: Skipped unsupported reflection of expression-based index countysub_lookup_name_idx
          % idx_name)
        /home/peek/cpython-3.5.2/lib/python3.5/site-packages/sqlalchemy/dialects/postgresql/base.py:2705: SAWarning: Skipped unsupported reflection of expression-based index county_lookup_name_idx
          % idx_name)
        /home/peek/cpython-3.5.2/lib/python3.5/site-packages/sqlalchemy/dialects/postgresql/base.py:2705: SAWarning: Skipped unsupported reflection of expression-based index idx_tiger_featnames_lname
          % idx_name)
        /home/peek/cpython-3.5.2/lib/python3.5/site-packages/sqlalchemy/dialects/postgresql/base.py:2705: SAWarning: Skipped unsupported reflection of expression-based index idx_tiger_featnames_snd_name
          % idx_name)
          Generating /home/peek/project/peek-plugin-tutorial/peek_plugin_tutorial/_private/alembic/versions/6c3b8cf5dd77_added_stringint_table.py ... done


#.  Now check that Alembic has added a new version file in the
    :file:`peek_plugin_tutorial/_private/alembic/versions` directory.

.. tip::    You can add any kind of SQL you want to this script, if you want default data,
            then this is the place to add it.


Adding a Settings Table
```````````````````````

The Noop plugin has special Settings and SettingsProperty tables that is usefully for
storing plugin settings.

This section sets this up for the Tutorial plugin.

----

Download the :file:`Settings.py` file to :file:`peek_plugin_tutorial/_private/storage`
from `<https://bitbucket.org/synerty/peek-plugin-noop/raw/master/peek_plugin_noop/_private/storage/Setting.py>`_

----

Edit :file:`peek_plugin_tutorial/_private/storage/Settings.py`

#.  Find :command:`peek_plugin_noop` and replace it with :command:`peek_plugin_tutorial`.

#.  Find :command:`noopTuplePrefix` and replace it with :command:`tutorialTuplePrefix`.

----

Edit :file:`peek_plugin_tutorial/_private/storage/DeclarativeBase.py`

Add the following lines to the :command:`loadStorageTuples():` method ::

    from . import Setting
    Setting.__unused = False

----

Open a :command:`bash` window, run the alembic upgrade ::

        # Root dir of plugin project
        cd peek-plugin-tutorial/peek_plugin_tutorial/_private

        # Run the alembic command
        alembic revision --autogenerate -m "Added Setting Table"

----

Here is some example code for using the settings table.

Place the code in the :command:`start():` method in
:file:`peek_plugin_tutorial/_private/server/ServerEntryHook.py`

::

        session = self.dbSessionCreator()

        # This will retrieve all the settings
        allSettings = globalSetting(session)
        logger.debug(allSettings)

        # This will retrieve the value of property1
        value1 = globalSetting(session, key=PROPERTY1)
        logger.debug("value1 = %s" % value1)

        # This will set property1
        globalSetting(session, key=PROPERTY1, value="new value 1")
        session.commit()

        session.close()

