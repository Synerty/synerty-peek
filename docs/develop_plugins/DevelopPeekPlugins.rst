.. _develop_peek_plugins:

====================
Develop Peek Plugins
====================

Synerty recommends the Atlassian suite of developer tools.

Bitbucket to manage and share your Git repositories

:URL: `<https://bitbucket.org>`_

SourceTree to visually manage and interact with your Git repositories

:URL: `<https://www.sourcetreeapp.com>`_

Bitbucket can be integrated with Jira (issue management)
 and Bamboo (continuous integration).

Developing a New Peek Plugin
----------------------------

If you're creating a new plugin you can copy from "peek-plugin-noop" and rename.

Clone and Copy peek-plugin-noop
```````````````````````````````

:Clone: `<https://github.com/Synerty/peek-plugin-noop.git>`_

Go to, peek-plugin-noop repository on Bitbucket

.. image:: DevPlugin-CloneSTree.jpg

----

Clone the repository

#.  This URL will be automatically populated from Bitbucket.
#.  **Alter this name to end with peek-plugin-example.**

.. image:: DevPlugin-Clone.jpg

----

Remove the git references into new directory structure, run the following commands in the bash shell: ::

        cd peek-plugin-example
        rm -rf .git .idea .vscode

Rename to New Plugin
````````````````````

Edit the **"rename_plugin.sh"** file in the plugin root project folder.

Update the variables near the top with the new names: ::

        caps="EXAMPLE"
        underscore="_example"
        hyphen="-example"
        camelL="example"
        camelU="Example"

----

Run "rename_plugin.sh", run the following command in the bash shell: ::

        bash ./rename_plugin.sh

----

Remove the "rename_plugin.sh" script, run the following command in the bash shell: ::

        rm rename_plugin.sh

Add to GIT
``````````

Create new repository on GitHub.

.. image:: DevPlugin-newRepo.jpg

.. note:: Bitbucket will also provide instructions on how to do the following.

Get the git url, it will look something like: ::

        https://{account username}@bitbucket.org/{account username}/example.git

----

Run the following commands in bash shell to add the plugin to the git repository: ::

        git init
        git add .

----

Create your first commit: ::

        git commit -m "Scaffolded example plugin"

----

Add remote: ::

        git remote add origin {insert your GitHub link}

----

Push your changes: ::

        git push -u origin master

Developing an Existing Peek Plugin
----------------------------------

Fork and Clone plugin
`````````````````````

Create your own fork of the plugins if you don't already have one.

.. warning:: Be sure to check your fork syncing is enabled and up to date,
    Otherwise you'll run into issues.

.. image:: DevPlugin-Fork.jpg

----

Clone the fork

.. image:: DevPlugin-Clone.jpg

Setup an IDE
---------

An integrated development environment (IDE), is an advanced text editor with the
following features.

*   Syntax highlighting
*   Error highlighting
*   Integrating build tools
*   Debugging
*   Linting - checking code for quality.

The Peek documentation has documentation for two IDEs:

*   :ref:`setup-pycharm-ide`_
*   :ref:`setup-vs-code-ide`_


Developing
----------

Setup Plugin for Development
````````````````````````````

Run the following command in the bash shell: ::

        python setup.py develop

Configure Services
``````````````````

Update the config for services you're testing: ::

            "plugin": {
                "enabled": [
                    "peek_plugin_example"
                ]
            }

----

Configure your developing software to use the virtual environment you wish to use

Here is an example of the setting in PyCharm:

.. image:: DevPlugin-projectInterpreter.jpg

----

Restart the services that use the plugin

.. NOTE:: The plugins that aren't being developed should be installed as per
    :ref:`deploy_peek_plugins`

----

This is an example of running the server service in debug mode using **PyCharm**

Under the drop down "Run" then "Edit Configurations..."

1.  Add new configuration, select "Python"
2.  Update the "Name:"
3.  Locate the script you wish to run
4.  Check that the "Python Interpreter" is correct

.. image:: DevPlugin-debugRunServer.jpg
