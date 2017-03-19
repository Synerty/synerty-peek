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

Setup Skeleton Files
````````````````````
This section adds the basic files require for the plugin to run on the servers service.
Create the following files and directories.

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

.. note:: It would be good for now if this is the only plugin enabled.

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

.. note:: This file is created :ref:`deploy_peek_platform`

----

You can now run the peek server, you should see your plugin load. ::

        peek@peek:~/project/peek-server$ run_peek_server
        ...
        DEBUG peek_plugin_tutorial._private.server.ServerEntryHook:Loaded
        DEBUG peek_plugin_tutorial._private.server.ServerEntryHook:Started
        ...

