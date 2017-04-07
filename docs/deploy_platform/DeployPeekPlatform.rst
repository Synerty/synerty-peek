.. _deploy_peek_platform:

====================
Deploy Peek Platform
====================

.. note:: The Windows or Debian requirements must be followed before following this guide.

This section describes how to deploy a peek platform release.

Peek is deployed into python virtual environments, a new virtual environment is created
for every deployment.

This ensures that each install is clean, has the right dependencies and there is a
rollback path (switch back to the old virtual environment).

To build your own platform release, see the following document
:ref:`package_peek_platform`.

Windows
-------

Deploy Virtual Environment
``````````````````````````

Open a PowerShell window.

----

Download the platform deploy script.
This is the only step in this section that requires the internet.

::

        $file = "deploy_platform_win.ps1"
        $uri = "https://raw.githubusercontent.com/Synerty/synerty-peek/master/$file";
        Invoke-WebRequest -Uri $uri -UseBasicParsing -OutFile $file;

----

Run the platform deploy script.  The script will complete with a print out of where the
new environment was deployed.  Ensure you update the **$dist** variable with the path to
your release.

The script will deploy to :file:`C:\\Users\\peek`.

::

        $dist = "C:\Users\peek\Downloads\peek_dist_win_#.#.#.zip"
        PowerShell.exe -ExecutionPolicy Bypass -File deploy_platform_win.ps1 $dist

.. note:: Once the script has completed running you will see the message "Activate the
    new environment from ...".

    These commands temporarily configure the environment to
    use the synerty-peek virtual environment that was just deployed.

    For a permanent change you will need to edit your 'Environment Variables'.  See
    :ref:`configuring_environment_variables` for more details.

----

The platform is now deployed.

.. _configuring_environment_variables:

Configuring Environment Variables
`````````````````````````````````

Follow this procedure to configure your system to use the synerty-peek virtual
environment that you have deployed.

These steps can also be followed to roll back to a previous deployed synerty-peek virtual
environment.

----

Go to 'System Properties' and select 'Environment Variables...'

.. image:: EnvVar-SystemProperties.jpg

----

In the 'System Variables' section, highlight 'PATH' and select 'Edit...'

.. image:: EnvVar-EnvironmentVariables.jpg

----

In the Edit window select 'New' and paste the script:

::

        C:\Users\peek\synerty-peek-#.#.#\Scripts

Click 'Move Up'.  It is important that the variable you have added is above any other
variables that contain similar script or programs.

.. image:: EnvVar-EditVariables.jpg

----

Select 'OK' on all three windows

----

Confirm that your changes have worked.  In a new command prompt enter the bash shell
and run:

::

        which python

It should return the variable you have added into the PATH

.. image:: EnvVar-WhichPython.jpg

Plugin Development
``````````````````

Follow these steps if you are already developing peek-plugin's on this machine.

For every new peek platform environment that is deployed, your development plugins will
require setting up in the new environment.

----

Open the command prompt and enter the bash shell

----

Change to the plugin root directory

----

Run the following command:

::

        python setup.py develop


----

Repeat for each plugin being developed

NativeScript Development
````````````````````````

Follow these steps if you are developing with NativeScript

----

Open the command prompt and enter the bash shell

----

Run the following command:

::

        npm -g install nativescript


Run Deployed Peek Services
``````````````````````````

Run the platform services from bash with the following commands: ::

        # Check to ensure we're using the right python
        which python

        # Run the peek server
        run_peek_server

        # Run the peek client
        run_peek_client

        # Run the peek agent
        run_peek_agent

        # Run the peek worker
        run_peek_worker


Linux
-----

Run all commands from a terminal window remotely via ssh.

Deploy Virtual Environment
``````````````````````````

Download the platform deploy script.

.. note:: This is the only step in this section that requires the internet.

::

        file="deploy_platform_deb8.sh"
        uri="https://raw.githubusercontent.com/Synerty/synerty-peek/master/$file"
        wget $uri


Run the platform deploy script.  The script will complete with a print out of where the
new environment was deployed.  Ensure you update the **$dist** variable with the path to
your release.

The script will deploy to :file:`/home/peek/`.

::

        dist="/home/peek/Downloads/peek_dist_lin_#.#.#.zip"
        ./deploy_platform_deb8.sh $dist

Once the script has completed running you will see the message "Activate the
new environment edit ...".

This command configures the environment to use the synerty-peek virtual environment
that was just deployed.

----

The platform is now deployed.

What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
