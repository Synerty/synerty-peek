.. _learn_plugin_development_add_docs:

=================
Add Documentation
=================

Why does a plugin need documentation? A peek plugin needs documentation to help
developers focus on what it needs to do, and allow other developers to use the APIs it
shares.

Then it helps Peek admins determine the plugins requirements and if there is a need for
it.

Documenting software can be a complicated and a tedious task. There are many things to
consider:

*   Documentation must be versioned with the code, making sure features match, etc.

*   Documentation must be available for each version of the code, your documentation
    will branch as many times as your code will, 1.0, 1.1, etc

*   Documentation must be updated as features are added and changed in the code.

These are a few of the conundrums around the complexity of software documentation.
Fortunately there are some fantastic tools around to solve these issues, and you're
reading the result of those tools right now.

Sphinx is a tool that makes it easy to create intelligent and beautiful
documentation.


Documentation File Structure
----------------------------

The peek-plugin is structured in such a way that the plugin developer can create
documentation for 3 different audiences:

- Administrators
- Users
- Developers


Add Admin Documentation
-----------------------

Create directory :file:`peek_plugin_tutorial/admin_doc`: ::

    mkdir -p peek_plugin_tutorial/admin_doc

----

Create the file :file:`index.rst`: within the directory
:file:`peek_plugin_tutorial/admin_doc` with following content: ::

        ==============
        Administration
        ==============

        The Peek-Plugin-Tutorial plugin performs the following:

        -   Point 1

        -   Point 2

----

Edit the file :file:`peek_plugin_tutorial/plugin_package.json`:

Add "admin_doc" to the :code:`requiredServices` section so it looks like: ::

    "requiresServices": [
        ...
        "admin_doc"
        ...
    ]

Add the "admin_doc" section after requiresServices section: ::

    "admin_doc": {
        "docDir": "admin_doc",
        "docRst": "index.rst"
    }

Ensure your JSON is still valid (Your IDE may help here)

Here is an example: ::

    {
        "plugin": {
            ...
        },
        "requiresServices": [
            ...
            "admin_doc"
            ...
        ],
        "admin_doc": {
            "docDir": "admin_doc",
            "docRst": "index.rst"
        }
    }

----

Create a new rst file in the admin_doc directory.

Place a unique reference link at the beginning of the file before the Title.

An example of the reference link above the section title: ::

        .. _learn_plugin_development_add_docs:

        =================
        Add Documentation
        =================

Add User Documentation
----------------------

.. note:: These steps are almost identical to the Admin documentation.

Create directory :file:`peek_plugin_tutorial/both-doc`: ::

    mkdir -p peek_plugin_tutorial/both-doc

----

Create the file :file:`index.rst`: within the directory
:file:`peek_plugin_tutorial/both-doc` with following content: ::

        ==========
        User Guide
        ==========

        This plugin can be used by clicking on the menu icon, etc.

----

Edit the file :file:`peek_plugin_tutorial/plugin_package.json`:

Add "both-doc" to the :code:`requiredServices` section so it looks like: ::

    "requiresServices": [
        ...
        "both-doc"
        ...
    ]

Add the "both-doc" section after requiresServices section: ::

    "both-doc": {
        "docDir": "both-doc",
        "docRst": "index.rst"
    }

----

Create a new rst file in the both-doc directory.

Place a unique reference link at the beginning of the file before the Title.

An example of the reference link above the section title: ::

        .. _learn_plugin_development_add_docs:

        =================
        Add Documentation
        =================

Add Developer Documentation
---------------------------

.. note:: These steps are almost identical to the Admin documentation.

Create directory :file:`peek_plugin_tutorial/doc-dev`: ::

    mkdir -p peek_plugin_tutorial/doc-dev

----

Create the file :file:`index.rst`: within the directory
:file:`peek_plugin_tutorial/doc-dev` with following content: ::

        =========
        Developer
        =========

        This plugins architecture is as follows <insert images, etc>

----

Edit the file :file:`peek_plugin_tutorial/plugin_package.json`:

