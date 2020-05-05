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

Create directory :file:`peek_plugin_tutorial/doc-admin`: ::

    mkdir -p peek_plugin_tutorial/doc-admin

----

Create the file :file:`index.rst`: within the directory
:file:`peek_plugin_tutorial/doc-admin` with following content: ::

        ==============
        Administration
        ==============

        The Peek-Plugin-Tutorial plugin performs the following:

        -   Point 1

        -   Point 2

----

Edit the file :file:`peek_plugin_tutorial/plugin_package.json`:

Add "doc-admin" to the :code:`requiredServices` section so it looks like: ::

    "requiresServices": [
        ...
        "doc-admin"
        ...
    ]

Add the "doc-admin" section after requiresServices section: ::

    "doc-admin": {
        "docDir": "doc-admin",
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
            "doc-admin"
            ...
        ],
        "doc-admin": {
            "docDir": "doc-admin",
            "docRst": "index.rst"
        }
    }



Add User Documentation
----------------------

.. note:: These steps are almost identical to the Admin documentation.

Create directory :file:`peek_plugin_tutorial/doc-user`: ::

    mkdir -p peek_plugin_tutorial/doc-user

----

Create the file :file:`index.rst`: within the directory
:file:`peek_plugin_tutorial/doc-user` with following content: ::

        ==========
        User Guide
        ==========

        This plugin can be used by clicking on the menu icon, etc.

----

Edit the file :file:`peek_plugin_tutorial/plugin_package.json`:

Add "doc-user" to the :code:`requiredServices` section so it looks like: ::

    "requiresServices": [
        ...
        "doc-user"
        ...
    ]

Add the "doc-user" section after requiresServices section: ::

    "doc-user": {
        "docDir": "doc-user",
        "docRst": "index.rst"
    }



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


Check Peek Server Config
------------------------

The **peek-server** service builds the **admin** and **dev** documentation.

----

Edit the :file:`~/peek-server.home/config.json` and ensure the following options are set.

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



Check Peek Client Config
------------------------

The **peek-client** service builds the **user** documentation.

----

Edit the :file:`~/peek-client.home/config.json` and ensure the following options are set.

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
by peek-server (Admin, Development) and
peek-client (User).

The documentation packages are as follows

:Administration: peek_doc_admin:

:Development: peek_doc_dev

:User: peek_doc_user

----

To view the documentation, you can run :file:`watch_docs.sh`. This will generate the
documentation, serve it with a web server and live refresh a web page when a browser
is connected to it.

----

Locate the relevant python project. These instructions will demonstrate with the "Admin"
documentation.

Run the following to find the location of :code:`peek_doc_admin` ::

    python - <<EOF
    import peek_doc_admin
    print(peek_doc_admin.__file__)
    EOF

This will return the following, which you can get the location of :code:`peek_doc_admin`
from. ::

    peek@peek ~ % python - <<EOF
    import peek_doc_admin
    print(peek_doc_admin.__file__)
    EOF

    /Users/peek/dev-peek/peek-doc-admin/peek_doc_admin/__init__.py

----

Navigate to :code:`peek_doc_admin` from the step above and run the following command: ::

    cd /Users/peek/dev-peek/peek-doc-admin/peek_doc_admin
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


reStructuredText Cheat Sheet
----------------------------

The following tips should help you get started writing reStructuredText

.. _learn_plugin_development_add_docs_sections:

Sections
````````

Sections are created by underlining (and optionally overlining) the section title with a
punctuation character, at least as long as the text and a blank line before and after.

These section titles and headings will be used to create the contents when the
documentation is built.

.. note:: The Page Title can be seen at the top of this page,
        :ref:`learn_plugin_development_add_docs`.

        Header 1 can be seen at the top of this section,
        :ref:`learn_plugin_development_add_docs_sections`.

Header 2
````````

Sample paragraph.

Header 3
~~~~~~~~

Sample paragraph.

----

If you expand the page contents you will notice that "Header 3" isn't available in the
page contents.  This is because the maxdepth of the toctree is '2'.
see :ref:`learn_plugin_development_add_docs_toctree`

This is an example of the "Add Documentation"(Page Title), "Sections"(Header 1), "Header
2", and "Header 3" raw text:

::

        =================
        Add Documentation
        =================

        Sections
        --------

        Header 2
        ````````

        Header 3
        ~~~~~~~~


Instruction Divider
-------------------

Four dashes with a leading blank line and following blank line.

----

::

        ----


Text Formatting
---------------

The following roles don’t do anything special except formatting the text in a different
style.

Inline Markups
``````````````

Inline markup is quite simple, some examples:

- one asterisk: :code:`*text*`, *text* for emphasis (italics),
- two asterisks: :code:`**text**`, **text** for strong emphasis (boldface), and
- backquotes: :code:`:code:`text``, :code:`text` for code samples.

