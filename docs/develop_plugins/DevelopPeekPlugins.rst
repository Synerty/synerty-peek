.. _develop_peek_plugins:

====================
Develop Peek Plugins
====================

Creating Peek Plugin
--------------------

If you're creating a new plugin you can copy from "peek-plugin-noop" and rename.

Clone and Copy peek-plugin-noop
```````````````````````````````

:Clone: `<https://github.com/Synerty/peek-plugin-noop.git>`_

----

Clone the repository

.. image:: DevPlugin-Clone.jpg

----

Copy into new directory structure, run the following commands in the bash shell: ::

        cp -pr peek-plugin-noop peek-plugin-example
        cd peek-plugin-example
        mv peek_plugin_noop/ peek_plugin_example/
        rm -rf .git .idea .vscode

Rename the Plugin
`````````````````

Update "rename_plugin.sh" with new names: ::

        caps="EXAMPLE"
        underscore="_example"
        hyphen="-example"
        camelL="example"
        camelU="Example"

----

Run "rename_plugin.sh", run the following command in the bash shell: ::

        ./rename_plugin.sh

----

Remove the "rename_plugin.sh" script, run the following command in the bash shell: ::

        rm rename_plugin.sh

Add to GIT
``````````

Create new repository on GitHub.

.. image:: DevPlugin-newRepo.jpg

Your link will look something like: ::

        https://github.com/synerty/example.git

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

Edit Existing Plugin
--------------------

You will need to already have a GitHub account to create a fork of the plugin(s) you plan
to edit.

Fork and Clone plugin
`````````````````````

Create a fork of the plugin

.. image:: DevPlugin-Fork.jpg

----

Clone the fork

.. image:: DevPlugin-Clone.jpg

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