Add "doc-dev" to the :code:`requiredServices` section so it looks like: ::

    "requiresServices": [
        ...
        "doc-dev"
        ...
    ]

Add the "doc-dev" section after requiresServices section: ::

    "doc-dev": {
        "docDir": "doc-dev",
        "docRst": "index.rst",
        "hasApi": false
    }

If your plugin has a public python API, then ensure :code:`hasApi` above is set to
:code:`true`.


Check Logic Service Config
--------------------------

The **logic** service builds the **admin** and **dev** documentation.

----

Edit the :file:`~/peek-logic-service.home/config.json` and ensure the following options are set.

-  Ensure :code:`frontend.docBuildEnabled` is set to :code:`true`, with no quotes

-  Ensure :code:`frontend.docBuildPrepareEnabled` is set to :code:`true`, with no quotes

Example: ::

        {
            ...
            "frontend": {
                ...
                "docBuildEnabled": true,
                "docBuildPrepareEnabled": true
            },
            ...
        }


Check Field Service Config
--------------------------

The **field** service builds the **user** documentation.

----

Edit the :file:`~/peek-field-service.home/config.json` and ensure the following options are set.

-  Ensure :code:`frontend.docBuildEnabled` is set to :code:`true`, with no quotes

-  Ensure :code:`frontend.docBuildPrepareEnabled` is set to :code:`true`, with no quotes

Example: ::

        {
            ...
            "frontend": {
                ...
                "docBuildEnabled": true,
                "docBuildPrepareEnabled": true
            },
            ...
        }



Check Office Service Config
---------------------------

The **office** service builds the **user** documentation.

----

Edit the :file:`~/peek-office-service.home/config.json` and ensure the following options are set.

-  Ensure :code:`frontend.docBuildEnabled` is set to :code:`true`, with no quotes

-  Ensure :code:`frontend.docBuildPrepareEnabled` is set to :code:`true`, with no quotes

Example: ::

        {
            ...
            "frontend": {
                ...
                "docBuildEnabled": true,
                "docBuildPrepareEnabled": true
            },
            ...
        }


Viewing Documentation
---------------------

The documentation from each peek plugin is loaded into three projects
by peek-logic (Admin, Development) and
peek-office (User).

The documentation packages are as follows

:Administration: peek_admin_doc:

:Development: peek_doc_dev

:User: peek_office_doc

----

To view the documentation, you can run :file:`watch_docs.sh`. This will generate the
documentation, serve it with a web server and live refresh a web page when a browser
is connected to it.

----

Locate the relevant python project. These instructions will demonstrate with the "Admin"
documentation.

Run the following to find the location of :code:`peek_admin_doc` ::

    python - <<EOF
    import peek_admin_doc
    print(peek_admin_doc.__file__)
    EOF

This will return the following, which you can get the location of :code:`peek_admin_doc`
from. ::

    peek@_peek ~ % python - <<EOF
    import peek_admin_doc
    print(peek_admin_doc.__file__)
    EOF

    /Users/peek/dev-peek/peek-admin-doc/peek_admin_doc/__init__.py

----

Navigate to :code:`peek_admin_doc` from the step above and run the following command: ::

    cd /Users/peek/dev-peek/peek-admin-doc/peek_admin_doc
    bash watch_docs.sh

----

In your browser, connect to the docs web server that :command:`watch_docs.sh` displays
at the end of its start. ::

    [I 200505 20:51:48 server:296] Serving on http://0.0.0.0:8020

----

.. note:: The :file:`watch-docs.sh` shell script won't always build a change in the
    toctree while running.  If you update the toctree or modify headings it is good
    practice to stop :file:`watch-docs.sh`, run :code:`rm -rf dist/*` and restart
    :file:`watch-docs.sh`.

.. note:: :file:`version` is the Peek version that is deployed. For example: 2.1.7

.. important:: Windows users must use **bash** and run the commands from the plugin
    root directory.

----

For more information on document formatting, please visit :ref:`restructured_text_cheat_sheet`.


What Next?
----------

Start developing your own plugins.
