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
python packages. The files are empty. ::


        peek-plugin-tutorial
        └── peek_plugin_tutorial
            ├── __init__.py # CREATE
            └── _private
                └── __init__.py # CREATE

Commands: ::

        touch peek_plugin_tutorial/__init__.py
        touch peek_plugin_tutorial/_private/__init__.py
