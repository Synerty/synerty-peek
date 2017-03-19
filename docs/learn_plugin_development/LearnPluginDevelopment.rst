.. _learn_plugin_development:

========================
Learn Plugin Development
========================

The **peek_plugin_base** python package provides all the interfaces used for the Peek
Platform and the Plugins to function with each other.

The Platform Plugin API is available here  :ref:`peek_plugin_base`.

The following sections go on to guide the reader to develop different parts of the plugin
and eventually run the plugins in development mode
(:command:`ng serve`, :command:`tns run` etc).

Ensure you are well versed with the platform from the :ref:`Overview` as the following
sections build upon that.

The following sections will be usefull if you're starting a plugin with out cloning
peek_plugin_noop, or if you'd like to learn more about how to code different parts
of the plugin.

Check Setup First
-----------------

.. important:: Windows users must use :command:`bash`

These instructions are corss platform, windows users should use bash from msys, which
is easily installable form the windows git installer, see the instructions here,
:ref:`msys_git`.

----

Check Python

Before running through this procedure, ensure that your PATH variable includes the
right virtual environment for the platform you've installed. ::

        which python

This should return the location of your virtual environment, usually
:file:`~/synerty-peek-V.E.R/bin/python` on Linux or
or :file:`~/synerty-peek-V.E.R/Script/python` on windows. Where V.E.R is the version
number of the platform release, EG 0.2.0

Plugins and the Platform
------------------------


The Peek Platform services provide places for the Peek Plugins to run.
A plugin can chose to run on any service the platform provides.

Here is an architecture diagram for a plugin :

.. image:: LearnPluginOverview.png

Creating a New Plugin From Scratch
----------------------------------

In this section we'll create the basic files we need for a plugin.

:Plugin Name: peek_plugin_tutorial

We'll finish up with a plugin which we can build a python package for, but it won't
run on any services, we'll add that later.

----

Create the plugin project root directory, and CD to it. ::

        peek-plugin-tutorial/

Commands: ::

        mkdir -p peek-plugin-tutorial
        cd peek-plugin-tutorial

:file:`peek-plugin-tutorial` is the name of the project directory, it could be anything.
But for consistency, we name it the same as the plugin with hypons instead of underscores,
Python can't import directories with hypons, so there will be no confusion there.

This directory will contain our plugin package, documentation, build scripts, README,
license, etc. These won't be included when the python package is built and deployed.

----

Create :file:`.gitignore`, and populate it with the following ::

        # Byte-compiled / optimized / DLL files
        __pycache__/
        *.py[cod]
        *$py.class

        # auth generated js and jsmap files
        *.js
        *.js.map

        # Distribution / packaging
        .Python
        env/
        build/
        develop-eggs/
        *.egg-info
        MANIFEST
        dist
        .idea
        .vscode


----

.. note:: Future commands will be run from the plugin project root directory.

Create the main directories of your plugin. ::

        peek-plugin-tutorial/
        └── peek_plugin_tutorial
            └── _private

Commands: ::

        mkdir -p peek-plugin-tutorial/peek_plugin_tutorial/_private

:file:`peek_plugin_tutorial` is the python package directory for our plugin, this
directory will contain the declarations of the APIs used by other plugins. They are
declared using
`Python Abstract Base Classes <https://docs.python.org/3.5/library/abc.html>`_.

:file:`_private` will contain the parts of the plugin that won't be exposed/shared
for other plugins to use.

----

Create two :file:`__init__.py` files, these make python recognise the directories as
python packages.

File :file:`peek_plugin_tutorial/__init__.py` contains the following ::

        __version__ = '0.0.18'


File :file:`peek_plugin_tutorial/_private/__init__.py` is empty.

Commands: ::

        echo "__version__ = '0.0.18'" > peek_plugin_tutorial/__init__.py
        touch peek_plugin_tutorial/_private/__init__.py

The structure will be: ::

        peek-plugin-tutorial
        └── peek_plugin_tutorial
            ├── __init__.py # CREATE
            └── _private
                └── __init__.py # CREATE

----

Download :file:`setup.py` from
`peek-plugin-noop/setup.py <https://bitbucket.org/synerty/peek-plugin-noop/raw/master/setup.py>`_

Modify the options near the top of the file for your plugin. We've modified the following
values:

*   py_package_name
*   description
*   package_version

::

        #
        # Modify these values to fork a new plugin
        #
        author = "Synerty"
        author_email = 'contact@synerty.com'
        py_package_name = "peek_plugin_tutorial"
        pip_package_name = py_package_name.replace('_', '-')
        package_version = '0.0.1'
        description = 'Peek Plugin Tutorial - My first enhancement.'

        download_url = 'https://bitbucket.org/synerty/%s/get/%s.zip'
        download_url %= pip_package_name, package_version
        url = 'https://bitbucket.org/synerty/%s' % pip_package_name

----

Download :file:`publish.sh` from
`peek-plugin-noop/publish.sh <https://bitbucket.org/synerty/peek-plugin-noop/raw/master/publish.sh>`_

Modify the options near the top. We've modified the following:

