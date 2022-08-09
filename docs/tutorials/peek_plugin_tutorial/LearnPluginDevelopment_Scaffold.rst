.. _learn_plugin_development_scaffold:

========================
Scaffolding From Scratch
========================

In this section we'll create the basic files we need for a plugin.

:Plugin Name: peek_plugin_tutorial

    We'll finish up with a plugin which we can build a python package for, but it won't
    run on any services, we'll add that later.

Plugin File Structure
---------------------

Create Directory :file:`peek-plugin-tutorial`
`````````````````````````````````````````````

:file:`peek-plugin-tutorial` is the name of the project directory, it could be anything.
For consistency, we name it the same as the plugin with hyphens instead of underscores,
Python can't import directories with hyphens, so there will be no confusion there.

This directory will contain our plugin package, documentation, build scripts, README,
license, etc. These won't be included when the python package is built and deployed.

--

Create the plugin project root directory, and CD to it. ::

        peek-plugin-tutorial/

Commands: ::

        mkdir peek-plugin-tutorial
        cd peek-plugin-tutorial

----

.. note:: Future commands will be run from the plugin project root directory.

Add File :file:`.gitignore`
```````````````````````````

The :file:`.gitignore` file tells the git version control software to ignore certain
files in the project.
`gitignore - Specifies intentionally untracked files to ignore <https://git-scm.com/docs/gitignore>`_.

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
        docs/api_autoapi


Add :file:`.editorconfig`
`````````````````````````

Create the file :file:`.editorconfig`, with the following content: ::

        # https://editorconfig.org/

        root = true

        [*]
        indent_style = space
        indent_size = 4
        insert_final_newline = true
        trim_trailing_whitespace = true
        end_of_line = lf
        charset = utf-8


Add Package :file:`peek_plugin_tutorial`
````````````````````````````````````````

Package :file:`peek_plugin_tutorial` is the root
`python package <https://docs.python.org/3.5/tutorial/modules.html#packages>`_.
for our plugin.

This package will contain everything that is packaged up and deployed for the Peek
Platform to run. This includes:

*   The public declarations of the APIs used by other plugins.
    They are declared using
    `Python Abstract Base Classes <https://docs.python.org/3.5/library/abc.html>`_.

*   Private code that other plugins shouldn't reference.

*   Angular2 Components, modules, services and HTML.


----

.. note::   Commands will be run from the plugin project root directory, which is
            :file:`peek-plugin-tutorial`.


Create the :file:`peek_plugin_tutorial` Package. Commands: ::

        mkdir -p peek_plugin_tutorial
        touch peek_plugin_tutorial/__init__.py

----

Add the version string to the :file:`peek_plugin_tutorial` package. ::

        echo "__version__ = '0.0.0'" > peek_plugin_tutorial/__init__.py


.. note:: This version is automatically updated by the :command:`publish.sh` script.

Add Package :file:`_private`
````````````````````````````

Package :file:`peek_plugin_tutorial._private` will contain the parts of the plugin
that won't be exposed/shared for other plugins to use.

----

Create the :file:`peek_plugin_tutorial._private` Package. Commands: ::

        mkdir -p peek_plugin_tutorial/_private
        touch peek_plugin_tutorial/_private/__init__.py



The structure should now be: ::

        peek-plugin-tutorial
        └── .gitignore
        └── peek_plugin_tutorial
            ├── __init__.py
            └── _private
                └── __init__.py


Add File :file:`setup.py`
`````````````````````````

The :file:`setup.py` file tells the python distribution tools how to create a
distributable file for the plugin.
`Read more here <https://packaging.python.org/distributing/#setup-py>`_.

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
        package_version = '0.0.0'
        description = 'Peek Plugin Tutorial - My first enhancement.'

        download_url = 'https://bitbucket.org/synerty/%s/get/%s.zip'
        download_url %= pip_package_name, package_version
        url = 'https://bitbucket.org/synerty/%s' % pip_package_name



Add File :file:`publish.sh`
```````````````````````````

The :file:`publish.sh` file is custom script for building and publishing the plugin that
performs the following tasks:

*   Updates the version number in the project text files.
*   Pushes tags to git
*   Copies the built releases to $RELEASE_DIR if defined
*   Runs setup.py
*   Pushes the release to pypi.python.org

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

Create :file:`publish.settings.sh` with the following content: ::

        #!/usr/bin/env bash

        PY_PACKAGE="peek_plugin_tutorial"
        PYPI_PUBLISH="0"

        VER_FILES_TO_COMMIT=""

        VER_FILES=""

----

.. _learn_plugin_development_scaffold_add_file_readme:

Add File :file:`README.rst`
```````````````````````````

The file:`README.rst` file is a verbose description of this plugin, it's the file that
version control systems, such as BitBucket or GitHub will display when the project is
viewed on their sites.

It's ideal to include a great overview about the plugin in this file.

----

Create a README, create a :file:`README.rst` file and populate it.

Here is a suggestion: ::

        =================
        Tutorial Plugin 1
        =================

        This is a Peek Plugin, from the tutorial.


