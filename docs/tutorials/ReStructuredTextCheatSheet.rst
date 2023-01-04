.. _restructured_text_cheat_sheet:

============================
ReStructuredText Cheat Sheet
============================

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
``````````

Directives are indicated by an explicit markup start '.. ' followed by the directive
type, two colons, and whitespace (together called the "directive marker"). Directive
types are case-insensitive single words.

Images
``````

The filename given must either be relative to the source file, or absolute which means
that they are relative to the top source directory.

.. image:: peek_plugin_tutorial/synerty_logo_400x800.png

::

        .. image:: peek_plugin_tutorial/synerty_logo_400x800.png


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
:file:`peek_plugin_tutorial/_private/server/LogicEntryHook.py`, create in the step
:ref:`learn_plugin_development_add_logic_add_file_LogicEntryHook`.

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

                Asks the plugin for its api object and return it to this plugin.
                The API returned matches the platform service.

                :param pluginName: The name of the plugin to retrieve the API for
                :return: An instance of the other plugins API for this Peek Platform
                         Service.

                """