*   PY_PACKAGE

::

        #------------------------------------------------------------------------------
        # Configure package preferences here
        PY_PACKAGE="peek_plugin_tutorial"

        # Leave blank not to publish
        # Or select one of the index servers defined in ~/.pypirc
        PYPI_PUBLISH=""

----

Create a README, create a :file:`README.rst` file and populate it.

Here is a suggestion: ::

        =================
        Tutorial Plugin 1
        =================

        This is a Peek Plugin, from the tutorial.

----

Create the :file:`peek_plugin_tutorial/plugin_package.json` file with the following
contents: ::

    {
        "plugin": {
            "title": "Tutorial Plugin",
            "packageName": "peek_plugin_tutorial",
            "version": "0.0.11",
            "buildNumber": "#PLUGIN_BUILD#",
            "buildDate": "#BUILD_DATE#",
            "creator": "Synerty Pty Ltd",
            "website": "www.synerty.com"
        },
        "requiresServices": [
        ]
    }

----

Check that your plugin now looks like this: ::

        peek-plugin-tutorial
        ├── peek_plugin_tutorial
        │   ├── __init__.py
        │   ├── plugin_package.json
        │   └── _private
        │       └── __init__.py
        ├── publish.sh
        ├── README.rst
        └── setup.py

----

Create the :file:`peek_plugin_tutorial/_private/PluginNames.py` file with the following
contents: ::

        tutorialFilt = {"plugin": "peek_plugin_tutorial"}
        tutorialTuplePrefix = "peek_plugin_tutorial."
        tutorialObservableName = "peek_plugin_tutorial"
        tutorialActionProcessorName = "peek_plugin_tutorial"


----

Install the python plugin package in development mode, run the following:

::


        # Check to ensure we're using the right python
        which python

        python setup.py develop

You can test that it's worked with the following python code, run the following in bash:

::

        python << EOPY
        import peek_plugin_tutorial
        print(peek_plugin_tutorial.__version__)
        EOPY


----

You now have a basic plugin. In the next section we'll make it run on some services.


Adding the Server Service
-------------------------


Configure the Plugin
````````````````````
This section adds the basic files require for the plugin to run on the servers service.
Create the following files and directories.

.. note:: Setting up skeleton files for the client, worker and agent services,
            is identical to the server, generally replace "Server" with the appropriate
            service name.

The platform loads the plugins python package, and then calls the appropriate
**peek{Server}EntryHook()** method on it, if it exists.

The object returned must implement the right interfaces, the platform then calls methods
on this object to load, start, stop, unload, etc the plugin.

----

Create directory :file:`peek_plugin_tutorial/_private/server`

Create an empty package file in the server directory,
:file:`peek_plugin_tutorial/_private/server/__init__.py`

Commands: ::

        mkdir peek_plugin_tutorial/_private/server
        touch peek_plugin_tutorial/_private/server/__init__.py

----

Create the file :file:`peek_plugin_tutorial/_private/server/ServerEntryHook.py`
and populate it with the following contents.

::

        import logging

        from peek_plugin_base.server.PluginServerEntryHookABC import PluginServerEntryHookABC

        logger = logging.getLogger(__name__)


        class ServerEntryHook(PluginServerEntryHookABC):
            def load(self) -> None:
                logger.debug("Loaded")

            def start(self):
                logger.debug("Started")

            def stop(self):
                logger.debug("Stopped")

            def unload(self):
                logger.debug("Unloaded")

----

Edit the file :file:`peek_plugin_tutorial/__init__.py`, and add the following: ::

        from peek_plugin_base.server.PluginServerEntryHookABC import PluginServerEntryHookABC
        from typing import Type


        def peekServerEntryHook() -> Type[PluginServerEntryHookABC]:
            from ._private.server.ServerEntryHook import ServerEntryHook
            return ServerEntryHook

----

Edit the file :file:`peek_plugin_tutorial/plugin_package.json` :

#.  Add **"server"** to the requiresServices section so it looks like ::

        "requiresServices": [
            "server"
        ]

#.  Add the **server** section after **requiresServices** section: ::

        "server": {
        }

#.  Ensure your JSON is still valid (Your IDE may help here)

Here is an example ::

        {
            "plugin": {
                ...
            },
            "requiresServices": [
                "server"
            ],
            "server": {
            }
        }


----

The plugin should now be ready for the server to load.

Running on the Server Service
`````````````````````````````

Edit :file:`~/peek-server.home/config.json`:

#.  Ensure **logging.level** is set to **"DEBUG"**
#.  Add **"peek_plugin_tutorial"** to the **plugin.enabled** array

.. note:: It would be helpful if this is the only plugin enabled at this point.

It should somthing like this: ::

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

.. note:: This file is created in :ref:`deploy_peek_platform`

----

You can now run the peek server, you should see your plugin load. ::

        peek@peek:~$ run_peek_server
        ...
        DEBUG peek_plugin_tutorial._private.server.ServerEntryHook:Loaded
        DEBUG peek_plugin_tutorial._private.server.ServerEntryHook:Started
        ...


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