Files
`````

The name of a file or directory. Within the contents, you can use curly braces to
indicate a “variable” part, for example:

:file:`learn_plugin_development/LearnPluginDevelopment_AddDocs.rst`

::

       :file:`learn_plugin_development/LearnPluginDevelopment_AddDocs.rst`


Reference Links
```````````````

Reference link names must be unique throughout the entire documentation.

Place a label directly before a section title.

The link name will match the section title.

:ref:`learn_plugin_development_add_docs`

An example of the reference link above the section title:

::

        .. _learn_plugin_development_add_docs:

        =================
        Add Documentation
        =================

An example of the reference link:

::

        :ref:`learn_plugin_development_add_docs`


URL Link
````````

A raw link can be entered without a title, but if a title is entered be sure to leave a
space before the URL address:

`Synerty <http://www.synerty.com/>`_

::

    `Synerty <http://www.synerty.com/>`_


Code Block
``````````

Two semi-colons followed by a blank line and two leading tabs for each line of code.
The code block is ended by contents written without leading tabs.

::

        this.code


::

                ::

                        this.code


Bullets
```````

- First point

- Second point

::

        - First point

        - Second point


Numbered Lists
``````````````

#.  First point

#.  Second point

::

        #.  First point

        #.  Second point


Directives
----------

Directives are indicated by an explicit markup start '.. ' followed by the directive
type, two colons, and whitespace (together called the "directive marker"). Directive
types are case-insensitive single words.

Images
``````

The filename given must either be relative to the source file, or absolute which means
that they are relative to the top source directory.

.. image:: synerty_logo_400x800.png

::

        .. image:: synerty_logo_400x800.png


Admonitions
```````````

Admonitions are specially marked "topics" that can appear anywhere an ordinary body
element can. They contain arbitrary body elements. Typically, an admonition is rendered
as an offset block in a document, sometimes outlined or shaded, with a title matching
the admonition type.

.. note:: Multi
    Line
    NOTE

    Mutli Parapgraph

    -     Can contain bullets

    #.    numbers points

    and references: :ref:`learn_plugin_development_add_docs`

::

        .. note:: Multi
            Line
            NOTE

            Mutli Parapgraph

            -     Can contain bullets

            #.    numbers points

            and references: :ref:`learn_plugin_development_add_docs`


.. _learn_plugin_development_add_docs_toctree:

TOC tree
````````

This directive inserts a table of contents at the current location, including sub-TOC
trees.

Document titles in the toctree will be automatically read from the title of the
referenced document.

----

Here is an example:

::

        =====================
        Example Documentation
        =====================

        .. toctree::
            :maxdepth: 2
            :caption: Contents:

            intro
            strings
            datatypes
            numeric
            (many more documents listed here)


.. _learn_plugin_development_add_docs_docstring_format:

Docstring Format
````````````````

This extension :file:`sphinx.ext.autodoc`, can import the modules you are documenting,
and pull in documentation from docstrings in a semi-automatic way.

.. warning:: autodoc imports the modules to be documented. If any modules have side
    effects on import, these will be executed by autodoc when sphinx-build is run. If
    you document scripts (as opposed to library modules), make sure their main routine
    is protected by a if __name__ == '__main__' condition.

A docstring is a string literal that occurs as the first statement in a module,
function, class, or method definition.

All modules should normally have docstrings, and all functions and classes exported by
a module should also have docstrings. Public methods (including the __init__
constructor) should also have docstrings. A package may be documented in the module
docstring of the __init__.py file in the package directory.

Example:

::

        """
        This is a reST style.

        :param param1: this is a first param
        :param param2: this is a second param
        :returns: this is a description of what is returned
        :raises keyError: raises an exception
        """


Below is an abstract from file
:file:`peek_plugin_tutorial/_private/server/ServerEntryHook.py`, create in the step
:ref:`learn_plugin_development_add_server_add_file_ServerEntryHook`.

::

        def load(self) -> None:
            """ Start

            This will be called to start the plugin.
            Start, means what ever we choose to do here. This includes:

            -   Create Controllers

            -   Create payload, observable and tuple action handlers.

            """
            logger.debug("Loaded")


Below is an abstract from file
:file:`peek-plugin-base/peek_plugin_base/PeekPlatformCommonHookABC.py`

::

        class PeekPlatformCommonHookABC(metaclass=ABCMeta):

            @abstractmethod
            def getOtherPluginApi(self, pluginName:str) -> Optional[object]:
                """ Get Other Plugin Api

                Asks the plugin for it's api object and return it to this plugin.
                The API returned matches the platform service.

                :param pluginName: The name of the plugin to retrieve the API for
                :return: An instance of the other plugins API for this Peek Platform
                         Service.

                """


What Next?
----------

Start developing your own plugins.
