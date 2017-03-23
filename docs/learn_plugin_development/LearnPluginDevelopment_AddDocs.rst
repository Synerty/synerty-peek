.. _learn_plugin_development_add_docs:

========================
Add Documentation (TODO)
========================

Why does a plugin need documentation? A peek plugin needs documentation to help
developers focus on what it needs to do, and allow other developers to use and APIs it
shares.

Then it helps Peek admins determine the plugins requirements and if the need it.

Documenting software can be a complicated and tedous task. There are many things to
consider:

*   Documentation must be versioned with the code, making sure features match, etc.

*   Documentation must be availible for each version of the code, your documentation
    will branch as many times as your code will, 1.0, 1.1, etc

*   Documentation must be updated as features are added and changed in the code.

These are a few of the conundrums around the complexity of software documentation.
Fortunately there are some fantastic tools around to solve these issues, and you're
reading the result of those tools right now.

----------------

@brenton NOTES:

Explain the tools involved.


An example document on directives, image, :ref:, url link, :code:``, :file:``, bullets
numbered lists, code blocks, titles, toctree, docstring format

----

:file:`file directive` ::

    :file:`file directive`

.. note:: Multi
          Line
          NOTE

          Mutli Parapgraph

          -     It can even have bullt

          #.    and numbers

::

    .. note:: Multi Line
              NOTE

              Mutli Parapgraph

              -     It can even have bullt
              #.    and numbers

----


Instructions on how to setup the documentation, copy conf.py from synerty-peek

#.  Introduction + TOC

    #.  Functional design (What the plugin does)

    #.  How it works

    #.  Tutorial API