.. _package_json_explaination:

Add File :file:`plugin_package.json`
````````````````````````````````````

The :file:`plugin_package.json` describes the plugin to the Peek Platform. These details
include:

*   The version
*   The name
*   Which services the plugin needs
*   Additional settings for each service
*   File locations for the Angular applications (admin, office and field)
*   The path of the icon for the plugin,
*   ect.

----

Create the :file:`peek_plugin_tutorial/plugin_package.json` file with the following
contents: ::

    {
        "plugin": {
            "title": "Tutorial Plugin",
            "packageName": "peek_plugin_tutorial",
            "version": "0.0.0",
            "buildNumber": "#PLUGIN_BUILD#",
            "buildDate": "#BUILD_DATE#",
            "creator": "Synerty HQ Pty Ltd",
            "website": "www.synerty.com"
        },
        "requiresServices": [
        ],
        "admin": {
            "moduleDir": "plugin-module"
        },
        "field": {
            "moduleDir": "plugin-module"
        },
        "office": {
            "moduleDir": "plugin-module"
        }
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

Add File :file:`PluginNames.py`
```````````````````````````````

The :file:`PluginNames.py` file defines some constants that are used throughout the
plugin. More details on where these are used will be later in the documentation.

Since all of the plugin is on the one package, both the part of the plugin running on the
logic service and the part of the plugin running on the field or office apps can import this file.

Guaranteeing that there is no mismatch of names when they send data to each other.


----

Create the :file:`peek_plugin_tutorial/_private/PluginNames.py` file with the following
contents: ::

        tutorialPluginName = "peek_plugin_tutorial"
        tutorialFilt = {"plugin": "peek_plugin_tutorial"}
        tutorialTuplePrefix = "peek_plugin_tutorial."
        tutorialObservableName = "peek_plugin_tutorial"
        tutorialActionProcessorName = "peek_plugin_tutorial"
        tutorialTupleOfflineServiceName = "peek_plugin_tutorial"


Add Directory :file:`plugin-module/_private`
````````````````````````````````````````````

We now move onto the frontends, and TypeScript.

The :file:`plugin-module/_private` directory will contain code that shouldn't be used
outside of this plugin.

The :file:`plugin-module` directory will contain any code that needs to be either:

*   Running all the time in the background.

*   Shared with other modules.


This directory is sync'd to :file:`node_modules/@peek/peek_plugin_tutorial` on field,
admin and office services.

Developers can use some :file:`index.ts` magic to abstract the layout of their
directories.
An exmaple of importing declaration is as follows: ::

        import {tutorialFilt} from "@peek/peek_plugin_tutorial/_private";


----

Create directory :file:`peek_plugin_tutorial/plugin-module/_private`,
with command ::

        mkdir -p peek_plugin_tutorial/plugin-module/_private


Add File :file:`package.json`
`````````````````````````````

The :file:`package.json` file is required to keep NPM from winging, since this
directory is linked in under :file:`node_modules/@peek`

----

Create file
:file:`peek_plugin_tutorial/plugin-module/package.json`,
with contents ::

        {
          "name": "@peek/peek_plugin_tutorial",
          "version": "0.0.0"
        }


Add File :file:`PluginNames.ts`
```````````````````````````````

The :file:`PluginNames.ts` file defines constants used by this plugin to define,
payload filts, tuple names, oberservable names, etc.

----

Create file
:file:`peek_plugin_tutorial/plugin-module/_private/PluginNames.ts`,
with contents ::

        export let tutorialFilt = {"plugin": "peek_plugin_tutorial"};
        export let tutorialTuplePrefix = "peek_plugin_tutorial.";

        export let tutorialObservableName = "peek_plugin_tutorial";
        export let tutorialActionProcessorName = "peek_plugin_tutorial";
        export let tutorialTupleOfflineServiceName = "peek_plugin_tutorial";

        export let tutorialBaseUrl = "peek_plugin_tutorial";


Add File :file:`_private/index.ts`
``````````````````````````````````

The :file:`_private/index.ts` file defines exports from other files in _private.

This lets the code
:code:`import tutorialFilt from "@peek/peek_plugin_tutorial/_private";`
work instead of
:code:`import tutorialFilt from "@peek/peek_plugin_tutorial/_private/PluginNames";`.

It seems trival a this point, but it becomes more usefull as the TypeScript code grows.

----

Create file
:file:`peek_plugin_tutorial/plugin-module/_private/index.ts`, with contents ::

        export * from "./PluginNames";


Install in Development Mode
---------------------------

Installing the plugin in development mode, links the development directory of the plugin
(the directory we create in these instructions) into the python virtual environment.

With this link in place, any python code that want's to use our plugin, is able to import
it, and the code run will be the code we're working on.

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
        import os
        print(peek_plugin_tutorial.__version__)
        print(os.path.dirname(peek_plugin_tutorial.__file__))
        EOPY


----

You now have a basic plugin. In the next section we'll make it run on some services.
