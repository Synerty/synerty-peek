.. _learn_plugin_development_add_docs:

========================
Add Documentation (TODO)
========================

Why does a plugin need documentation? A peek plugin needs documentation to help
developers focus on what it needs to do, and allow other developers to use and APIs it
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

----------------

@brenton NOTES:

Explain the tools involved.


An example document on directives, image, :ref:, url link,

:code:``, :file:``

, bullets, numbered lists, code blocks, titles, toctree, docstring format

----

Sections
--------

Sections are created by underlining (and optionally overlining) the section title with a
punctuation character, at least as long as the text and a blank line before and after.

These section titles and headings will be used to create the contents when the
documentation is built.

.. note:: The Page Title can be seen at the top of this page, "Add Documentation".
    Adding a sample of a page title creates a new page title in the contents page.

Header 1
--------

Header 2
````````

Header 3
~~~~~~~~

If you expand the page contents you will notice that "Header 3" isn't available in the
page contents.  This is because the maxdepth of the toctree is '2'.
see :ref:`learn_plugin_development_add_docs_toctree`

This is an example of the "Page Title", "Header 1", "Header 2", and "Header 3" raw text:

::

        =================
        Add Documentation
        =================

        Header 1
        --------

        Header 2
        ````````

        Header 3
        ~~~~~~~~


Instruction Divider
-------------------

----

::

        ----


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


Text Formatting
---------------

The following roles don’t do anything special except formatting the text in a different
style:

Inline Markups
``````````````

Inline markup is quite simple, some examples:

- one asterisk: :code:`*text*`, *text* for emphasis (italics),
- two asterisks: :code:`**text**`, **text** for strong emphasis (boldface), and
- backquotes: :code:`:code:`text``, :code:`text` for code samples.

Files
~~~~~

The name of a file or directory. Within the contents, you can use curly braces to
indicate a “variable” part, for example:

:file:`learn_plugin_development/LearnPluginDevelopment_AddDocs.rst`

::

        :file:`learn_plugin_development/LearnPluginDevelopment_AddDocs.rst`


Reference Links
~~~~~~~~~~~~~~~

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
~~~~~~~~



Code Block
``````````


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


.. _learn_plugin_development_add_docs_toctree:

toctree TODO
------------



Docstring Format TODO
---------------------


Document Generator TODO
-----------------------

Sphinx is a tool that makes it easy to create intelligent and beautiful documentation.

The following sections go on to guide the reader to setup Sphinx Document Generator.

.. important:: Windows users must use **bash** and run the commands from the plugin
    root directory.

Documentation Configuration
```````````````````````````

The build configuration file has already been developed by Synerty.

Create Directory :file:`docs`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This folder will contain all of the files used to build the documentation.  Make sure
you add everything in this directory to git.

Create directory :file:`docs`, run the following command:

::

        mkdir -p docs


Copy file :file:`docs/conf.py`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



Copy file :file:`conf.py` from synerty-peek, run the following command:

.. note:: Make sure you update the release version in the following command.

::

        cp ~/synerty-peek-#.#.#/docs/conf.py docs/conf.py


Edit file :file:`docs/conf.py`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



::

        __project__ = 'Synerty Peek'
        __copyright__ = '2016, Synerty'
        __author__ = 'Synerty'
        __version__ = '0.2.10'


Required Files
``````````````

Add file :file:`modules.rst'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create :file:`modules.rst`, and populate it with the following

::

        {insert plugin name} package
        ============================

        Module contents
        ---------------

        .. automodule:: {insert plugin name}
            :members:
            :undoc-members:
            :show-inheritance:


Add file :file:`index.rst`
~~~~~~~~~~~~~~~~~~~~~~~~~~

Create :file:`index.rst`, and populate it with the following

::

        ==================================
        {insert plugin name} Documentation
        ==================================

        .. toctree::
            :maxdepth: 3
            :caption: Contents:


        Indices and tables
        ==================

        * :ref:`genindex`
        * :ref:`modindex`
        * :ref:`search`


Build Documentation
-------------------

Debug Documentation
-------------------

Synerty has written a shell script to build run Sphinx API that builds the
documentation when a file is modified.

Deploy :file:`watch-docs.sh` Shell Script
`````````````````````````````````````````


Copy file :file:`docs/watch-docs.sh`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Copy file :file:`watch-docs.sh` from synerty-peek, run the following command:

.. note:: Make sure you update the release version in the following command.

::

        cp ~/synerty-peek-#.#.#/docs/watch-docs.sh docs/watch-docs.sh


Edit file :file:`watch-docs.sh`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Remove line from file :file:`watch-docs.sh`:

::

        ARGS="$ARGS --watch `modPath 'peek_plugin_base'`"


Run :file:`watch-docs.sh`
`````````````````````````



----


Instructions on how to setup the documentation, copy conf.py from synerty-peek

#.  Introduction + TOC

    #.  Functional design (What the plugin does)

    #.  How it works

    #.  Tutorial API

